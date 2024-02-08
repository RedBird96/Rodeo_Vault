/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../../common";

export interface IFlashLoanSimpleReceiverInterface extends utils.Interface {
  functions: {
    "executeOperation(address,uint256,uint256,address,bytes)": FunctionFragment;
  };

  getFunction(nameOrSignatureOrTopic: "executeOperation"): FunctionFragment;

  encodeFunctionData(
    functionFragment: "executeOperation",
    values: [
      PromiseOrValue<string>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<BytesLike>
    ]
  ): string;

  decodeFunctionResult(
    functionFragment: "executeOperation",
    data: BytesLike
  ): Result;

  events: {};
}

export interface IFlashLoanSimpleReceiver extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IFlashLoanSimpleReceiverInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    executeOperation(
      _asset: PromiseOrValue<string>,
      _amount: PromiseOrValue<BigNumberish>,
      _premium: PromiseOrValue<BigNumberish>,
      _initiator: PromiseOrValue<string>,
      _params: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  executeOperation(
    _asset: PromiseOrValue<string>,
    _amount: PromiseOrValue<BigNumberish>,
    _premium: PromiseOrValue<BigNumberish>,
    _initiator: PromiseOrValue<string>,
    _params: PromiseOrValue<BytesLike>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    executeOperation(
      _asset: PromiseOrValue<string>,
      _amount: PromiseOrValue<BigNumberish>,
      _premium: PromiseOrValue<BigNumberish>,
      _initiator: PromiseOrValue<string>,
      _params: PromiseOrValue<BytesLike>,
      overrides?: CallOverrides
    ): Promise<boolean>;
  };

  filters: {};

  estimateGas: {
    executeOperation(
      _asset: PromiseOrValue<string>,
      _amount: PromiseOrValue<BigNumberish>,
      _premium: PromiseOrValue<BigNumberish>,
      _initiator: PromiseOrValue<string>,
      _params: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    executeOperation(
      _asset: PromiseOrValue<string>,
      _amount: PromiseOrValue<BigNumberish>,
      _premium: PromiseOrValue<BigNumberish>,
      _initiator: PromiseOrValue<string>,
      _params: PromiseOrValue<BytesLike>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}