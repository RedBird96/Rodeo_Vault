// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/**
 * @title ILendingLogic
 * @notice Define the interface for the lending logic.
 */
interface ILendingLogic {

    function deposit(address asset, uint256 amount) external;

    function withdraw(address asset, uint256 amount) external;

    function borrow(address asset, uint256 amount) external;

    function repay(address asset, uint256 amount) external;

    function enterProtocol() external;

    function exitProtocol() external;

    function getAvailableBorrowsETH(address _account) external view returns (uint256);

    function getAvailableWithdrawsStETH(address _account) external view returns (uint256);

    function getProtocolCollateralRatio(address _account) external view returns (uint256 ratio);

    function getProtocolLeverageAmount(
        address _account,
        bool _isDepositOrWithdraw,
        uint256 _depositOrWithdraw,
        uint256 _safeRatio
    ) external view returns (bool isLeverage, uint256 amount);

    function getProtocolAccountData(address _account)
        external
        view
        returns (uint256 stEthAmount, uint256 debtEthAmount);

    function getNetAssetsInfo(address _account)
        external
        view
        returns (uint256 totalAssets, uint256 totalDebt, uint256 netAssets, uint256 aggregatedRatio);
}