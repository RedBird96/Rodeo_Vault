/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../../common";
import type {
  FlashloanHelper,
  FlashloanHelperInterface,
} from "../../../../contracts/main/flashloanHelper/FlashloanHelper";

const _abi = [
  {
    inputs: [],
    name: "CALLBACK_SUCCESS",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "aaveV3Pool",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "balancerVault",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
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
  {
    inputs: [],
    name: "executor",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "contract IERC3156FlashBorrower",
        name: "_receiver",
        type: "address",
      },
      {
        internalType: "address",
        name: "_token",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "_dataBytes",
        type: "bytes",
      },
    ],
    name: "flashLoan",
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
  {
    inputs: [
      {
        internalType: "contract IERC20[]",
        name: "_tokens",
        type: "address[]",
      },
      {
        internalType: "uint256[]",
        name: "_amounts",
        type: "uint256[]",
      },
      {
        internalType: "uint256[]",
        name: "_fees",
        type: "uint256[]",
      },
      {
        internalType: "bytes",
        name: "_params",
        type: "bytes",
      },
    ],
    name: "receiveFlashLoan",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b50611513806100206000396000f3fe608060405234801561001057600080fd5b506004361061007d5760003560e01c80638237e5381161005b5780638237e538146100f057806386a06ff014610113578063c34c08e51461012e578063f04f27071461014157600080fd5b8063158274a5146100825780631b11d0ff146100ba5780635cffe9de146100dd575b600080fd5b61009d73ba12222222228d8ba445958a75a0704d566bf2c881565b6040516001600160a01b0390911681526020015b60405180910390f35b6100cd6100c8366004610f79565b610156565b60405190151581526020016100b1565b6100cd6100eb366004610ff5565b610488565b6101056000805160206114be83398151915281565b6040519081526020016100b1565b61009d7387870bca3f3fd6335c3f4ce8392d69350b4fa4e281565b60005461009d906001600160a01b031681565b61015461014f3660046110ad565b610714565b005b6000337387870bca3f3fd6335c3f4ce8392d69350b4fa4e214801561018357506001600160a01b03841630145b6101d45760405162461bcd60e51b815260206004820152601d60248201527f4161766520666c6173686c6f616e3a20496e76616c69642063616c6c2100000060448201526064015b60405180910390fd5b6000546101ee906001600160a01b03898116911688610b60565b6000806101fd84860186611187565b9193509091508290506102f15760005460405163af8658ab60e01b81526000805160206114be833981519152916001600160a01b03169063af8658ab906102509083908e908e908e90899060040161129b565b6020604051808303816000875af115801561026f573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061029391906112d5565b146102ec5760405162461bcd60e51b8152602060048201526024808201527f4161766520666c6173686c6f616e20666f72206d6f64756c65206f6e652066616044820152631a5b195960e21b60648201526084016101cb565b610419565b600182036103db576000546040516304e0a65560e01b81526000805160206114be833981519152916001600160a01b0316906304e0a6559061033f9083908e908e908e90899060040161129b565b6020604051808303816000875af115801561035e573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061038291906112d5565b146102ec5760405162461bcd60e51b8152602060048201526024808201527f4161766520666c6173686c6f616e20666f72206d6f64756c652074776f2066616044820152631a5b195960e21b60648201526084016101cb565b60405162461bcd60e51b81526020600482015260136024820152724e6f6e6578697374656e74204d6f64756c652160681b60448201526064016101cb565b600054610446906001600160a01b0316306104348a8c6112ee565b6001600160a01b038d16929190610bc8565b6104797387870bca3f3fd6335c3f4ce8392d69350b4fa4e2610468898b6112ee565b6001600160a01b038c169190610c06565b50600198975050505050505050565b600080546001600160a01b03161580156104aa57506001600160a01b03861633145b6104f65760405162461bcd60e51b815260206004820152601d60248201527f466c6173686c6f616e48656c7065723a20496e2070726f67726573732100000060448201526064016101cb565b600080546001600160a01b0319163317815561051483850185611187565b509150819050610597576040516310ac2ddf60e21b81527387870bca3f3fd6335c3f4ce8392d69350b4fa4e2906342b0b77c906105609030908a908a908a908a9060009060040161133e565b600060405180830381600087803b15801561057a57600080fd5b505af115801561058e573d6000803e3d6000fd5b505050506106f7565b600181036106af5760408051600180825281830190925260009160208083019080368337505060408051600180825281830190925292935060009291506020808301908036833701905050905087826000815181106105f8576105f8611389565b60200260200101906001600160a01b031690816001600160a01b031681525050868160008151811061062c5761062c611389565b6020908102919091010152604051632e1c224f60e11b815273ba12222222228d8ba445958a75a0704d566bf2c890635c38449e90610676903090869086908c908c9060040161139f565b600060405180830381600087803b15801561069057600080fd5b505af11580156106a4573d6000803e3d6000fd5b5050505050506106f7565b60405162461bcd60e51b815260206004820152601860248201527f466c6173686c6f616e53656c6563746f72206572726f722e000000000000000060448201526064016101cb565b5050600080546001600160a01b0319169055600195945050505050565b3373ba12222222228d8ba445958a75a0704d566bf2c814801561074157506000546001600160a01b031615155b6107975760405162461bcd60e51b815260206004820152602160248201527f42616c616e63657220666c6173686c6f616e3a20496e76616c69642063616c6c6044820152602160f81b60648201526084016101cb565b61080060008054906101000a90046001600160a01b0316878760008181106107c1576107c1611389565b905060200201358a8a60008181106107db576107db611389565b90506020020160208101906107f09190611448565b6001600160a01b03169190610b60565b60008061080f83850185611187565b91935090915082905061096557600080546000805160206114be833981519152916001600160a01b039091169063af8658ab9082908e908e908161085557610855611389565b905060200201602081019061086a9190611448565b8c8c600081811061087d5761087d611389565b905060200201358b8b600081811061089757610897611389565b90506020020135876040518663ffffffff1660e01b81526004016108bf95949392919061129b565b6020604051808303816000875af11580156108de573d6000803e3d6000fd5b505050506040513d601f19601f8201168201806040525081019061090291906112d5565b146109605760405162461bcd60e51b815260206004820152602860248201527f42616c616e63657220666c6173686c6f616e20666f72206d6f64756c65206f6e604482015267194819985a5b195960c21b60648201526084016101cb565b610ab1565b600182036103db57600080546000805160206114be833981519152916001600160a01b03909116906304e0a6559082908e908e90816109a6576109a6611389565b90506020020160208101906109bb9190611448565b8c8c60008181106109ce576109ce611389565b905060200201358b8b60008181106109e8576109e8611389565b90506020020135876040518663ffffffff1660e01b8152600401610a1095949392919061129b565b6020604051808303816000875af1158015610a2f573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610a5391906112d5565b146109605760405162461bcd60e51b815260206004820152602860248201527f42616c616e63657220666c6173686c6f616e20666f72206d6f64756c652074776044820152671bc819985a5b195960c21b60648201526084016101cb565b610b5460008054906101000a90046001600160a01b031673ba12222222228d8ba445958a75a0704d566bf2c888886000818110610af057610af0611389565b905060200201358b8b6000818110610b0a57610b0a611389565b90506020020135610b1b91906112ee565b8d8d6000818110610b2e57610b2e611389565b9050602002016020810190610b439190611448565b6001600160a01b0316929190610bc8565b50505050505050505050565b6040516001600160a01b038316602482015260448101829052610bc390849063a9059cbb60e01b906064015b60408051601f198184030181529190526020810180516001600160e01b03166001600160e01b031990931692909217909152610cb3565b505050565b6040516001600160a01b0380851660248301528316604482015260648101829052610c009085906323b872dd60e01b90608401610b8c565b50505050565b604051636eb1769f60e11b81523060048201526001600160a01b0383811660248301526000919085169063dd62ed3e90604401602060405180830381865afa158015610c56573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c7a91906112d5565b9050610c008463095ea7b360e01b85610c9386866112ee565b6040516001600160a01b0390921660248301526044820152606401610b8c565b6000610d08826040518060400160405280602081526020017f5361666545524332303a206c6f772d6c6576656c2063616c6c206661696c6564815250856001600160a01b0316610d889092919063ffffffff16565b9050805160001480610d29575080806020019051810190610d29919061146c565b610bc35760405162461bcd60e51b815260206004820152602a60248201527f5361666545524332303a204552433230206f7065726174696f6e20646964206e6044820152691bdd081cdd58d8d9595960b21b60648201526084016101cb565b6060610d978484600085610d9f565b949350505050565b606082471015610e005760405162461bcd60e51b815260206004820152602660248201527f416464726573733a20696e73756666696369656e742062616c616e636520666f6044820152651c8818d85b1b60d21b60648201526084016101cb565b600080866001600160a01b03168587604051610e1c919061148e565b60006040518083038185875af1925050503d8060008114610e59576040519150601f19603f3d011682016040523d82523d6000602084013e610e5e565b606091505b5091509150610e6f87838387610e7a565b979650505050505050565b60608315610ee9578251600003610ee2576001600160a01b0385163b610ee25760405162461bcd60e51b815260206004820152601d60248201527f416464726573733a2063616c6c20746f206e6f6e2d636f6e747261637400000060448201526064016101cb565b5081610d97565b610d978383815115610efe5781518083602001fd5b8060405162461bcd60e51b81526004016101cb91906114aa565b6001600160a01b0381168114610f2d57600080fd5b50565b60008083601f840112610f4257600080fd5b50813567ffffffffffffffff811115610f5a57600080fd5b602083019150836020828501011115610f7257600080fd5b9250929050565b60008060008060008060a08789031215610f9257600080fd5b8635610f9d81610f18565b955060208701359450604087013593506060870135610fbb81610f18565b9250608087013567ffffffffffffffff811115610fd757600080fd5b610fe389828a01610f30565b979a9699509497509295939492505050565b60008060008060006080868803121561100d57600080fd5b853561101881610f18565b9450602086013561102881610f18565b935060408601359250606086013567ffffffffffffffff81111561104b57600080fd5b61105788828901610f30565b969995985093965092949392505050565b60008083601f84011261107a57600080fd5b50813567ffffffffffffffff81111561109257600080fd5b6020830191508360208260051b8501011115610f7257600080fd5b6000806000806000806000806080898b0312156110c957600080fd5b883567ffffffffffffffff808211156110e157600080fd5b6110ed8c838d01611068565b909a50985060208b013591508082111561110657600080fd5b6111128c838d01611068565b909850965060408b013591508082111561112b57600080fd5b6111378c838d01611068565b909650945060608b013591508082111561115057600080fd5b5061115d8b828c01610f30565b999c989b5096995094979396929594505050565b634e487b7160e01b600052604160045260246000fd5b60008060006060848603121561119c57600080fd5b8335925060208401359150604084013567ffffffffffffffff808211156111c257600080fd5b818601915086601f8301126111d657600080fd5b8135818111156111e8576111e8611171565b604051601f8201601f19908116603f0116810190838211818310171561121057611210611171565b8160405282815289602084870101111561122957600080fd5b8260208601602083013760006020848301015280955050505050509250925092565b60005b8381101561126657818101518382015260200161124e565b50506000910152565b6000815180845261128781602086016020860161124b565b601f01601f19169290920160200192915050565b6001600160a01b03868116825285166020820152604081018490526060810183905260a060808201819052600090610e6f9083018461126f565b6000602082840312156112e757600080fd5b5051919050565b8082018082111561130f57634e487b7160e01b600052601160045260246000fd5b92915050565b81835281816020850137506000828201602090810191909152601f909101601f19169091010190565b6001600160a01b038781168252861660208201526040810185905260a0606082018190526000906113729083018587611315565b905061ffff83166080830152979650505050505050565b634e487b7160e01b600052603260045260246000fd5b6001600160a01b0386811682526080602080840182905287519184018290526000928882019290919060a0860190855b818110156113ed5785518516835294830194918301916001016113cf565b5050858103604087015288518082529082019350915080880160005b8381101561142557815185529382019390820190600101611409565b50505050828103606084015261143c818587611315565b98975050505050505050565b60006020828403121561145a57600080fd5b813561146581610f18565b9392505050565b60006020828403121561147e57600080fd5b8151801515811461146557600080fd5b600082516114a081846020870161124b565b9190910192915050565b602081526000611465602083018461126f56fe439148f0bbc682ca079e46d6e2c2f0c1e3b820f1a291b069d8882abf8cf18dd9a2646970667358221220b9afabc88491eeaa06fd869aee505570e7eeea140f8a2c26b3d08891eb70d38a64736f6c63430008130033";

type FlashloanHelperConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: FlashloanHelperConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class FlashloanHelper__factory extends ContractFactory {
  constructor(...args: FlashloanHelperConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<FlashloanHelper> {
    return super.deploy(overrides || {}) as Promise<FlashloanHelper>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): FlashloanHelper {
    return super.attach(address) as FlashloanHelper;
  }
  override connect(signer: Signer): FlashloanHelper__factory {
    return super.connect(signer) as FlashloanHelper__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): FlashloanHelperInterface {
    return new utils.Interface(_abi) as FlashloanHelperInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): FlashloanHelper {
    return new Contract(address, _abi, signerOrProvider) as FlashloanHelper;
  }
}