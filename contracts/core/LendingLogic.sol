// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interfaces/aaveV3/IAaveOracle.sol";
import "../interfaces/aaveV3/IPoolV3.sol";
import "../interfaces/core/ILendingLogic.sol";
import "./BasicLogic.sol";

contract LendingLogic is BasicLogic, ILendingLogic {

    using SafeERC20 for IERC20;
    // arbitrum
    address public constant WETH_ADDR = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public constant WSTETH_ADDR = 0x5979D7b546E38E414F7E9822514be443A4800529;
    address public constant A_WSTETH_ADDR_AAVEV3 = 0x513c7E3a9c69cA3e22550eF58AC1C0088e918FFf;
    address public constant D_WETH_ADDR_AAVEV3 = 0x77CA01483f379E58174739308945f044e1a764dc;
    IAaveOracle public constant AAVE_ORACLE_V3 = IAaveOracle(0xb56c2F0B653B2e0b10C9b928C8580Ac5Df02C7C7);
    IPoolV3 public constant AAVE_POOL_V3 = IPoolV3(0x794a61358D6845594F94dc1DB02A252b5b4814aD);

    /**
     * @dev The method for allowing entry into a specified lending protocol,
     * where the strategy pool will delegatecall to this method.
     */
    function enterProtocol() external onlyDelegation {
        IERC20(WETH_ADDR).safeIncreaseAllowance(address(AAVE_POOL_V3), type(uint256).max);
        IERC20(WSTETH_ADDR).safeIncreaseAllowance(address(AAVE_POOL_V3), type(uint256).max);
        IERC20(A_WSTETH_ADDR_AAVEV3).safeIncreaseAllowance(address(AAVE_POOL_V3), type(uint256).max);
    }

    /**
     * @dev The method for disallowing entry into a specified lending protocol,
     * where the strategy pool will delegatecall to this method.
     */
    function exitProtocol() external onlyDelegation {
        IERC20(WETH_ADDR).safeApprove(address(AAVE_POOL_V3), 0);
        IERC20(WSTETH_ADDR).safeApprove(address(AAVE_POOL_V3), 0);
        IERC20(A_WSTETH_ADDR_AAVEV3).safeApprove(address(AAVE_POOL_V3), 0);
    }

    /**
     * @dev The method for executing a deposit in the lending protocol, where 
     * the strategy pool will delegatecall to this method.
     * @param _asset The type of asset being deposited in this transaction.
     * @param _amount The amount of asset being deposited in this transaction.
     */
    function deposit(address _asset, uint256 _amount) external onlyDelegation {
        require(_asset == WSTETH_ADDR, "Wrong asset!");
        AAVE_POOL_V3.supply(WSTETH_ADDR, _amount, address(this), 0);
    }

    /**
     * @dev The method for executing a withdraw in the lending protocol, where 
     * the strategy pool will delegatecall to this method.
     * @param _asset The type of asset being withdrawn in this transaction.
     * @param _amount The amount of asset being withdrawn in this transaction.
     */
    function withdraw(address _asset, uint256 _amount) external onlyDelegation {
        require(_asset == WSTETH_ADDR, "Wrong asset!");
        AAVE_POOL_V3.withdraw(WSTETH_ADDR, _amount, address(this));
    }

    /**
     * @dev The method for executing a borrow in the lending protocol, where 
     * the strategy pool will delegatecall to this method.
     * @param _asset The type of asset being borrowed in this transaction.
     * @param _amount The amount of asset being borrowed in this transaction.
     */
    function borrow(address _asset, uint256 _amount) external onlyDelegation {
        require(_asset == WETH_ADDR, "Wrong asset!");
        AAVE_POOL_V3.borrow(_asset, _amount, 2, 0, address(this));
    }

    /**
     * @dev The method for executing a repayment in the lending protocol, where 
     * the strategy pool will delegatecall to this method.
     * @param _asset The type of asset being repaid in this transaction.
     * @param _amount The amount of asset being repaid in this transaction.
     */
    function repay(address _asset, uint256 _amount) external onlyDelegation {
        require(_asset == WETH_ADDR, "Wrong asset!");
        AAVE_POOL_V3.repay(_asset, _amount, 2, address(this));
    }


    /**
     * @dev Retrieve the maximum amount of ETH that an account address can still
     * borrow in the lending protocol.
     * @param _account The account address.
     * @return availableBorrowsETH The maximum amount of ETH that can still be borrowed.
     */
    function getAvailableBorrowsETH(address _account)
        public
        view
        override
        returns (uint256 availableBorrowsETH)
    {
        (,, uint256 availableBorrowsInUsd_,,,) = AAVE_POOL_V3.getUserAccountData(_account);
        if (availableBorrowsInUsd_ > 0) {
            uint256 wEthPrice_ = AAVE_ORACLE_V3.getAssetPrice(WETH_ADDR);
            availableBorrowsETH = availableBorrowsInUsd_ * 1e18 / wEthPrice_;
        }
    }

    /**
     * @dev Retrieve the maximum amount of stETH that an account address can still
     * withdraw in the lending protocol.
     * @param _account The account address.
     * @return maxWithdrawsWStETH The maximum amount of wstETH that can still be withdrawn.
     */
    function getAvailableWithdrawsStETH(address _account)
        public
        view
        returns (uint256 maxWithdrawsWStETH)
    {
        (uint256 colInUsd_, uint256 debtInUsd_,,, uint256 ltv_,) = AAVE_POOL_V3.getUserAccountData(_account);
        if (colInUsd_ > 0) {
            uint256 colMin_ = debtInUsd_ * 1e4 / ltv_;
            uint256 maxWithdrawsInUsd_ = colInUsd_ > colMin_ ? colInUsd_ - colMin_ : 0;
            uint256 wstEthPrice_ = AAVE_ORACLE_V3.getAssetPrice(WSTETH_ADDR);
            maxWithdrawsWStETH = maxWithdrawsInUsd_ * 1e18 / wstEthPrice_;
        }
    }

    /**
     * @dev Retrieve the debt collateralization ratio of the account in the lending protocol,
     * using the oracle associated with that lending protocol.
     * @param _account The account address.
     * @return ratio The debt collateralization ratio, where 1e18 represents 100%.
     */
    function getProtocolCollateralRatio(address _account)
        public
        view
        returns (uint256 ratio)
    {
        (uint256 totalCollateralBase_, uint256 totalDebtBase_,,,,) = AAVE_POOL_V3.getUserAccountData(_account);
        ratio = totalCollateralBase_ == 0 ? 0 : totalDebtBase_ * 1e18 / totalCollateralBase_;
    }

    /**
     * @dev Retrieve the amount of WETH required for the flash loan in this operation.
     * When increasing leverage, it is also possible to deposit stETH into the lending
     * protocol simultaneously. When decreasing leverage, it is also possible to withdraw
     * stETH from the lending protocol simultaneously.
     * @param _account The account address.
     * @param _isDepositOrWithdraw Whether an additional deposit of stETH is required.
     * @param _depositOrWithdraw The amount of stETH to be deposited or withdrawn.
     * @param _safeRatio The target collateralization ratio that the strategy pool needs to achieve.
     * @return isLeverage Returning "true" indicates the need to increase leverage, while returning
     * "false" indicates the need to decrease leverage.
     * @return loanAmount The amount of flash loan required for this transaction.
     */
    function getProtocolLeverageAmount(
        address _account,
        bool _isDepositOrWithdraw,
        uint256 _depositOrWithdraw,
        uint256 _safeRatio
    ) public view returns (bool isLeverage, uint256 loanAmount) {
        uint256 totalCollateralETH_;
        uint256 totalDebtETH_;
        uint256 depositOrWithdrawInETH_;
        uint256 wstPrice_ = AAVE_ORACLE_V3.getAssetPrice(WSTETH_ADDR);
        uint256 ethPrice_ = AAVE_ORACLE_V3.getAssetPrice(WETH_ADDR);
        totalCollateralETH_ = IERC20(A_WSTETH_ADDR_AAVEV3).balanceOf(_account) * wstPrice_ / ethPrice_;
        totalDebtETH_ = IERC20(D_WETH_ADDR_AAVEV3).balanceOf(_account);
        depositOrWithdrawInETH_ = _depositOrWithdraw * wstPrice_ / ethPrice_;
        totalCollateralETH_ = _isDepositOrWithdraw
            ? (totalCollateralETH_ + depositOrWithdrawInETH_)
            : (totalCollateralETH_ - depositOrWithdrawInETH_);
        if (totalCollateralETH_ != 0) {
            uint256 ratio = totalCollateralETH_ == 0 ? 0 : totalDebtETH_ * 1e18 / totalCollateralETH_;
            isLeverage = ratio < _safeRatio ? true : false;
            if (isLeverage) {
                loanAmount = (_safeRatio * totalCollateralETH_ - totalDebtETH_ * 1e18) / (1e18 - _safeRatio);
            } else {
                loanAmount = (totalDebtETH_ * 1e18 - _safeRatio * totalCollateralETH_) / (1e18 - _safeRatio);
            }
        }
    }

    /**
     * @dev Retrieve the collateral and debt quantities of the account in the lending protocol.
     * @param _account The account address.
     * @return wstEthAmount The amount of wstETH collateral.
     * @return debtEthAmount The amount of ETH debt.
     */
    function getProtocolAccountData(address _account)
        public
        view
        returns (uint256 wstEthAmount, uint256 debtEthAmount)
    {
        wstEthAmount = IERC20(A_WSTETH_ADDR_AAVEV3).balanceOf(_account);
        debtEthAmount = IERC20(D_WETH_ADDR_AAVEV3).balanceOf(_account);
    }


    /**
     * @dev Retrieve the amount of assets in all lending protocols involved 
     * in this contract for the account.
     * @param _account The account address.
     * @return totalAssets The total amount of collateral.
     * @return totalDebt The total amount of debt.
     * @return netAssets The total amount of net assets.
     * @return aggregatedRatio The aggregate collateral-to-debt ratio.
     */
    function getNetAssetsInfo(address _account)
        public
        view
        returns (uint256 totalAssets, uint256 totalDebt, uint256 netAssets, uint256 aggregatedRatio)
    {
        uint256 protocolAsset_;
        uint256 protocolDebt_;
        (protocolAsset_, protocolDebt_) = getProtocolAccountData(_account);
        totalAssets += protocolAsset_;
        totalDebt += protocolDebt_;
        netAssets = totalAssets - totalDebt;
        aggregatedRatio = totalAssets == 0 ? 0 : (totalDebt * 1e18) / totalAssets;
    }
}