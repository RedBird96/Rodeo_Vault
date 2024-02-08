// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

/**
 * @title IFlashLoanSimpleReceiver
 * @author Aave
 * @notice Defines the basic interface of a flashloan-receiver contract.
 * @dev Implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 */
interface IFlashLoanSimpleReceiver {
    /**
     * @notice Executes an operation after receiving the flash-borrowed asset
     * @dev Ensure that the contract can return the debt + premium, e.g., has
     *      enough funds to repay and has approved the Pool to pull the total amount
     * @param _asset The address of the flash-borrowed asset
     * @param _amount The amount of the flash-borrowed asset
     * @param _premium The fee of the flash-borrowed asset
     * @param _initiator The address of the flashloan initiator
     * @param _params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(address _asset, uint256 _amount, uint256 _premium, address _initiator, bytes calldata _params)
        external
        returns (bool);
}