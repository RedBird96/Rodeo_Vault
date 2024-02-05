// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "../interfaces/aaveV3/IFlashLoanSimpleReceiver.sol";
import "../interfaces/aaveV3/IPoolV3.sol";
import "../interfaces/core/IFlashloanHelper.sol";
import "../interfaces/core/IFlashloaner.sol";

/**
 * @title FlashloanHelper contract
 * @notice This contract acts as an aggregator for flash loan providers.
 * @dev Use different protocols for flash loans by using different IDs,
 * while eliminating the ABI differences between different protocols.
 */
contract FlashloanHelper is IFlashloanHelper, IFlashLoanSimpleReceiver {
    using SafeERC20 for IERC20;

    bytes32 public constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
    // ethereum
    //address public constant aaveV3Pool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    // arbitrum
    address public constant aaveV3Pool = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    // Prevent re-entry calls by using this flag.
    address public executor;

    /**
     * @dev The entry function for executing the flash loan operation.
     * @param _receiver The contract of the callback function receiving the flash loan operation.
     * @param _token The type of token required for the flash loan.
     * @param _amount The amount of token required for the flash loan.
     * @param _dataBytes The parameters for executing the callback.
     * @return bool The flag indicating the operation has been completed.
     */
    function flashLoan(IERC3156FlashBorrower _receiver, address _token, uint256 _amount, bytes calldata _dataBytes)
        external
        override
        returns (bool)
    {
        require(executor == address(0) && address(_receiver) == msg.sender, "FlashloanHelper: In progress!");
        
        executor = msg.sender;

        IPoolV3(aaveV3Pool).flashLoanSimple(address(this), _token, _amount, _dataBytes, 0);
        executor = address(0);

        return true;
    }

    /**
     * @notice Executes an operation after receiving the flash-borrowed asset.
     * @dev AaveV3 flashloan callback.
     * @dev Ensure that the contract can return the debt + premium, e.g., has
     * enough funds to repay and has approved the pool to pull the total amount.
     * @param _asset The address of the flash-borrowed asset.
     * @param _amount The amount of the flash-borrowed asset.
     * @param _premium The fee of the flash-borrowed asset.
     * @param _initiator The address of the flashloan initiator.
     * @param _params The byte-encoded params passed when initiating the flashloan.
     * @return True if the execution of the operation succeeds, false otherwise.
     */
    function executeOperation(
        address _asset,
        uint256 _amount,
        uint256 _premium,
        address _initiator,
        bytes calldata _params
    ) external override returns (bool) {

        require(msg.sender == aaveV3Pool && _initiator == address(this), "Aave flashloan: Invalid call!");
        IERC20(_asset).safeTransfer(executor, _amount);

        require(
            IFlashloaner(executor).onFlashLoanOne(executor, _asset, _amount, _premium, _params)
                == CALLBACK_SUCCESS,
            "Aave flashloan for module one failed"
        );

        IERC20(_asset).safeTransferFrom(executor, address(this), _amount + _premium);
        IERC20(_asset).safeIncreaseAllowance(aaveV3Pool, _amount + _premium);
        return true;
    }

}