import {ethers, run, upgrades} from 'hardhat';
import {sleep, verify} from "./utils"

//module.exports = async() => {
async function main() {

    const marketCap = ethers.utils.parseEther("1000");
    const exitFeeRate = 20;
    const deleverageExitFee = 20;
    const VaultFactory = await ethers.getContractFactory("Vault");
    const vault = await upgrades.deployProxy(
        VaultFactory,
        [
            marketCap,
            exitFeeRate,
            deleverageExitFee
        ], {
            kind: "uups",
            initializer: "__Vault_init"
        }
    );
    await vault.deployed();
    const VaultStETHImpl = await upgrades.erc1967.getImplementationAddress(
        vault.address
    );
  
    console.log("vaultStETH proxy", vault.address);
    console.log("vaultStETH implement", VaultStETHImpl);

    await sleep(1000);

    try {
        await run("verify", {
            address: vault.address,
            constructorArguments: []
        });
        await run("verify", {
            address: VaultStETHImpl,
            constructorArguments: []
        });
    } catch(e) {
        console.log(e);
    }
    console.log("Verified Contract");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });