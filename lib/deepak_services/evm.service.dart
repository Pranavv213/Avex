import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:test_project/deepak_services/network.dart';
import 'package:web3dart/web3dart.dart';
import 'package:eip1559/eip1559.dart' as eip1559;
import 'package:ens_dart/ens_dart.dart';

Web3Client getEthClient(Network network) {
  var httpClient = Client();
  return Web3Client(network.rpc, httpClient);
}

Future<String> getEnsName(Web3Client client, EthereumAddress address) async {
  var ens = Ens(client: client);
  var name = await ens.withAddress(address).getName();
  return name;
}

Future<EthereumAddress> resolveEnsName(Web3Client client, String name) async {
  var ens = Ens(client: client);
  var address = await ens.withName(name).getAddress();
  return address;
}

Future<EtherAmount> getBalance(
    Web3Client client, EthereumAddress address) async {
  return await client.getBalance(address);
}

Future<List<eip1559.Fee>> getGasFee(Web3Client client) async {
  return await client.getGasInEIP1559();
}

Transaction createTransaction(EthereumAddress to, BigInt? value,
    BigInt maxFeePerGas, BigInt maxPriorityFeePerGas, Uint8List? data) {
  value ??= BigInt.zero;
  return Transaction(
      to: to,
      value: EtherAmount.fromBigInt(EtherUnit.wei, value),
      data: data,
      maxPriorityFeePerGas:
          EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeePerGas),
      maxFeePerGas: EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas));
}

Transaction createContractTransaction(
    DeployedContract contract,
    ContractFunction function,
    List<dynamic> params,
    BigInt maxFeePerGas,
    BigInt maxPriorityFeePerGas) {
  return Transaction.callContract(
    contract: contract,
    function: function,
    parameters: params,
    maxPriorityFeePerGas:
        EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeePerGas),
    maxFeePerGas: EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas),
  );
}

Future<BigInt> estimateGas(Web3Client client, Transaction transaction) async {
  return await client.estimateGas(
      sender: transaction.from,
      to: transaction.to,
      value: transaction.value,
      data: transaction.data,
      gasPrice: transaction.gasPrice,
      maxFeePerGas: transaction.maxFeePerGas,
      maxPriorityFeePerGas: transaction.maxPriorityFeePerGas);
}

Future<String> sendTransaction(Web3Client client, Network network,
    Credentials credentials, Transaction transaction) async {
  return await client.sendTransaction(credentials, transaction,
      chainId: network.chainId);
}

Future<DeployedContract> loadContract(
    String abiPath, String contractAddress, Web3Client client) async {
  return DeployedContract(
      ContractAbi.fromJson(jsonEncode(contractAbi), "ERC20"),
      EthereumAddress.fromHex(contractAddress));
}

Future<ContractAbi> loadAbi() async {
  return ContractAbi.fromJson(jsonEncode(contractAbi), "ERC20");
}

const contractAbi = [
  {
    "constant": true,
    "inputs": [],
    "name": "name",
    "outputs": [
      {"name": "", "type": "string"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "_spender", "type": "address"},
      {"name": "_value", "type": "uint256"}
    ],
    "name": "approve",
    "outputs": [
      {"name": "", "type": "bool"}
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "totalSupply",
    "outputs": [
      {"name": "", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "_from", "type": "address"},
      {"name": "_to", "type": "address"},
      {"name": "_value", "type": "uint256"}
    ],
    "name": "transferFrom",
    "outputs": [
      {"name": "", "type": "bool"}
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "decimals",
    "outputs": [
      {"name": "", "type": "uint8"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "_owner", "type": "address"}
    ],
    "name": "balanceOf",
    "outputs": [
      {"name": "balance", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "symbol",
    "outputs": [
      {"name": "", "type": "string"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {"name": "_to", "type": "address"},
      {"name": "_value", "type": "uint256"}
    ],
    "name": "transfer",
    "outputs": [
      {"name": "", "type": "bool"}
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {"name": "_owner", "type": "address"},
      {"name": "_spender", "type": "address"}
    ],
    "name": "allowance",
    "outputs": [
      {"name": "", "type": "uint256"}
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {"payable": true, "stateMutability": "payable", "type": "fallback"},
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "owner", "type": "address"},
      {"indexed": true, "name": "spender", "type": "address"},
      {"indexed": false, "name": "value", "type": "uint256"}
    ],
    "name": "Approval",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {"indexed": true, "name": "from", "type": "address"},
      {"indexed": true, "name": "to", "type": "address"},
      {"indexed": false, "name": "value", "type": "uint256"}
    ],
    "name": "Transfer",
    "type": "event"
  }
];
