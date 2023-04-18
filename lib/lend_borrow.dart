import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/constants.dart';
import 'package:test_project/dummy_swap.dart';
import 'package:test_project/transaction.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math' as math;

class WalletLendBorrow {
  static var httpClient = http.Client();
  static String rpc_url =
      "https://goerli.infura.io/v3/a1a50b6285a944d98e643e6efe0bc6bf";
  var ethClient = Web3Client(rpc_url, httpClient);
  Future<DeployedContract> loadAAVEContract() async {
    String abi =
        await rootBundle.loadString("contracts/lend_borrow_contract.json");
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "Aave Pool"),
        EthereumAddress.fromHex(
            "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790")); //AAVE Pool Contract
    return contract;
  }

  static var erc20Token;
  static var aaveContract;
  static var variableDebtToken;
  static var wrappedTokenGateway;
  static var aaveProtocolDataProvider;
  loadContracts() async {
    var aave_contract = await Constants().loadContract(
        contractAddress: "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790",
        contractFileName: "lend_borrow_contract");
    aaveContract = aave_contract;
    var erc20_token_contract = await Constants().loadContract(
        contractAddress: "0x65aFADD39029741B3b8f0756952C74678c9cEC93",
        contractFileName: "test_net_erc");
    erc20Token = erc20_token_contract;
    var variable_debt_token_contract = await Constants().loadContract(
        contractFileName: "VariableDebtToken",
        contractAddress: "0xff3284be0c687c21ccb18a8e61a27aec72c520bc");
    variableDebtToken = variable_debt_token_contract;
    var wrapped_token_gateway_contract = await Constants().loadContract(
        contractFileName: "WrappedTokenGatewayV3",
        contractAddress: "0x2A498323aCaD2971a8b1936fD7540596dC9BBacD");
    wrappedTokenGateway = wrapped_token_gateway_contract;
    var aave_protocol_contract = await Constants().loadContract(
        contractFileName: "AaveProtocolDataProvider",
        contractAddress: "0xa41E284482F9923E265832bE59627d91432da76C");
    aaveProtocolDataProvider = aave_protocol_contract;
  }

  Future<List<dynamic>> callContract(
      {required String funcName,
      required List<dynamic> args,
      required DeployedContract contract}) async {
    var _contract = contract;
    var func = _contract.function(funcName);
    var result = await ethClient.call(
        sender: Constants.ethereumAddress,
        contract: _contract,
        function: func,
        params: args);
    return result;
  }

  Future<List<dynamic>> callContractData({
    required String funcName,
  }) async {
    var contract = await loadAAVEContract();
    var func = contract.function(funcName);
    var result = await ethClient.call(
        sender: Constants.ethereumAddress,
        contract: contract,
        function: func,
        params: []);
    return result;
  }

  approveERC20(
      {String ERC20Address = '',
      String addressToApprove = '',
      double amount = 0.0}) async {
    var approve;
    DeployedContract TokenContract = await Constants().loadContract(
        contractAddress: ERC20Address, contractFileName: "test_net_erc");
    var decimalsfunc = TokenContract.function('decimals');
    var senderAddress = Constants.ethereumAddress;
    final getDecimals = await ethClient.call(
        sender: senderAddress,
        contract: TokenContract,
        function: decimalsfunc,
        params: []);

    double requiredAmount = amount * math.pow(10, getDecimals[0].toInt());
    log(requiredAmount.toString());
    // log(exchange_amount.toString());
    var func = TokenContract.function("allowance");
    final getAllowance = await ethClient.call(
        sender: senderAddress,
        contract: TokenContract,
        function: func,
        params: [
          EthereumAddress.fromHex(Constants.address),
          EthereumAddress.fromHex(
              "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790") //Allowing AAVE Pool Contract
        ]);
    int allowance = getAllowance[0].toInt();
    log(allowance.toString());
    if (allowance < requiredAmount) {
      DeployedContract contract = await Constants().loadContract(
          contractFileName: "test_net_erc",
          contractAddress: ERC20Address); //Address of token to be lent
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        // contract.function(name).encodeCall(params)
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 300000,
                function: contract.function("approve"),
                parameters: [
                  EthereumAddress.fromHex(
                      addressToApprove), //Approving AAVE Contract
                  BigInt.from(requiredAmount),
                ]));
      } catch (e) {
        log(e.toString());
      }
    }
  }

  supply({String address = '', double amount = 0.0}) async {
    if (address == "0x0000000000000000000000000000000000000000") {
      DeployedContract gatewayContract = WalletLendBorrow.wrappedTokenGateway;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                value: EtherAmount.fromInt(EtherUnit.wei, amount.toInt()),
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: gatewayContract,
                maxGas: 300000,
                function: gatewayContract.function("depositETH"),
                parameters: [
                  EthereumAddress.fromHex(
                      "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790"),
                  Constants.ethereumAddress,
                  BigInt.zero
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    } else {
      log(erc20Token!.address.toString());
      var approve = await approveERC20(
          ERC20Address: address,
          amount: amount,
          addressToApprove: "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790");
      DeployedContract contract = await aaveContract;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 300000,
                function: contract.function("supply"),
                parameters: [
                  EthereumAddress.fromHex(
                      address), //Token address of token to be lent
                  BigInt.from(amount),
                  Constants.ethereumAddress,
                  BigInt.from(0)
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  getUserData({required EthereumAddress userAddress}) async {
    // loadContracts();
    DeployedContract contract = await loadAAVEContract();
    Map<String, double> userData = {};
    // var
    var data = await callContract(
        contract: contract,
        funcName: "getUserAccountData",
        args: [userAddress]);

    userData.addEntries([
      MapEntry(
          "totalCollateralBase",
          BigInt.parse(data[0].toString()).toDouble() /
              math.pow(10, 8)), //8 decimal places
      MapEntry(
          "totalDebtBase",
          BigInt.parse(data[1].toString()).toDouble() /
              math.pow(10, 8)), //8 decimal places
      MapEntry(
          "availableBorrowBase",
          BigInt.parse(data[2].toString()).toDouble() /
              math.pow(10, 8)), // 8 decimal places
      MapEntry("currentLiquidationThreshold",
          BigInt.parse(data[3].toString()).toDouble()),
      MapEntry("ltv", BigInt.parse(data[4].toString()).toDouble()),
      MapEntry(
          "healthFactor",
          BigInt.parse(data[5].toString()).toDouble() /
              math.pow(10, 18)), //18 decimal places
      MapEntry(
          "net worth",
          (BigInt.parse(data[0].toString()).toDouble() -
                      BigInt.parse(data[1].toString()).toDouble())
                  .toDouble() /
              math.pow(10, 8)),
    ]);
    return userData;
  }

  withdraw(
      {String ERC20address = '',
      double amount = 0.0,
      bool unwrap = false}) async {
    if (ERC20address == "0xCCB14936C2E000ED8393A571D15A2672537838Ad" &&
        unwrap) {
      DeployedContract contract = await wrappedTokenGateway;
      var approve = await approveERC20(
          ERC20Address: "0x7649e0d153752c556b8b23DB1f1D3d42993E83a5",
          amount: amount,
          addressToApprove: "0x2A498323aCaD2971a8b1936fD7540596dC9BBacD");
      try {
        var chainId = await ethClient.getChainId();
        var gasPrice = await ethClient.getGasPrice();
        var maxGas = await ethClient.estimateGas();
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 300000,
                function: contract.function("withdrawETH"),
                parameters: [
                  EthereumAddress.fromHex(
                      "0x7b5c526b7f8dfdff278b4a3e045083fba4028790"), //Token address of token to be lent
                  BigInt.from(amount),
                  Constants.ethereumAddress,
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    } else {
      DeployedContract contract = await aaveContract;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 600000,
                function: contract.function("withdraw"),
                parameters: [
                  EthereumAddress.fromHex(
                      ERC20address), //Token address of token to be lent
                  BigInt.from(amount),
                  Constants.ethereumAddress,
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  borrow(
      {String ERC20address = '',
      double amount = 0.0,
      bool unwrap = false}) async {
    if (ERC20address == "0xCCB14936C2E000ED8393A571D15A2672537838Ad" &&
        unwrap) {
      DeployedContract approveContract = variableDebtToken;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: approveContract,
                maxGas: 300000,
                function: approveContract.function("approveDelegation"),
                parameters: [
                  EthereumAddress.fromHex(
                      "0x2A498323aCaD2971a8b1936fD7540596dC9BBacD"),
                  BigInt.from(amount),
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
      DeployedContract gatewayContract = await wrappedTokenGateway;
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: gatewayContract,
                maxGas: 300000,
                function: gatewayContract.function("borrowETH"),
                parameters: [
                  EthereumAddress.fromHex(
                      "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790"),
                  BigInt.from(amount),
                  BigInt.two,
                  BigInt.zero
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    } else {
      Map tokendata = await getTokenData();
      var decimal = tokendata.keys.firstWhere(
          (element) => tokendata[element]['decimals'] == 18,
          orElse: () => "null");
      log(decimal);
      DeployedContract contract = await aaveContract;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 300000,
                function: contract.function("borrow"),
                parameters: [
                  EthereumAddress.fromHex(
                      ERC20address), //Token address of token to be lent
                  BigInt.from(amount),
                  BigInt.two,
                  BigInt.zero,
                  Constants.ethereumAddress,
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    }
    // DeployedContract contract = await loadAAVEContract();
    // var chainId = await ethClient.getChainId();
    // var gasPrice = await ethClient.getGasPrice();
    // var maxGas = await ethClient.estimateGas();
    // try {
    //   var trans = await ethClient.sendTransaction(
    //       chainId: chainId.toInt(),
    //       Constants.userCredentials,
    //       Transaction.callContract(
    //           gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
    //           contract: contract,
    //           maxGas: 300000,
    //           function: contract.function("borrow"),
    //           parameters: [
    //             EthereumAddress.fromHex(
    //                 ERC20address), //Token address of token to be lent
    //             BigInt.from(amount),
    //             BigInt.two,
    //             BigInt.zero,
    //             Constants.ethereumAddress,
    //           ]));
    //   log(trans);
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  repay(
      {String ERC20address = '',
      double amount = 0.0,
      int repayType = 0}) async {
    if (repayType == 0) {
      //repay type 0 means repay with normal tokens
      var approve = await approveERC20(
          ERC20Address: ERC20address,
          amount: amount,
          addressToApprove: "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790");
      DeployedContract contract = await aaveContract;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 1000000,
                function: contract.function("repay"),
                parameters: [
                  EthereumAddress.fromHex(
                      ERC20address), //Token address of token to be lent
                  BigInt.from(amount),
                  BigInt.two,
                  Constants.ethereumAddress,
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    } else if (repayType == 1) {
      //replay type 1 measn repay with aTokens
      DeployedContract contract = await aaveContract;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: contract,
                maxGas: 300000,
                function: contract.function("repayWithATokens"),
                parameters: [
                  EthereumAddress.fromHex(
                      ERC20address), //Token address of token to be lent
                  BigInt.from(amount),
                  BigInt.two,
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    } else if (repayType == 2 &&
        (ERC20address == "0x0000000000000000000000000000000000000000" ||
            ERC20address == "0xCCB14936C2E000ED8393A571D15A2672537838Ad")) {
      //repay type 2 means repay with unwrapped eth
      DeployedContract gatewayContract = await wrappedTokenGateway;
      var chainId = await ethClient.getChainId();
      var gasPrice = await ethClient.getGasPrice();
      var maxGas = await ethClient.estimateGas();
      try {
        var trans = await ethClient.sendTransaction(
            chainId: chainId.toInt(),
            Constants.userCredentials,
            Transaction.callContract(
                value: EtherAmount.fromInt(EtherUnit.wei, amount.toInt()),
                gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
                contract: gatewayContract,
                maxGas: 300000,
                function: gatewayContract.function("repayETH"),
                parameters: [
                  EthereumAddress.fromHex(
                      "0x7b5C526B7F8dfdff278b4a3e045083FBA4028790"),
                  BigInt.from(amount),
                  BigInt.two,
                  Constants.ethereumAddress
                ]));
        log(trans);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  getTokenData() async {
    var contract = await aaveProtocolDataProvider;
    var userData = await callContract(
      funcName: "getAllReservesTokens",
      args: [],
      contract: contract,
    );
    // log(userData.toString());
    List<dynamic> data1 = [];
    List<dynamic> data2 = [];
    List<dynamic> data3 = [];
    List<dynamic> data4 = [];
    Map<dynamic, Map> tokenData = {};
    var _data;
    int i = 0;
    for (_data in userData[0]) {
      data1.add(await callContract(
          funcName: "getReserveData",
          args: [EthereumAddress.fromHex(_data[1].toString())],
          contract: contract));
      data2.add(await callContract(
          funcName: "getReserveConfigurationData",
          args: [EthereumAddress.fromHex(_data[1].toString())],
          contract: contract));
      data3.add(await callContract(
          funcName: "getUserReserveData",
          args: [
            EthereumAddress.fromHex(_data[1].toString()),
            Constants.ethereumAddress
          ],
          contract: contract));
      data4.add(await callContract(
          funcName: "getSiloedBorrowing",
          args: [EthereumAddress.fromHex(_data[1].toString())],
          contract: contract));
      tokenData.addEntries([
        MapEntry(_data[1].toString(), {
          "variableBorrowRate": data1[i][6],
          "variableBorrowIndex": data1[i][10],
          "accruedToTreasureyScaled": data1[i][1],
          "totalAToken": data1[i][2],
          "totalStableDebt": data1[i][3],
          "totalVariableDebt": data1[i][4],
          "liquidityIndex": data1[i][9],
          "decimals": data2[i][0],
          "ltv": data2[i][1],
          "liquidationThreshold": data2[i][2],
          "liquidationBonus": data2[i][3],
          "reserveFactor": data2[i][4],
          "CollateralEnabled": data2[i][5],
          "BorrowEnabled": data2[i][6],
          "isActive": data2[i][7],
          "isFrozen": data2[i][8],
          "currentVariableDebt": data3[i][3],
          "aTokenbalance": data3[i][0],
          "scaledVariableDebt": data3[i][4],
          "liquidityRate": data3[i][5],
          "usageAsCollateralEnabled": data3[i][8],
          "siloedAsset": data4[i][0],
        })
      ]);
      i++;
    }
    // log(tokenData.toString());
    return tokenData;
    // log(data1.toString());
    // log(data2.toString());
    // log(data3.toString());
  }

  toggleCollateral({String ERC20address = '', bool toggle = false}) async {
    DeployedContract contract = await aaveContract;
    var chainId = await ethClient.getChainId();
    var gasPrice = await ethClient.getGasPrice();
    var maxGas = await ethClient.estimateGas();
    try {
      var trans = await ethClient.sendTransaction(
          chainId: chainId.toInt(),
          Constants.userCredentials,
          Transaction.callContract(
              gasPrice: EtherAmount.inWei(BigInt.from(2000000000)),
              contract: contract,
              maxGas: 300000,
              function: contract.function("setUserUseReserveAsCollateral"),
              parameters: [EthereumAddress.fromHex(ERC20address), toggle]));
      log(trans);
    } catch (e) {
      log(e.toString());
    }
  }
}
