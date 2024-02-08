/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IFlashLoanSimpleReceiver,
  IFlashLoanSimpleReceiverInterface,
} from "../../../../contracts/interfaces/aaveV3/IFlashLoanSimpleReceiver";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_asset",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_premium",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_initiator",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "_params",
        type: "bytes",
      },
    ],
    name: "executeOperation",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IFlashLoanSimpleReceiver__factory {
  static readonly abi = _abi;
  static createInterface(): IFlashLoanSimpleReceiverInterface {
    return new utils.Interface(_abi) as IFlashLoanSimpleReceiverInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IFlashLoanSimpleReceiver {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as IFlashLoanSimpleReceiver;
  }
}