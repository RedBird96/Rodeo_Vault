// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../Basic.sol";
import "../interfaces/core/ILendingLogic.sol";
import "../interfaces/core/IVault.sol";
import "../interfaces/aaveV3/IAaveOracle.sol";
import "../interfaces/core/IFlashloanHelper.sol";
import "../1inch/OneinchCaller.sol";
import "../interfaces/aaveV3/IPoolV3.sol";

contract Strategy is Basic, OneinchCaller {

    using SafeERC20 for IERC20;
    // The token contract used to record the proportional equity of users.
    address public vault;
    // Specify the operational logic for the lending protocol,
    // where the corresponding method will be delegatecalled when performing operations.
    address public lendingLogic;
    // The intermediary contract for executing flash loan operations.
    address public flashloanHelper;
    // The amount of performance fees recorded after profits are generated in the strategy pool,
    // collected in the core asset stETH.
    uint256 public revenue;
    // The exchange rate used during user deposit and withdrawal operations.
    uint256 public exchangePrice;
    // The exchange rate used when calculating performance fees.
    // Performance fees will be recorded when the real exchange rate exceeds this rate.
    uint256 public revenueExchangePrice;
    // The percentage of performance fees collected, where 1000 corresponds to 10%.
    uint256 public revenueRate;
    // The safe debt collateralization ratio for the entire strategy pool.
    uint256 public safeAggregatedRatio;

    uint256 public safeRatio;
    uint256 public logicDepositAmount;
    uint256 public logicWithdrawAmount;
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");

    // arbitrum
    address public constant A_WSTETH_ADDR_AAVEV3 = 0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf;
    address public constant D_WETH_ADDR_AAVEV3 = 0x77CA01483f379E58174739308945f044e1a764dc;
    IAaveOracle public constant AAVE_ORACLE_V3 = IAaveOracle(0xb56c2F0B653B2e0b10C9b928C8580Ac5Df02C7C7);
    IPoolV3 public constant AAVE_POOL_V3 = IPoolV3(0x794a61358D6845594F94dc1DB02A252b5b4814aD);

    enum MODULE {
        LEVERAGE_MODE,
        DELEVERAGE_MODE
    }

    event UpdateExchangePrice(uint256 newExchangePrice, uint256 newRevenue);
    event Deposit(uint256 _amount);
    event Withdraw(uint256 _amount);
    event Leverage(uint256 debitAmount, uint256 borrowAmount);
    event Deleverage(uint256 repayAmount, uint256 withdrawAmount);

    modifier onlyVault() {
        require(msg.sender == vault, "Only vault can call this method");
        _;
    }

    /**
     * @dev Initialize various parameters of the Strategy contract.
     */
    function __Strategy_init(
        address _vault,
        address _lendingLogic,
        address _flashloanHelper,
        uint256 _safeAggregatedRatio,
        uint256 _safeRatio
    ) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init();
        require(_vault != address(0) && _flashloanHelper != address(0) && _lendingLogic != address(0),
             "Invalid contract address!");
        lendingLogic = _lendingLogic;
        vault = _vault;
        flashloanHelper = _flashloanHelper;
        exchangePrice = 1e18;
        require(
            _safeAggregatedRatio >= MIN_SAFE_AGGREGATED_RATIO && 
            _safeAggregatedRatio < MAX_SAFE_AGGREGATED_RATIO,
            "Invalid aggregated Ratio!"
        );
        safeRatio = _safeRatio;
        safeAggregatedRatio = _safeAggregatedRatio;
        isAdmin[msg.sender] = true;
        enterExitProtocol(true);
        approveToken(WETH_ADDR);
        approveToken(WSTETH_ADDR);
    }

    /**
     * @dev Add admin address 
     */
    function addAdmin(address _admin) public onlyOwner {
        require(_admin != address(0), "Invalid address!");
        isAdmin[_admin] = true;
    }

    /**
     * @dev remove admin permission
     */ 
    function removeAdmin(address _admin) public onlyOwner {
        require(_admin != address(0), "Invalid address!");
        isAdmin[_admin] = false;
    }

    /**
     * @dev Update the address of the intermediary contract used for flash loan operations.
     * @param _newFlashloanHelper The new contract address.
     */
    function updateFlashloanHelper(address _newFlashloanHelper) external onlyOwner {

        require(_newFlashloanHelper != address(0), "Wrong flashloanHelper!");
        flashloanHelper = _newFlashloanHelper;
    }

    /**
     * @dev Update the safe line for aggregation.
     * @param _safeAggregatorRatio The safe line for aggregation.
     * @param _safeRatio safe ratio
     */
    function updateSafeRatio(uint256 _safeAggregatorRatio, uint256 _safeRatio) external onlyOwner {
        require(
            _safeAggregatorRatio >= MIN_SAFE_AGGREGATED_RATIO && 
            _safeAggregatorRatio < MAX_SAFE_AGGREGATED_RATIO,
            "Invalid aggregated Ratio!"
        );
        safeAggregatedRatio = _safeAggregatorRatio;
        safeRatio = _safeRatio;
    }
    
    /**
     * @dev Retrieve the amount of net assets in the protocol.
     * @return net The amount of net assets.
     */
    function getProtocolNetAssets() public view returns (uint256 net) {
        (uint256 wstEthAmount, uint256 debtEthAmount) = 
            ILendingLogic(lendingLogic).getProtocolAccountData(address(this));
        net = wstEthAmount - debtEthAmount;
    }    

    /**
     * @dev Retrieve the ratio of debt to collateral, considering wstETH and ETH as assets with a 1:1 ratio.
     * @return ratio The debt collateralization ratio, where 1e18 represents 100%.
     */
    function getProtocolRatio() public view returns (uint256 ratio) {
        
        (uint256 wstEthAmount, uint256 debtEthAmount) = 
            ILendingLogic(lendingLogic).getProtocolAccountData(address(this));
        ratio = debtEthAmount * 1e18 / wstEthAmount;
    }

    /**
     * @dev Retrieve the debt collateralization ratio of this strategy pool in the lending protocol,
     * using the oracle associated with that lending protocol.
     * @return collateralRatio The debt collateralization ratio, where 1e18 represents 100%.
     * @return isOK This bool indicates whether the safe collateralization ratio has been exceeded.
     * If true, it indicates the need for a deleveraging operation.
     */
    function getProtocolCollateralRatio() public view returns (uint256 collateralRatio, bool isOK) {
        collateralRatio = ILendingLogic(lendingLogic).getProtocolCollateralRatio(address(this));
        isOK = safeRatio + PERMISSIBLE_LIMIT > collateralRatio ? true : false;
    }    

    /**
     * @dev Retrieve the amount of assets in all lending protocols involved in this contract for the strategy pool.
     * @return netAssets The total amount of net assets.
     */
    function getNetAssets() public view returns (uint256) {
        (,, uint256 currentNetAssets_,) = ILendingLogic(lendingLogic).getNetAssetsInfo(address(this));
        return currentNetAssets_ + IERC20(WSTETH_ADDR).balanceOf(address(this)) - revenue;
    }

    /**
     * @notice To prevent the contract from being attacked, the exchange rate of the contract
     * is intentionally made non-modifiable by unauthorized addresses. Users may incur some
     * price losses, but under normal circumstances, these losses are negligible and can be
     * covered by profits in a very short period of time.
     * @dev Update the exchange rate between the share token and the core asset stETH.
     * If the real price has increased, record the profit portion proportionally.
     * @return newExchangePrice The new exercise price.
     * @return newRevenue The new realized profit.
     */
    function updateExchangePrice() public onlyAdmin returns (uint256 newExchangePrice, uint256 newRevenue) {
        uint256 totalSupply_ = IVault(vault).totalSupply();
        if (totalSupply_ == 0) {
            return (exchangePrice, revenue);
        }
        uint256 currentNetAssets_ = getNetAssets();
        newExchangePrice = currentNetAssets_ * 1e18 / totalSupply_;
        if (newExchangePrice > revenueExchangePrice) {
            if (revenueExchangePrice == 0) {
                revenueExchangePrice = newExchangePrice;
                exchangePrice = newExchangePrice;
                return (exchangePrice, revenue);
            }
            uint256 newProfit_ = currentNetAssets_ - ((exchangePrice * totalSupply_) / 1e18);
            newRevenue = (newProfit_ * revenueRate) / 1e4;
            revenue += newRevenue;
            exchangePrice = ((currentNetAssets_ - newRevenue) * 1e18) / totalSupply_;
            revenueExchangePrice = exchangePrice;
        } else {
            exchangePrice = newExchangePrice;
        }

        emit UpdateExchangePrice(newExchangePrice, newRevenue);
    }    

    /**
     * @dev The asset deposit operation is called by the Vault contract on behalf of the user.
     * @param _amount The amount of stETH deposited by the user.
     * @param operateExchangePrice The exchange rate used during the deposit operation.
     */
    function deposit(uint256 _amount) external onlyVault returns (uint256 operateExchangePrice) {
        require(_amount > 0, "deposit: Invalid amount.");
        operateExchangePrice = exchangePrice;
        IERC20(WSTETH_ADDR).safeTransferFrom(vault, address(this), _amount);

        emit Deposit(_amount);
    }

    /**
     * @dev The asset withdraw operation is called by the Vault contract on behalf of the user.
     * @param _amount The amount of stETH the user wants to withdraw.
     * @param withdrawAmount The actual amount of stETH withdrawn by the user.
     */
    function withdraw(uint256 _amount) external onlyVault returns (uint256 withdrawAmount) {
        require(_amount > 0, "withdraw: Invalid amount.");
        IERC20(WSTETH_ADDR).safeTransfer(vault, _amount);
        withdrawAmount = _amount;

        emit Withdraw(_amount);
    }

    function getAvailableLogicBalance() external view onlyAdmin returns(uint256 balance) {
        
        balance = IERC20(WSTETH_ADDR).balanceOf(address(this));
    }

    function getAssestPrice(address _token) public view returns(uint256 price) {
        price = AAVE_ORACLE_V3.getAssetPrice(_token);
    }

    /**
    * @dev adjust position leverage according the flashloan
    * @param _stETHDepositAmount stETH amount for deposit
    * @param _wEthDebtAmount wETH amount for debt on flashloan
    * @param _swapData swap bytes data 
    */
    function leverage(
        uint256 _stETHDepositAmount,
        uint256 _wEthDebtAmount,
        bytes calldata _swapData,
        uint256 _minimumAmount
    ) external onlyAdmin {

        require(_stETHDepositAmount >= MINIMUM_AMOUNT, "Must bigger than minimum amount");
        uint256 balance = IERC20(WSTETH_ADDR).balanceOf(address(this));
        require(balance >= 0 && balance >= _stETHDepositAmount, "Insufficient wstETH balance");

        logicDepositAmount = _stETHDepositAmount;

        bytes memory dataBytes = abi.encode(
            uint8(MODULE.LEVERAGE_MODE),
            _wEthDebtAmount,
            _minimumAmount,
            _swapData
        );

        IFlashloanHelper(flashloanHelper).flashLoan(
            IERC3156FlashBorrower(
                address(this)), 
                WETH_ADDR, 
                _wEthDebtAmount, 
                dataBytes
        );

    }

    /**
    * @dev adjust position deleverage according the flashloan
    * @param _stETHWithdrawAmount stETH token withdraw amount
    * @param _wEthDebtDeleverageAmount wETH amount for debt on flashloan
    * @param _swapData swap bytes data 
    */
    function deleverageAndWithdraw(
        uint256 _stETHWithdrawAmount,
        uint256 _wEthDebtDeleverageAmount,
        bytes calldata _swapData,
        uint256 _minimumAmount
    ) external onlyVault returns(uint256) {

        require(_stETHWithdrawAmount >= MINIMUM_AMOUNT, "Must bigger than minimum amount");
        (uint256 totalAssets,,,) = ILendingLogic(lendingLogic).getNetAssetsInfo(address(this));
        require(totalAssets >= _wEthDebtDeleverageAmount, "Not enough collaboration");

        uint256 wEthPrice_ = getAssestPrice(WETH_ADDR);
        uint256 wstEthPrice_ = getAssestPrice(WSTETH_ADDR);
        uint256 wEthBal = IERC20(WETH_ADDR).balanceOf(address(this));
        require(_stETHWithdrawAmount * wstEthPrice_ <= wEthBal * wEthPrice_, "Not enough balance");

        logicWithdrawAmount = _stETHWithdrawAmount;
        bytes memory dataBytes = abi.encode(
            uint8(MODULE.DELEVERAGE_MODE),
            _wEthDebtDeleverageAmount,
            _minimumAmount,
            _swapData
        );
        
        uint256 beforeBalance = IERC20(WSTETH_ADDR).balanceOf(address(this));
        IFlashloanHelper(flashloanHelper).flashLoan(
            IERC3156FlashBorrower(
                address(this)), 
                WETH_ADDR, 
                _wEthDebtDeleverageAmount, 
                dataBytes
        );
        uint256 afterBalance = IERC20(WSTETH_ADDR).balanceOf(address(this));
        uint256 diffBal = afterBalance - beforeBalance;
        IERC20(WSTETH_ADDR).safeTransfer(vault, diffBal);
        return diffBal;
    }

    /**
    * @dev adjust position deleverage according the flashloan
    * @param _stETHWithdrawAmount stETH token withdraw amount
    * @param _wEthDebtDeleverageAmount wETH amount for debt on flashloan
    * @param _swapData swap bytes data 
    */
    function deleverage(
        uint256 _stETHWithdrawAmount,
        uint256 _wEthDebtDeleverageAmount,
        bytes calldata _swapData,
        uint256 _minimumAmount
    ) external onlyAdmin {

        require(_stETHWithdrawAmount >= MINIMUM_AMOUNT, "Must bigger than minimum amount");
        (uint256 totalAssets,,,) = ILendingLogic(lendingLogic).getNetAssetsInfo(address(this));
        require(totalAssets >= _wEthDebtDeleverageAmount, "Not enough collaboration");

        uint256 wEthPrice_ = getAssestPrice(WETH_ADDR);
        uint256 wstEthPrice_ = getAssestPrice(WSTETH_ADDR);
        uint256 wEthBal = IERC20(WETH_ADDR).balanceOf(address(this));
        require(_stETHWithdrawAmount * wstEthPrice_ <= wEthBal * wEthPrice_, "Not enough balance");

        logicWithdrawAmount = _stETHWithdrawAmount;
        bytes memory dataBytes = abi.encode(
            uint8(MODULE.DELEVERAGE_MODE),
            _wEthDebtDeleverageAmount,
            _minimumAmount,
            _swapData
        );
        
        IFlashloanHelper(flashloanHelper).flashLoan(
            IERC3156FlashBorrower(
                address(this)), 
                WETH_ADDR, 
                _wEthDebtDeleverageAmount, 
                dataBytes
        );
    }

    /**
    * @dev 
    */
    function onFlashLoanOne(
        address _initiator,
        address _token,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    ) external returns (bytes32) {
        
        require(_initiator == address(this), "Cannot call FlashLoan module");

        (uint8 _module, , uint256 _minimumAmount, bytes memory _swapData) = 
            abi.decode(_params, (uint8, uint256, uint256, bytes));

        if (_module == uint8(MODULE.LEVERAGE_MODE)) {

            (uint256 returnAmount_) =
                executeSwap(_amount, WETH_ADDR, _swapData, _minimumAmount);
            // uint256 returnAmount_ = testSwap(_amount, _token, true);
            executeDepositWithdraw(WSTETH_ADDR, returnAmount_ + logicDepositAmount, true);
            uint256 borrowAmount = ILendingLogic(lendingLogic).getAvailableBorrowsETH(address(this));
            executeBorrowRepay(_token, borrowAmount, true);
            emit Leverage(returnAmount_ + logicDepositAmount, borrowAmount);

        } else {
            
            uint256 wEthPrice_ = getAssestPrice(WETH_ADDR);
            uint256 wstEthPrice_ = getAssestPrice(WSTETH_ADDR);

            uint256 wethWithdrawAmount = _amount + _fee;
            if (logicWithdrawAmount != 0) {
                wethWithdrawAmount += logicWithdrawAmount * wstEthPrice_ / wEthPrice_;
            }

            executeBorrowRepay(_token, wethWithdrawAmount, false);
            uint256 wstWithdrawAmount = wethWithdrawAmount * wEthPrice_ / wstEthPrice_;
            executeDepositWithdraw(WSTETH_ADDR, wstWithdrawAmount, false);
            uint256 wstSwapAmount = (_amount + _fee) * wEthPrice_ / wstEthPrice_;
            executeSwap(wstSwapAmount, WSTETH_ADDR, _swapData, _minimumAmount);
            // testSwap(_amount, _token, false);

            emit Deleverage(wethWithdrawAmount, _amount);
        }

        IERC20(_token).approve(msg.sender, _amount + _fee);

        return CALLBACK_SUCCESS;
    }

    /**
     * @dev Execute the enter/exit operation in the lending protocol.
     * @param _isEnter indicator enter or exit
     */
    function enterExitProtocol(bool _isEnter) internal {
        require(lendingLogic != address(0), "LendingLogic not setted yet!");
        uint256 allowance = 0;
        if (_isEnter){
            allowance = type(uint256).max;
        }
        IERC20(WETH_ADDR).safeIncreaseAllowance(address(AAVE_POOL_V3), allowance);
        IERC20(WSTETH_ADDR).safeIncreaseAllowance(address(AAVE_POOL_V3), allowance);
        IERC20(A_WSTETH_ADDR_AAVEV3).safeIncreaseAllowance(address(AAVE_POOL_V3), allowance);
    }

    /**
     * @dev Execute the deposit/withdraw operation in the lending protocol.
     * This method will delegatecall to the LendingLogic contract.
     * @param _asset The type of asset being deposited in this transaction.
     * @param _amount The amount of asset being deposited in this transaction.
     * @param _isDeposit It represents deposit or withdraw
     */
    function executeDepositWithdraw(address _asset, uint256 _amount, bool _isDeposit) internal {
        require(_amount != 0);

        if (_isDeposit)
            AAVE_POOL_V3.supply(_asset, _amount, address(this), 0);
        else
            AAVE_POOL_V3.withdraw(_asset, _amount, address(this));
    }

    /**
     * @dev Execute the borrow/repay operation in the lending protocol.
     * This method will delegatecall to the LendingLogic contract.
     * @param _asset The type of asset being deposited in this transaction.
     * @param _amount The amount of asset being deposited in this transaction.
     * @param _isBorrow It represents deposit or withdraw
     */
    function executeBorrowRepay(address _asset, uint256 _amount, bool _isBorrow) internal {
        require(_amount != 0);
        
        if (_isBorrow)
            AAVE_POOL_V3.borrow(_asset, _amount, 2, 0, address(this));
        else
            AAVE_POOL_V3.repay(_asset, _amount, 2, address(this));
    }

    /**
     * @dev This method delegatecalls the method specified by the function signature to the lending logic.
     * @param _selector The function signature of the LendingLogic contract.
     * @param _callBytes The function parameter bytes of the LendingLogic contract.
     */
    // function executeLendingLogic(bytes4 _selector, bytes memory _callBytes) internal {
    //     bytes memory callBytes = abi.encodePacked(_selector, _callBytes);
    //     (bool success, bytes memory returnData) = lendingLogic.delegatecall(callBytes);
    //     require(success, string(returnData));
    // }

}