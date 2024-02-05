// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/core/Strategy.sol";
import "../src/Vault.sol";
import "../src/core/LendingLogic.sol";
import "../src/core/FlashloanHelper.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "lib/forge-std/src/console.sol";

contract StrategyTest is Test {

    Strategy public strategy;
    Strategy public strategyProxy;
    Vault public vault;
    Vault public vaultProxy;
    LendingLogic lendingLogic;
    FlashloanHelper flashloaner;
    TransparentUpgradeableProxy public proxyV;
    TransparentUpgradeableProxy public proxyS;
    address public owner;
    address public admin;
    uint256 public safeAggreatedRatio;
    uint256 public safeRatio;
    uint256 public marketCapacity;
    uint256 public exitFeeRate;
    uint256 public deleverageExitFee;

    //Arbitrum
    address public constant WETH_ADDR = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public constant WSTETH_ADDR = 0x5979D7b546E38E414F7E9822514be443A4800529;

    function setUp() public {

        vm.createSelectFork("https://arb-mainnet.g.alchemy.com/v2/EBq207Wb2kJF6CGEVSTuliPcwlvU1MtE", 173_004_612);

        owner = address(0x2ef73f60F33b167dC018C6B1DCC957F4e4c7e936);
        admin = vm.addr(1);

        lendingLogic = new LendingLogic();
        flashloaner = new FlashloanHelper();

        safeAggreatedRatio = 857100000000000000;
        safeRatio = 900000000000000000;
        marketCapacity = 1000e18;
        exitFeeRate = 20;
        deleverageExitFee = 20;

        vault = new Vault();
        strategy = new Strategy();
        vm.prank(owner);
        proxyV = new TransparentUpgradeableProxy(address(vault), address(owner), "");
        vaultProxy = Vault(payable(proxyV));
        vaultProxy.initialize(
            marketCapacity, 
            exitFeeRate, 
            deleverageExitFee
        );

        vm.prank(owner);
        proxyS = new TransparentUpgradeableProxy(address(strategy), address(owner), "");
        strategyProxy = Strategy(payable(proxyS));
        strategyProxy.initialize(
            address(vaultProxy), 
            address(lendingLogic),
            address(flashloaner), 
            safeAggreatedRatio, 
            safeRatio
        );
        vaultProxy.updateStrategy(address(strategyProxy));
    }

    function testStrategy() public {

        uint256 firstdeposit_Amount = 5e9;
        uint256 seconddeposit_Amount = 5e9;
        // address firstUser = 0x02eD4a07431Bcc26c5519EbF8473Ee221F26Da8b;
        // address secondUser = 0x702a39a9d7D84c6B269efaA024dff4037499bBa9;
        address firstUser = 0x916792f7734089470de27297903BED8a4630b26D;
        address secondUser = 0xD090D2C8475c5eBdd1434A48897d81b9aAA20594;
        deal(firstUser, 10e18);
        deal(secondUser, 10e18);

        strategyProxy.addAdmin(firstUser);
        vm.startPrank(firstUser);
        IERC20(WSTETH_ADDR).transfer(owner, 5e11);
        IERC20(WSTETH_ADDR).approve(address(vaultProxy), firstdeposit_Amount);
        vaultProxy.deposit(firstdeposit_Amount, firstUser);
        IERC20(WSTETH_ADDR).approve(address(vaultProxy), seconddeposit_Amount);
        vaultProxy.deposit(seconddeposit_Amount, secondUser);
        vm.stopPrank();

        vm.startPrank(firstUser);

        uint256 minimumamount = 14e18;
        uint256 stAmount = (firstdeposit_Amount + seconddeposit_Amount) * 3;
        uint256 stBalance = IERC20(WSTETH_ADDR).balanceOf(address(strategyProxy));
        IERC20(WSTETH_ADDR).approve(address(strategyProxy), stAmount);
        uint256 allowance = IERC20(WSTETH_ADDR).allowance(admin, address(strategyProxy));
        console.log("allowance", address(admin), allowance);
        bytes memory _swapData=hex"12aa3caf0000000000000000000000001136B25047E142Fa3018184793aEc68fBB173cE4000000000000000000000000C02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2000000000000000000000000ae7ab96520de3a18e5e111b5eaab095312d7fe840000000000000000000000001136B25047E142Fa3018184793aEc68fBB173cE4000000000000000000000000D6BbDE9174b1CdAa358d2Cf4D57D1a9F7178FBfF000000000000000000000000000000000000000000000000000537a5d727172f000000000000000000000000000000000000000000000000000530f83613b1f1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000008200005400003a4060ae7ab96520de3a18e5e111b5eaab095312d7fe84a1903eab00000000000000000000000042f527f50f16a103b6ccab48bccca214500c10210020d6bdbf78ae7ab96520de3a18e5e111b5eaab095312d7fe8480a06c4eca27ae7ab96520de3a18e5e111b5eaab095312d7fe841111111254eeb25477b68fb85ed929f73a960582ea4184f4";
        uint256 ratio = strategyProxy.safeRatio();
        strategyProxy.leverage(
            stBalance, 
            stAmount, 
            _swapData, 
            minimumamount
        );

        bytes memory _deleverageData = hex"12aa3caf000000000000000000000000e37e799d5077682fa0a244d46e5649f71457bd09000000000000000000000000ae7ab96520de3a18e5e111b5eaab095312d7fe84000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000e37e799d5077682fa0a244d46e5649f71457bd090000000000000000000000003fd49a8f37e2349a29ea701b56f10f03b08f153200000000000000000000000000000000000000000000001bb38cb09b209c000000000000000000000000000000000000000000000000001bb1117e7f9ceb435a000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001730000000000000000000000000000000000000000000001550001270000dd00a007e5c0d20000000000000000000000000000000000000000000000b900006a00005051207f39c581f595b53c5cb19bd0b3f8da6c935e2ca0ae7ab96520de3a18e5e111b5eaab095312d7fe840004ea598cb000000000000000000000000000000000000000000000000000000000000000000020d6bdbf787f39c581f595b53c5cb19bd0b3f8da6c935e2ca000a0fbb7cd060093d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c27f39c581f595b53c5cb19bd0b3f8da6c935e2ca0c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200a0f2fa6b66c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000000000000000000000000001bb221c154a7f3c2ae0000000000000000000b13a5118a898f80a06c4eca27c02aaa39b223fe8d0a0e5c4f27ead9083c756cc21111111254eeb25477b68fb85ed929f73a96058200000000000000000000000000ea4184f4";
        stAmount = 1e10;
        IERC20(WETH_ADDR).approve(address(strategyProxy), stAmount * 2);
        strategyProxy.deleverage(
            0, 
            stAmount, 
            _deleverageData, 
            minimumamount
        );

        vm.stopPrank();

    }

}
