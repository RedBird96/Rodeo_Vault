// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./interfaces/lido/IWstETH.sol";
import "./interfaces/core/IStrategy.sol";
import "./Basic.sol";


contract Vault is 
    Basic,
    ERC4626Upgradeable
{
    using SafeERC20 for IERC20;
    using SafeERC20 for IWstETH;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    IERC20Upgradeable internal constant WSTETH_CONTRACT = IERC20Upgradeable(WSTETH_ADDR);

    IStrategy public strategy;
    // Who to receive the fee.
    address public feeReceiver;
    // Market capacity.
    uint256 public marketCapacity;
    // Exit fee in percentage.
    uint256 public exitFeeRate;
    // Deleverage exit fee in percentage.
    uint256 public deleverageExitFeeRate;
    // The last time the fees are charged.
    uint256 public lastTimestamp;
    // Total locked amount
    uint256 public totalLockedAmount;

    event UpdateStrategy(address oldStrategy, address newStrategy);
    event UpdateExitFeeRate(uint256 oldExitFeeRate, uint256 newExitFeeRate);
    event UpdateDeleverageExitFeeRate(uint256 oldDeleverageExitFeeRate, uint256 newDeleverageExitFeeRate);
    event UpdateFeeReceiver(address oldFeeReceiver, address newFeeReceiver);
    event UpdateMarketCapacity(uint256 oldCapacityLimit, uint256 newCapacityLimit);
    event DeleverageWithdraw(
        uint8 protocolId,
        address owner,
        address receiver,
        address token,
        uint256 assetsGet,
        uint256 shares,
        uint256 flashloanSelector
    );

    /**
     * @dev Initialize various parameters of the Vault contract.
     * @param _marketCapacity The maximum investment capacity.
     * @param _exitFeeRate The percentage of exit fee.
     * @param _deleverageExitFeeRate The percentage of exit fee for reducing leverage.
     */
    function __Vault_init(
        uint256 _marketCapacity,
        uint256 _exitFeeRate,
        uint256 _deleverageExitFeeRate
    ) public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        __ERC20_init("wETH-wstETH vault pool", "roETH");
        __ERC4626_init(WSTETH_CONTRACT);
        // The minimum position size is 100.
        require(_marketCapacity > 100e18, "Wrong marketCapacity!");
        marketCapacity = _marketCapacity;
        require(_exitFeeRate >= 1 && _exitFeeRate <= 120, "Exit fee exceeds the limit!");
        exitFeeRate = _exitFeeRate;
        // The maximum fee for withdrawing from the leveraged treasury is 1.2%.
        require(_deleverageExitFeeRate >= 1 && _deleverageExitFeeRate <= 120, "Deleverage Exit fee exceeds the limit!");
        deleverageExitFeeRate = _deleverageExitFeeRate;
        lastTimestamp = block.timestamp;
        isAdmin[msg.sender] = true;
    }

    /**
     * @dev Update the contract address of the strategy pool.
     * @param _newStrategy The new contract address.
     */
    function updateStrategy(address _newStrategy) public onlyOwner {
        require(_newStrategy != address(0), "Strategy error!");
        emit UpdateStrategy(address(strategy), _newStrategy);
        strategy = IStrategy(_newStrategy);
        WSTETH_CONTRACT.safeIncreaseAllowance(_newStrategy, type(uint256).max);
    }

    /**
     * @dev Update the size of the pool's capacity.
     * @param _newCapacityLimit The new size of the capacity.
     */
    function updateMarketCapacity(uint256 _newCapacityLimit) public onlyOwner {
        require(_newCapacityLimit > marketCapacity, "Unsupported!");
        emit UpdateMarketCapacity(marketCapacity, _newCapacityLimit);
        marketCapacity = _newCapacityLimit;
    }

    /**
     * @dev Update the exit fee rate.
     * @param _exitFeeRate The new rate.
     */
    function updateExitFeeRate(uint256 _exitFeeRate) public onlyOwner {
        require(_exitFeeRate >= 1 && _exitFeeRate <= 120, "Exit fee exceeds the limit!");
        emit UpdateExitFeeRate(exitFeeRate, _exitFeeRate);
        exitFeeRate = _exitFeeRate;
    }

    /**
     * @dev Update the fee rate for withdrawing asset by reducing leverage.
     * @param _deleverageExitFeeRate The new rate.
     */
    function updateDeleverageExitFeeRate(uint256 _deleverageExitFeeRate) public onlyOwner {
        require(_deleverageExitFeeRate >= 1 && _deleverageExitFeeRate <= 120, "Deleverage Exit fee exceeds the limit!");
        emit UpdateDeleverageExitFeeRate(deleverageExitFeeRate, _deleverageExitFeeRate);
        deleverageExitFeeRate = _deleverageExitFeeRate;
    }

    /**
     * @dev Retrieve the amount of the exit fee.
     * @param _wstETHAmount The amount of stETH to be withdrawn.
     * @return The exit fee to be deducted.
     *
     */
    function getWithdrawFee(uint256 _wstETHAmount) public view returns (uint256) {
        uint256 withdrawFee = (_wstETHAmount * exitFeeRate) / 1e4;

        return withdrawFee;
    }

    /**
     * @dev Retrieve the amount of the exit fee for reducing leverage.
     * @param _wstETHAmount The amount of stETH to be withdrawn.
     * @return The exit fee to be deducted.
     */
    function getDeleverageWithdrawFee(uint256 _wstETHAmount) public view returns (uint256) {
        uint256 withdrawFee = (_wstETHAmount * deleverageExitFeeRate) / 1e4;

        return withdrawFee;
    }

    /**
     * @dev Retrieve the amount of assets in the strategy pool.
     */
    function balance() public view returns (uint256) {
        return IStrategy(strategy).getNetAssets();
    }

    /**
     * @dev Retrieve the amount of stETH required for performing a swap during
     * the withdrawal for reducing leverage.
     * @param _wstETHAmount The amount of wstETH to be withdrawn if leverage is not being reduced.
     * @return amount The amount of wstETH required for the swap.
     */
    function getDeleverageWithdrawAmount(uint256 _wstETHAmount)
        public
        view
        returns (uint256 amount)
    {
        
    }

    /**
     * @dev Retrieve the amount of assets in the strategy pool.
     */
    function totalAssets() public view virtual override returns (uint256) {
        return (strategy.exchangePrice() * totalSupply()) / 1e18;
    }

    /**
     * @dev Override the deposit method of ERC4626 to perform capacity verification and
     * transfer assets to the strategy contract during the deposit process.
     * @param _caller The caller of the contract.
     * @param _receiver The recipient of the share tokens.
     * @param _assets The amount of stETH being deposited.
     * @param _shares The amount of share tokens obtained.
     */
    function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
        require(_assets + totalAssets() <= marketCapacity, "Exceeding market capacity.");
        WSTETH_CONTRACT.safeTransferFrom(_caller, address(this), _assets);
        _mint(_receiver, _shares);
        strategy.deposit(_assets);
        totalLockedAmount += _assets;
        emit Deposit(_caller, _receiver, _assets, _shares);
    }

    /**
     * @dev The deposit method of ERC4626, with the parameter being the amount of assets.
     * @param _assets The amount of stETH being deposited.
     * @param _receiver The recipient of the share tokens.
     * @return shares The amount of share tokens obtained.
     */
    function deposit(uint256 _assets, address _receiver)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 shares)
    {
        require(_assets >= MINIMUM_AMOUNT, "Must bigger than minimum amount");
        if (_assets == type(uint256).max) {
            _assets = IERC20(WSTETH_ADDR).balanceOf(msg.sender);
        }
        shares = super.deposit(_assets, _receiver);
    }

    /**
     * @dev The withdrawal method of ERC4626, with the parameter being the amount of assets.
     * @param _assets The amount of assets to be withdrawn.
     * @param _receiver The recipient of the withdrawn assets.
     * @return shares The amount of share tokens consumed for the asset withdrawal.
     */
    function withdraw(uint256 _assets, address _receiver, address _owner)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 shares)
    {
        require(_assets >= MINIMUM_AMOUNT, "Must bigger than minimum amount");
        if (_assets == type(uint256).max) {
            _assets = maxWithdraw(_owner);
        } else {
            require(_assets <= maxWithdraw(_owner), "ERC4626: withdraw more than max");
        }
        shares = previewWithdraw(_assets);
        uint256 assetsAfterFee_ = _assets - getWithdrawFee(_assets);
        uint256 stGet_ = strategy.withdraw(assetsAfterFee_);
        _withdraw(msg.sender, _receiver, _owner, stGet_, shares);
    }

    /**
     * @dev The deposit method of ERC4626, with the parameter being the amount of share tokens.
     * @param _shares The amount of share tokens to be minted.
     * @param _receiver The recipient of the share tokens.
     * @return assets The amount of assets consumed.
     */
    function mint(uint256 _shares, address _receiver)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 assets)
    {
        assets = super.mint(_shares, _receiver);
    }

    /**
     * @dev The asset redemption method of ERC4626, with the parameter being the amount of share tokens.
     * @param _shares The amount of share tokens to be redeemed.
     * @param _receiver The address of the recipient for the redeemed assets.
     * @param _owner The owner of the redeemed share tokens.
     * @return assetsAfterFee The actual amount of assets redeemed.
     */
    function redeem(uint256 _shares, address _receiver, address _owner)
        public
        override
        whenNotPaused
        nonReentrant
        returns (uint256 assetsAfterFee)
    {
        if (_shares == type(uint256).max) {
            _shares = maxRedeem(_owner);
        } else {
            require(_shares <= maxRedeem(_owner), "ERC4626: redeem more than max");
        }
        uint256 assets_ = previewRedeem(_shares);
        assetsAfterFee = assets_ - getWithdrawFee(assets_);
        uint256 stGet_ = strategy.withdraw(assetsAfterFee);

        _withdraw(msg.sender, _receiver, _owner, stGet_, _shares);
    }

    /**
     * @dev When there is insufficient idle funds in the strategy pool,
     * users can opt to withdraw funds and reduce leverage in a specific lending protocol.
     * @param _protocolId The index number of the lending protocol.
     * @param _token The type of token to be redeemed.
     * @param _assets The original amount of assets that could be redeemed.
     * @param _swapData  The calldata for the 1inch exchange operation.
     * @param _swapGetMin The minimum amount of token to be obtained during the 1inch exchange operation.
     * @param _flashloanSelector The selection of the flash loan protocol.
     * @param _owner The owner of the redeemed share tokens.
     * @param _receiver The address of the recipient for the redeemed assets.
     * @return shares The amount of share tokens obtained.
     */
    function deleverageWithdraw(
        uint8 _protocolId,
        address _token,
        uint256 _assets,
        bytes memory _swapData,
        uint256 _swapGetMin,
        uint256 _flashloanSelector,
        address _owner,
        address _receiver
    ) external whenNotPaused nonReentrant returns (uint256 shares) {
        if (_assets == type(uint256).max) {
            _assets = maxWithdraw(_owner);
        } else {
            require(_assets <= maxWithdraw(_owner), "ERC4626: withdraw more than max");
        }
        shares = previewWithdraw(_assets);
        uint256 assetsAfterFee_ = _assets - getDeleverageWithdrawFee(_assets);
        if (msg.sender != _owner) {
            _spendAllowance(_owner, msg.sender, shares);
        }

        uint256 assetsGet_ = strategy.deleverageAndWithdraw(
            _protocolId, assetsAfterFee_, _swapData, _swapGetMin
        );
        _burn(_owner, shares);
        IWstETH(WSTETH_ADDR).safeTransfer(_receiver, assetsGet_);

        emit DeleverageWithdraw(_protocolId, _owner, _receiver, _token, assetsGet_, shares, _flashloanSelector);
    }

    /**
     * @dev Handle when someone else accidentally transfers assets to this contract.
     */
    function sweep(address _token) external onlyOwner {
        uint256 amount_ = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(owner(), amount_);
        uint256 ethbalance_ = address(this).balance;
        if (ethbalance_ > 0) {
            Address.sendValue(payable(owner()), ethbalance_);
        }
    }

    /**
     * @dev Pause user deposit and withdrawal operations.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Resume user deposit and withdrawal operations.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Retrieve the version number of the vault contract.
     */
    function getVersion() public pure returns (string memory) {
        return "v0.0.1";
    }

    receive() external payable {}
}
