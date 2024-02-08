import { ethers, upgrades } from "hardhat";
import type { ContractFactory } from 'ethers';
import {sleep, verify} from "./utils"

// module.exports = async (address: string) => {

async function main() {
  const Staking = await ethers.getContractFactory("Strategy");
  const staking = await upgrades.upgradeProxy(
    "0x79cf424266153Fa373f548D38E2AB2283a8775b7",
    Staking as ContractFactory
  );

  await staking.deployed();
  const stakingImpl = await upgrades.erc1967.getImplementationAddress(
    staking.address
  );

  console.log("Staking Proxy", staking.address);
  console.log("New Staking Implement:", stakingImpl);

  await sleep(1000);
  await verify(stakingImpl);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.log(error);
        process.exit(1);
    });