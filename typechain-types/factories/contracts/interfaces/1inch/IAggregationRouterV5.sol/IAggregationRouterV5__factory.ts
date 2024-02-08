/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IAggregationRouterV5,
  IAggregationRouterV5Interface,
} from "../../../../../contracts/interfaces/1inch/IAggregationRouterV5.sol/IAggregationRouterV5";

const _abi = [
  {
    inputs: [
      {
        internalType: "contract IAggregationExecutor",
        name: "executor",
        type: "address",
      },
      {
        components: [
          {
            internalType: "contract IERC20",
            name: "srcToken",
            type: "address",
          },
          {
            internalType: "contract IERC20",
            name: "dstToken",
            type: "address",
          },
          {
            internalType: "address payable",
            name: "srcReceiver",
            type: "address",
          },
          {
            internalType: "address payable",
            name: "dstReceiver",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "amount",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "minReturnAmount",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "flags",
            type: "uint256",
          },
        ],
        internalType: "struct IAggregationRouterV5.SwapDescription",
        name: "desc",
        type: "tuple",
      },
      {
        internalType: "bytes",
        name: "permit",
        type: "bytes",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "swap",
    outputs: [
      {
        internalType: "uint256",
        name: "returnAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "spentAmount",
        type: "uint256",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
] as const;

export class IAggregationRouterV5__factory {
  static readonly abi = _abi;
  static createInterface(): IAggregationRouterV5Interface {
    return new utils.Interface(_abi) as IAggregationRouterV5Interface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IAggregationRouterV5 {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as IAggregationRouterV5;
  }
}