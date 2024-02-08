// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
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
    ERC1967Proxy public proxyV;
    ERC1967Proxy public proxyS;
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
        // strategyProxy = Strategy(0x79cf424266153Fa373f548D38E2AB2283a8775b7); 
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
        proxyV = new ERC1967Proxy(address(vault), "");
        vaultProxy = Vault(payable(proxyV));
        vaultProxy.__Vault_init(
            marketCapacity, 
            exitFeeRate, 
            deleverageExitFee
        );

        vm.prank(owner);
        proxyS = new ERC1967Proxy(address(strategy), "");
        strategyProxy = Strategy(payable(proxyS));
        strategyProxy.__Strategy_init(
            address(vaultProxy), 
            address(lendingLogic),
            address(flashloaner), 
            safeAggreatedRatio, 
            safeRatio
        );
        vaultProxy.updateStrategy(address(strategyProxy));
    }

    function testStrategy() public {

        uint256 firstdepositAmount = 5e9;
        uint256 seconddepositAmount = 5e9;
        // address firstUser = 0x02eD4a07431Bcc26c5519EbF8473Ee221F26Da8b;
        // address secondUser = 0x702a39a9d7D84c6B269efaA024dff4037499bBa9;
        address firstUser = 0x916792f7734089470de27297903BED8a4630b26D;
        address secondUser = 0xD090D2C8475c5eBdd1434A48897d81b9aAA20594;
        deal(firstUser, 10e18);
        deal(secondUser, 10e18);

        // vm.prank(owner);
        strategyProxy.addAdmin(firstUser);
        vm.startPrank(firstUser);
        IERC20(WSTETH_ADDR).approve(address(vaultProxy), firstdepositAmount);
        vaultProxy.deposit(firstdepositAmount, firstUser);
        IERC20(WSTETH_ADDR).approve(address(vaultProxy), seconddepositAmount);
        vaultProxy.deposit(seconddepositAmount, secondUser);
        vm.stopPrank();

        vm.startPrank(firstUser);

        uint256 minimumamount = 10;
        uint256 stAmount = (firstdepositAmount + seconddepositAmount) * 2;
        uint256 stBalance = IERC20(WSTETH_ADDR).balanceOf(address(strategyProxy));
        console.log("stBalance", stBalance, stAmount);
        bytes memory _swapData=hex"0502b1c500000000000000000000000082af49447d8a07e3bd95bd0d56f35241523fbab100000000000000000000000000000000000000000000000000000004a817c80000000000000000000000000000000000000000000000000000000003fe788f800000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000180000000000000003b6d0340b0d62768e2fb9bd437a51b993b77b93ac9f249d58b1ccac8";
        strategyProxy.leverage(
            stBalance, 
            stAmount, 
            _swapData, 
            minimumamount
        );

        // uint256 afterba = IERC20(WETH_ADDR).balanceOf(address(strategyProxy));
        // uint256 afterbawst = IERC20(WSTETH_ADDR).balanceOf(address(strategyProxy));
        // console.log("afterba", afterba);
        // console.log("afterbawst1", afterbawst);
        bytes memory _deleverageData = hex"0502b1c50000000000000000000000005979d7b546e38e414f7e9822514be443a4800529000000000000000000000000000000000000000000000000000000000210f35800000000000000000000000000000000000000000000000000000000025bfc910000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000100000000000000003b6d0340e263353986a4638144c41e44cebac9d0a76ecab38b1ccac8";
        // uint256 withdrawAmt = 1e7;
        // stAmount = withdrawAmt * 2;
        // strategyProxy.deleverage(
        //     withdrawAmt, 
        //     stAmount, 
        //     _deleverageData, 
        //     minimumamount
        // );
        // console.log("afterbawst2", IERC20(WSTETH_ADDR).balanceOf(address(strategyProxy)));

        console.log("before bal", IERC20(WSTETH_ADDR).balanceOf(address(firstUser)));
        uint256 withdrawAmt = 2e7;
        stAmount = withdrawAmt * 2;
        vaultProxy.deleverageWithdraw(
            WSTETH_ADDR, 
            withdrawAmt, 
            stAmount, 
            _deleverageData, 
            minimumamount, 
            firstUser, 
            firstUser
        );

        console.log("after bal", IERC20(WSTETH_ADDR).balanceOf(address(firstUser )));
        vm.stopPrank();

    }

}
