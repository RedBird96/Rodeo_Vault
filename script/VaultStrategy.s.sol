// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "./BaseDeployer.s.sol";
import "../src/core/Strategy.sol";
import "../src/core/LendingLogic.sol";
import "../src/core/FlashloanHelper.sol";

contract VaultStrategyScript is BaseDeployer {

    Strategy public strategy;
    Strategy public strategyProxy;
    ERC1967Proxy public proxy;
    ProxyAdmin public proxyAdmin;
    LendingLogic public lendinglogic;
    FlashloanHelper public flashloaner;
    address owner;
    uint256 public safeAggreatedRatio;
    uint256 public safeRatio;

    function setUp() public {
        owner = address(0x2ef73f60F33b167dC018C6B1DCC957F4e4c7e936);
        safeAggreatedRatio = 857100000000000000;
        safeRatio = 900000000000000000;
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
        lendinglogic = new LendingLogic();
        flashloaner = new FlashloanHelper();
        strategy = new Strategy();
        proxy = new ERC1967Proxy(address(strategy), "");
        strategyProxy = Strategy(payable(proxy));
        strategyProxy.__Strategy_init(
            address(0xCa04E37Edf1260A92298e18D15D7a38A322b9f82), 
            address(lendinglogic),
            address(flashloaner), 
            safeAggreatedRatio, 
            safeRatio
        );
    }

    function _upgradeVault() private broadcast(_deployerPrivateKey) {
        // VaultV2 vaultImpl = new VaultV2();
        // vaultProxy = Vault(payable(0xCa04E37Edf1260A92298e18D15D7a38A322b9f82));
        // vaultProxy.upgradeTo(address(vaultImpl));
    }
}
