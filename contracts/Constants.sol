// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Constants {

    // arbitrum
    address public constant WETH_ADDR = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public constant WSTETH_ADDR = 0x5979D7b546E38E414F7E9822514be443A4800529;

    // The Minimum Safe Aggregation Ratio cannot be lower than 70%.
    uint256 public constant MIN_SAFE_AGGREGATED_RATIO = 70e16;
    // The Maximum Safe Aggregation Ratio cannot be higher than 95%.
    uint256 public constant MAX_SAFE_AGGREGATED_RATIO = 95e16;
    uint256 public constant PERMISSIBLE_LIMIT = 2e15;
    uint256 public constant MINIMUM_AMOUNT = 10000000;

    mapping(address => bool) isAdmin;
}