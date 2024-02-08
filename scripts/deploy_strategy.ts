import {ethers, run, upgrades} from 'hardhat';
import {sleep, verify} from "./utils"

//module.exports = async() => {
async function main() {

    const safeAggreateRatio = ethers.utils.parseEther("0.8571");
    const safeRatio = ethers.utils.parseEther("0.9");

    // const flashloan = await ethers.deployContract("FlashloanHelper");
    // await flashloan.deployed();
    // await verify(flashloan.address);
    // console.log("FlashloanHelper", flashloan.address);

    // const lendingLogic = await ethers.deployContract("LendingLogic");
    // await lendingLogic.deployed();
    // await verify(lendingLogic.address);
    // console.log("LendingLogic", lendingLogic.address);

    const StrategyFactory = await ethers.getContractFactory("Strategy");
    const strategy = await upgrades.deployProxy(
        StrategyFactory,
        [
            "0x7141D7Fcff83ca8162D85e2978aAA4F149ab0CaE",
            "0xf55F78339188d9bcD682be6129bb9eb64c9Cb0bD",//lendingLogic.address,
            "0x1382F12861006DCA3584A7904F4bDFf1A9546D27",//flashloan.address,
            safeAggreateRatio,
            safeRatio
        ], {
            kind: "uups",
            initializer: "__Strategy_init"
        }
    );
    await strategy.deployed();
    const StrategyImpl = await upgrades.erc1967.getImplementationAddress(
        strategy.address
    );
  
    await verify(strategy.address);
    await verify(StrategyImpl);

    console.log("strategy proxy", strategy.address);
    console.log("strategy implement", StrategyImpl);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });