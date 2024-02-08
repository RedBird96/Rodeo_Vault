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

export interface ILendingLogicInterface extends utils.Interface {
  functions: {
    "borrow(address,uint256)": FunctionFragment;
    "deposit(address,uint256)": FunctionFragment;
    "enterProtocol()": FunctionFragment;
    "exitProtocol()": FunctionFragment;
    "getAvailableBorrowsETH(address)": FunctionFragment;
    "getAvailableWithdrawsStETH(address)": FunctionFragment;
    "getNetAssetsInfo(address)": FunctionFragment;
    "getProtocolAccountData(address)": FunctionFragment;
    "getProtocolCollateralRatio(address)": FunctionFragment;
    "getProtocolLeverageAmount(address,bool,uint256,uint256)": FunctionFragment;
    "repay(address,uint256)": FunctionFragment;
    "withdraw(address,uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "borrow"
      | "deposit"
      | "enterProtocol"
      | "exitProtocol"
      | "getAvailableBorrowsETH"
      | "getAvailableWithdrawsStETH"
      | "getNetAssetsInfo"
      | "getProtocolAccountData"
      | "getProtocolCollateralRatio"
      | "getProtocolLeverageAmount"
      | "repay"
      | "withdraw"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "borrow",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "deposit",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "enterProtocol",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "exitProtocol",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "getAvailableBorrowsETH",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getAvailableWithdrawsStETH",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getNetAssetsInfo",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getProtocolAccountData",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getProtocolCollateralRatio",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "getProtocolLeverageAmount",
    values: [
      PromiseOrValue<string>,
      PromiseOrValue<boolean>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "repay",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "withdraw",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(functionFragment: "borrow", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "deposit", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "enterProtocol",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "exitProtocol",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAvailableBorrowsETH",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAvailableWithdrawsStETH",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getNetAssetsInfo",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getProtocolAccountData",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getProtocolCollateralRatio",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getProtocolLeverageAmount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "repay", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "withdraw", data: BytesLike): Result;

  events: {};
}

export interface ILendingLogic extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: ILendingLogicInterface;

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
    borrow(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    deposit(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    enterProtocol(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    exitProtocol(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getAvailableBorrowsETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getAvailableWithdrawsStETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getNetAssetsInfo(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber, BigNumber] & {
        totalAssets: BigNumber;
        totalDebt: BigNumber;
        netAssets: BigNumber;
        aggregatedRatio: BigNumber;
      }
    >;

    getProtocolAccountData(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber] & {
        stEthAmount: BigNumber;
        debtEthAmount: BigNumber;
      }
    >;

    getProtocolCollateralRatio(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<[BigNumber] & { ratio: BigNumber }>;

    getProtocolLeverageAmount(
      _account: PromiseOrValue<string>,
      _isDepositOrWithdraw: PromiseOrValue<boolean>,
      _depositOrWithdraw: PromiseOrValue<BigNumberish>,
      _safeRatio: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [boolean, BigNumber] & { isLeverage: boolean; amount: BigNumber }
    >;

    repay(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    withdraw(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  borrow(
    asset: PromiseOrValue<string>,
    amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  deposit(
    asset: PromiseOrValue<string>,
    amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  enterProtocol(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  exitProtocol(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getAvailableBorrowsETH(
    _account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getAvailableWithdrawsStETH(
    _account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getNetAssetsInfo(
    _account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<
    [BigNumber, BigNumber, BigNumber, BigNumber] & {
      totalAssets: BigNumber;
      totalDebt: BigNumber;
      netAssets: BigNumber;
      aggregatedRatio: BigNumber;
    }
  >;

  getProtocolAccountData(
    _account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<
    [BigNumber, BigNumber] & {
      stEthAmount: BigNumber;
      debtEthAmount: BigNumber;
    }
  >;

  getProtocolCollateralRatio(
    _account: PromiseOrValue<string>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getProtocolLeverageAmount(
    _account: PromiseOrValue<string>,
    _isDepositOrWithdraw: PromiseOrValue<boolean>,
    _depositOrWithdraw: PromiseOrValue<BigNumberish>,
    _safeRatio: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<[boolean, BigNumber] & { isLeverage: boolean; amount: BigNumber }>;

  repay(
    asset: PromiseOrValue<string>,
    amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  withdraw(
    asset: PromiseOrValue<string>,
    amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    borrow(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    deposit(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    enterProtocol(overrides?: CallOverrides): Promise<void>;

    exitProtocol(overrides?: CallOverrides): Promise<void>;

    getAvailableBorrowsETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAvailableWithdrawsStETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getNetAssetsInfo(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber, BigNumber] & {
        totalAssets: BigNumber;
        totalDebt: BigNumber;
        netAssets: BigNumber;
        aggregatedRatio: BigNumber;
      }
    >;

    getProtocolAccountData(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber] & {
        stEthAmount: BigNumber;
        debtEthAmount: BigNumber;
      }
    >;

    getProtocolCollateralRatio(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getProtocolLeverageAmount(
      _account: PromiseOrValue<string>,
      _isDepositOrWithdraw: PromiseOrValue<boolean>,
      _depositOrWithdraw: PromiseOrValue<BigNumberish>,
      _safeRatio: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<
      [boolean, BigNumber] & { isLeverage: boolean; amount: BigNumber }
    >;

    repay(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    withdraw(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    borrow(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    deposit(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    enterProtocol(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    exitProtocol(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getAvailableBorrowsETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAvailableWithdrawsStETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getNetAssetsInfo(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getProtocolAccountData(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getProtocolCollateralRatio(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getProtocolLeverageAmount(
      _account: PromiseOrValue<string>,
      _isDepositOrWithdraw: PromiseOrValue<boolean>,
      _depositOrWithdraw: PromiseOrValue<BigNumberish>,
      _safeRatio: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    repay(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    withdraw(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    borrow(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    deposit(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    enterProtocol(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    exitProtocol(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getAvailableBorrowsETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAvailableWithdrawsStETH(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getNetAssetsInfo(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getProtocolAccountData(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getProtocolCollateralRatio(
      _account: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getProtocolLeverageAmount(
      _account: PromiseOrValue<string>,
      _isDepositOrWithdraw: PromiseOrValue<boolean>,
      _depositOrWithdraw: PromiseOrValue<BigNumberish>,
      _safeRatio: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    repay(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    withdraw(
      asset: PromiseOrValue<string>,
      amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}