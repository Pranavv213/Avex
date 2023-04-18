import 'package:test_project/deepak_services/network.dart';
import 'package:test_project/deepak_services/evm.service.dart' as evm;
import 'package:web3dart/web3dart.dart';

loadErc20Contract(
  String tokenAddress,
  Web3Client client,
) {
  return evm.loadContract("erc20.abi.json", tokenAddress, client);
}

checkAndSetAllowance(
    Web3Client client,
    Network network,
    Credentials credentials,
    String tokenAddress,
    String approvalAddress,
    String amount) async {
  if (!(await checkAllowance(
      client, credentials, tokenAddress, approvalAddress, amount))) {
    return await setAllowance(
        client, network, credentials, tokenAddress, approvalAddress, amount);
  }
}

Future<bool> checkAllowance(Web3Client client, Credentials credentials,
    String tokenAddress, String approvalAddress, String amount) async {
  if (tokenAddress == '0x0000000000000000000000000000000000000000') {
    return true;
  }
  var tokenContract = await loadErc20Contract(tokenAddress, client);
  var allowanceFunc = tokenContract.function('allowance');
  var allowance = await client.call(
    contract: tokenContract,
    function: allowanceFunc,
    params: [credentials.address, EthereumAddress.fromHex(approvalAddress)],
  );
  print("allowance: $allowance");
  return (allowance.first >= BigInt.parse(amount));
}

Future<String> setAllowance(
    Web3Client client,
    Network network,
    Credentials credentials,
    String tokenAddress,
    String approvalAddress,
    String amount) async {
  var tokenContract = await loadErc20Contract(tokenAddress, client);
  var approveFunc = tokenContract.function('approve');
  var gasOptions = await evm.getGasFee(client);
  var approveTx = evm.createContractTransaction(
      tokenContract,
      approveFunc,
      [EthereumAddress.fromHex(approvalAddress), BigInt.parse(amount)],
      gasOptions[1].maxFeePerGas,
      gasOptions[1].maxPriorityFeePerGas);
  return await evm.sendTransaction(client, network, credentials, approveTx);
}

Future<String> transferToken(
    Web3Client client,
    Network network,
    Credentials credentials,
    String tokenAddress,
    String to,
    String amount) async {
  var tokenContract = await loadErc20Contract(tokenAddress, client);
  var transferFunc = tokenContract.function('transfer');
  var gasOptions = await evm.getGasFee(client);
  var transferTx = evm.createContractTransaction(
      tokenContract,
      transferFunc,
      [EthereumAddress.fromHex(to), BigInt.parse(amount)],
      gasOptions[1].maxFeePerGas,
      gasOptions[1].maxPriorityFeePerGas);
  return await evm.sendTransaction(client, network, credentials, transferTx);
}

Future<String> transferNativeToken(Web3Client client, Network network,
    Credentials credentials, String to, String amount) async {
  var gasOptions = await evm.getGasFee(client);
  var transferTx = evm.createTransaction(
      EthereumAddress.fromHex(to),
      BigInt.parse(amount),
      gasOptions[1].maxFeePerGas,
      gasOptions[1].maxPriorityFeePerGas,
      null);
  return await evm.sendTransaction(client, network, credentials, transferTx);
}
