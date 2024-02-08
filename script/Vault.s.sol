// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../src/Vault.sol";
import "../src/VaultV2.sol";
import "./BaseDeployer.s.sol";

contract VaultScript is BaseDeployer {

    Vault vault;
    Vault vaultProxy;
    ERC1967Proxy public proxy;
    ProxyAdmin proxyAdmin;
    address owner;
    uint256 public marketCapacity;
    uint256 public exitFeeRate;
    uint256 public deleverageExitFee;

    function setUp() public {
        owner = address(0x2ef73f60F33b167dC018C6B1DCC957F4e4c7e936);
        marketCapacity = 1000e18;
        exitFeeRate = 20;
        deleverageExitFee = 20;
    }

    function run() public {
        vm.broadcast();
    }

    function vaultDeployTestnet() external setEnvDeploy(Cycle.Test) {
        createSelectFork(Chains.Sepolia);
        _chainVault();
    }

    function upgradeTestnet() external setEnvDeploy(Cycle.Test) {
        createSelectFork(Chains.Sepolia);
        _upgradeVault();
    }

    function vaultDeploySelectedChains() external setEnvDeploy(Cycle.Prod){
        createSelectFork(Chains.Arbitrum);
        _chainVault();
    }

    function _chainVault() private broadcast(_deployerPrivateKey) {
        vault = new Vault();
        proxy = new ERC1967Proxy(address(vault), "");
        vaultProxy = Vault(payable(proxy));
        vaultProxy.__Vault_init(
            marketCapacity, 
            exitFeeRate, 
            deleverageExitFee
        );
    }

    function _upgradeVault() private broadcast(_deployerPrivateKey) {
        VaultV2 vaultImpl = new VaultV2();
        vaultProxy = Vault(payable(0xCa04E37Edf1260A92298e18D15D7a38A322b9f82));
        vaultProxy.upgradeTo(address(vaultImpl));

    }
}
