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
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../common";

export interface VaultStETHWrapperInterface extends utils.Interface {
  functions: {
    "ETH_ADDR()": FunctionFragment;
    "STETH_ADDR()": FunctionFragment;
    "WETH_ADDR()": FunctionFragment;
    "WSTETH_ADDR()": FunctionFragment;
    "deposit(uint256,bytes,uint256,address)": FunctionFragment;
    "depositWstETH(uint256,address)": FunctionFragment;
    "getWithdrawSwapAmount(uint256)": FunctionFragment;
    "oneInchRouter()": FunctionFragment;
    "vaultAddr()": FunctionFragment;
    "withdraw(uint256,bytes,uint256,address,bool)": FunctionFragment;
    "withdrawWstETH(uint256,address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "ETH_ADDR"
      | "STETH_ADDR"
      | "WETH_ADDR"
      | "WSTETH_ADDR"
      | "deposit"
      | "depositWstETH"
      | "getWithdrawSwapAmount"
      | "oneInchRouter"
      | "vaultAddr"
      | "withdraw"
      | "withdrawWstETH"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "ETH_ADDR", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "STETH_ADDR",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "WETH_ADDR", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "WSTETH_ADDR",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "deposit",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "depositWstETH",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getWithdrawSwapAmount",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "oneInchRouter",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "vaultAddr", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "withdraw",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BytesLike>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<string>,
      PromiseOrValue<boolean>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "withdrawWstETH",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(functionFragment: "ETH_ADDR", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "STETH_ADDR", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "WETH_ADDR", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "WSTETH_ADDR",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "deposit", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "depositWstETH",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getWithdrawSwapAmount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "oneInchRouter",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "vaultAddr", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "withdraw", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "withdrawWstETH",
    data: BytesLike
  ): Result;

  events: {
    "Deposit(address,uint256,uint256,address)": EventFragment;
    "DepositWSTETH(address,uint256,uint256,address)": EventFragment;
    "Withdraw(address,uint256,uint256,address)": EventFragment;
    "WithdrawWSTETH(address,uint256,uint256,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "Deposit"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "DepositWSTETH"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "Withdraw"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "WithdrawWSTETH"): EventFragment;
}

export interface DepositEventObject {
  sender: string;
  amount: BigNumber;
  swapGet: BigNumber;
  receiver: string;
}
export type DepositEvent = TypedEvent<
  [string, BigNumber, BigNumber, string],
  DepositEventObject
>;

export type DepositEventFilter = TypedEventFilter<DepositEvent>;

export interface DepositWSTETHEventObject {
  sender: string;
  stAmount: BigNumber;
  depositWst: BigNumber;
  receiver: string;
}
export type DepositWSTETHEvent = TypedEvent<
  [string, BigNumber, BigNumber, string],
  DepositWSTETHEventObject
>;

export type DepositWSTETHEventFilter = TypedEventFilter<DepositWSTETHEvent>;

export interface WithdrawEventObject {
  sender: string;
  stAmount: BigNumber;
  swapGet: BigNumber;
  receiver: string;
}
export type WithdrawEvent = TypedEvent<
  [string, BigNumber, BigNumber, string],
  WithdrawEventObject
>;

export type WithdrawEventFilter = TypedEventFilter<WithdrawEvent>;

export interface WithdrawWSTETHEventObject {
  sender: string;
  stAmount: BigNumber;
  withdrawWst: BigNumber;
  receiver: string;
}
export type WithdrawWSTETHEvent = TypedEvent<
  [string, BigNumber, BigNumber, string],
  WithdrawWSTETHEventObject
>;

export type WithdrawWSTETHEventFilter = TypedEventFilter<WithdrawWSTETHEvent>;

export interface VaultStETHWrapper extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: VaultStETHWrapperInterface;

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
    ETH_ADDR(overrides?: CallOverrides): Promise<[string]>;

    STETH_ADDR(overrides?: CallOverrides): Promise<[string]>;

    WETH_ADDR(overrides?: CallOverrides): Promise<[string]>;

    WSTETH_ADDR(overrides?: CallOverrides): Promise<[string]>;

    deposit(
      _wethAmount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minStEthIn: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    depositWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getWithdrawSwapAmount(
      amount_: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber] & { stEthSwapAmount: BigNumber }>;

    oneInchRouter(overrides?: CallOverrides): Promise<[string]>;

    vaultAddr(overrides?: CallOverrides): Promise<[string]>;

    withdraw(
      _amount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minEthOut: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      _isWeth: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    withdrawWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  ETH_ADDR(overrides?: CallOverrides): Promise<string>;

  STETH_ADDR(overrides?: CallOverrides): Promise<string>;

  WETH_ADDR(overrides?: CallOverrides): Promise<string>;

  WSTETH_ADDR(overrides?: CallOverrides): Promise<string>;

  deposit(
    _wethAmount: PromiseOrValue<BigNumberish>,
    _swapCalldata: PromiseOrValue<BytesLike>,
    _minStEthIn: PromiseOrValue<BigNumberish>,
    _receiver: PromiseOrValue<string>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  depositWstETH(
    _amount: PromiseOrValue<BigNumberish>,
    _receiver: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getWithdrawSwapAmount(
    amount_: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  oneInchRouter(overrides?: CallOverrides): Promise<string>;

  vaultAddr(overrides?: CallOverrides): Promise<string>;

  withdraw(
    _amount: PromiseOrValue<BigNumberish>,
    _swapCalldata: PromiseOrValue<BytesLike>,
    _minEthOut: PromiseOrValue<BigNumberish>,
    _receiver: PromiseOrValue<string>,
    _isWeth: PromiseOrValue<boolean>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  withdrawWstETH(
    _amount: PromiseOrValue<BigNumberish>,
    _receiver: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    ETH_ADDR(overrides?: CallOverrides): Promise<string>;

    STETH_ADDR(overrides?: CallOverrides): Promise<string>;

    WETH_ADDR(overrides?: CallOverrides): Promise<string>;

    WSTETH_ADDR(overrides?: CallOverrides): Promise<string>;

    deposit(
      _wethAmount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minStEthIn: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    depositWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getWithdrawSwapAmount(
      amount_: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    oneInchRouter(overrides?: CallOverrides): Promise<string>;

    vaultAddr(overrides?: CallOverrides): Promise<string>;

    withdraw(
      _amount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minEthOut: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      _isWeth: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    withdrawWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  filters: {
    "Deposit(address,uint256,uint256,address)"(
      sender?: null,
      amount?: null,
      swapGet?: null,
      receiver?: null
    ): DepositEventFilter;
    Deposit(
      sender?: null,
      amount?: null,
      swapGet?: null,
      receiver?: null
    ): DepositEventFilter;

    "DepositWSTETH(address,uint256,uint256,address)"(
      sender?: null,
      stAmount?: null,
      depositWst?: null,
      receiver?: null
    ): DepositWSTETHEventFilter;
    DepositWSTETH(
      sender?: null,
      stAmount?: null,
      depositWst?: null,
      receiver?: null
    ): DepositWSTETHEventFilter;

    "Withdraw(address,uint256,uint256,address)"(
      sender?: null,
      stAmount?: null,
      swapGet?: null,
      receiver?: null
    ): WithdrawEventFilter;
    Withdraw(
      sender?: null,
      stAmount?: null,
      swapGet?: null,
      receiver?: null
    ): WithdrawEventFilter;

    "WithdrawWSTETH(address,uint256,uint256,address)"(
      sender?: null,
      stAmount?: null,
      withdrawWst?: null,
      receiver?: null
    ): WithdrawWSTETHEventFilter;
    WithdrawWSTETH(
      sender?: null,
      stAmount?: null,
      withdrawWst?: null,
      receiver?: null
    ): WithdrawWSTETHEventFilter;
  };

  estimateGas: {
    ETH_ADDR(overrides?: CallOverrides): Promise<BigNumber>;

    STETH_ADDR(overrides?: CallOverrides): Promise<BigNumber>;

    WETH_ADDR(overrides?: CallOverrides): Promise<BigNumber>;

    WSTETH_ADDR(overrides?: CallOverrides): Promise<BigNumber>;

    deposit(
      _wethAmount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minStEthIn: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    depositWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getWithdrawSwapAmount(
      amount_: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    oneInchRouter(overrides?: CallOverrides): Promise<BigNumber>;

    vaultAddr(overrides?: CallOverrides): Promise<BigNumber>;

    withdraw(
      _amount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minEthOut: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      _isWeth: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    withdrawWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    ETH_ADDR(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    STETH_ADDR(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    WETH_ADDR(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    WSTETH_ADDR(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    deposit(
      _wethAmount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minStEthIn: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    depositWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getWithdrawSwapAmount(
      amount_: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    oneInchRouter(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    vaultAddr(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    withdraw(
      _amount: PromiseOrValue<BigNumberish>,
      _swapCalldata: PromiseOrValue<BytesLike>,
      _minEthOut: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      _isWeth: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    withdrawWstETH(
      _amount: PromiseOrValue<BigNumberish>,
      _receiver: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}