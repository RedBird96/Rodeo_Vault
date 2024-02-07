// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import {console} from "lib/forge-std/src/console.sol";

/**
 * @title OneinchCaller contract
 * @notice The focal point of interacting with the 1inch protocol.
 * @dev This contract will be inherited by the strategy contract and the
 * wrapper contract, used for the necessary exchange between ETH (WETH) and
 * STETH when necessary.
 * @dev When using this contract, it is necessary to first obtain the
 * calldata through 1inch API. The contract will then extract and verify the
 * calldata before proceeding with the exchange.
 */
contract OneinchCaller {
    address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    // 1inch v5 is currently in use.
    address public constant oneInchRouter = 0x1111111254EEB25477B68fb85Ed929f73A960582;
    // address public constant Executor = 0x1136b25047e142fa3018184793aec68fbb173ce4;

    function approveToken(address _token) internal {
        IERC20(_token).approve(oneInchRouter, type(uint256).max);
    }
    /**
     * @dev Executes the swap operation and verify the validity of the parameters and results.
     * @param _amount The maximum amount of currency spent in this operation.
     * @param _srcToken The token spent in this operation.
     * @param _swapData The calldata of 1inch v5.
     * @param _swapGetMin The minimum amount of token expected to be received from this operation.
     * @return returnAmount_ The actual amount of token spent in this operation.
     */
    function executeSwap(
        uint256 _amount,
        address _srcToken,
        bytes memory _swapData,
        uint256 _swapGetMin
    ) internal returns (uint256 returnAmount_) {
        uint256 swapAmount;
        address swapSrc;
        assembly {
            swapSrc := mload(add(_swapData, add(0x20, 0x04)))
            swapAmount := mload(add(_swapData, add(0x20, 0x24)))
        }
        require(IERC20(_srcToken) == IERC20(swapSrc), "1inch: Invalid token!");
        require(swapAmount >= _amount, "1inch: Invalid input amount!");
        IERC20(_srcToken).approve(oneInchRouter, _amount);
        bytes memory returnData_;
        if (_srcToken == ETH_ADDR) {
            returnData_ = Address.functionCallWithValue(oneInchRouter, _swapData, _amount);
        } else {
            returnData_ = Address.functionCall(oneInchRouter, _swapData);
        }
        assembly {
            returnAmount_ := mload(add(returnData_, add(0x20, 0)))
        }
        require(returnAmount_ >= _swapGetMin, "1inch: unexpected returnAmount.");
    }
}