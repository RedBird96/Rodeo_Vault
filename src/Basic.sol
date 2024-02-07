// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/contracts/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/contracts/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "./Constants.sol";

abstract contract Basic is 
    OwnableUpgradeable,
    UUPSUpgradeable, 
    PausableUpgradeable, 
    ReentrancyGuardUpgradeable, 
    Constants 
{
    
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
    
    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Not admin!");
        _;
    }
}