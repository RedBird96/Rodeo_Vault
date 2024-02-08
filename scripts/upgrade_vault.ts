import { ethers, upgrades } from "hardhat";
import type { ContractFactory } from 'ethers';
import {sleep, verify} from "./utils"

// module.exports = async (address: string) => {

async function main() {
  const Vault = await ethers.getContractFactory("VaultV2");
  const vault = await upgrades.upgradeProxy(
    "0x7141D7Fcff83ca8162D85e2978aAA4F149ab0CaE",
    Vault as ContractFactory
  );

  await vault.deployed();
  const vaultImpl = await upgrades.erc1967.getImplementationAddress(
    vault.address
  );

  console.log("Vault Proxy", vault.address);
  console.log("New Vault Implement:", vaultImpl);

  await sleep(1000);
  await verify(vaultImpl);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });