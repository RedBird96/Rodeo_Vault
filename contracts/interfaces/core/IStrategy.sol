// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface IStrategy {
    function vault() external view returns (address);

    function owner() external view returns (address);

    function deposit(uint256) external returns (uint256);

    function withdraw(uint256) external returns (uint256);

    function getNetAssets() external view returns (uint256);

    function getCurrentExchangePrice() external view returns (uint256, uint256);

    function initialize(bytes memory _initialization, uint256 _poolId, address[] memory whiteList) external;

    function setVault(address _vault) external;

    function exchangePrice() external view returns (uint256);

    function withdrawFeeRate() external view returns (uint256);

    function getDeleverageAmount(uint256 _share, uint8 _protocolId) external view returns (uint256);

    function getAvailableLogicBalance() external view returns (uint256);
    
    function deleverageAndWithdraw(
        uint256 _stETHWithdrawAmount,
        uint256 _wEthDebtDeleverageAmount,
        bytes calldata _swapData,
        uint256 _minimumAmount
    ) external returns(uint256);
}