import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
// import 'dart:js';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/key_sig.dart';
import 'package:test_project/transaction.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'constants.dart';
import 'package:test_project/deepak_services/erc20.service.dart' as erc20;
import 'package:test_project/deepak_services/evm.service.dart' as evm;
import 'package:test_project/deepak_services/swap.service.dart' as Swap;
import 'package:test_project/deepak_services/network.dart';

class WalletSwap extends StatefulWidget {
  WalletSwap({super.key});
  static String pvtkey =
      "e99c15b79e18f14a08fc209ac2b6a2f4c70ee878a6e421c667562a94d2aeef9f";
  static String user_address = _credentials.address.hex.toString();
  static Credentials _credentials = EthPrivateKey.fromHex(pvtkey);
  static var httpClient = http.Client();
  static String rpc_url = "https://eth.llamarpc.com";
  var ethClient = Web3Client(rpc_url, httpClient);
  // static String token1 = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
  static String ethAddress = '0x0000000000000000000000000000000000000000';
  var swapdata;
  static const apiUrl = "li.quest";
  static const fromChain = "137";
  static const toChain = "137";
  static const fromToken = "0x0000000000000000000000000000000000000000"; //Matic
  static const toToken = "0xbbba073c31bf03b8acf7c28ef0738decf3695683"; // Sand
  static const fromAmount = '100000000000000000';
  // static Map<String, String> check_allowance_query_params = {
  //   // 'sellToken': '0xE68104D83e647b7c1C15a91a8D8aAD21a51B3B3E',
  //   // 'buyToken': '0x0000000000000000000000000000000000000000',
  //   // 'amount': '100000000000000000',
  //   // 'slippage': '1',
  //   // 'disableEstimate': 'false',
  //   // 'allowPartialFill': 'false'
  //   'takerAddress': user_address,
  //   'sellToken': '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee',
  //   'buyToken': '0xE68104D83e647b7c1C15a91a8D8aAD21a51B3B3E',
  //   'sellAmount': '1000000000000000'
  // };

  void swap(
      {String fromToken = '',
      String toToken = '',
      String fromAmount = ""}) async {
    var credentials = EthPrivateKey.fromHex("");
    var quote = await Swap.getQuote(apiUrl, fromChain, fromToken, toChain,
        toToken, fromAmount.toString(), credentials.address.toString());

    var client = evm.getEthClient(Network.polygonMatic);

    //  Check and set Allowance
    var txRec = await erc20.checkAndSetAllowance(
        client,
        Network.polygonMatic,
        credentials,
        quote.action.fromToken.address,
        quote.estimate!.approvalAddress,
        fromAmount.toString());
    log(fromAmount);
    print("txRec: $txRec");

    var transaction = Transaction(
        to: EthereumAddress.fromHex(quote.transactionRequest!.to!),
        data: hexToBytes(quote.transactionRequest!.data!),
        maxGas: hexToDartInt(quote.transactionRequest!.gasLimit!),
        gasPrice: EtherAmount.fromBigInt(
            EtherUnit.wei, hexToInt(quote.transactionRequest!.gasPrice!)),
        value: EtherAmount.fromBigInt(
            EtherUnit.wei, hexToInt(quote.transactionRequest!.value!)));
    var tx = await evm.sendTransaction(
        client, Network.polygonMatic, credentials, transaction);
    print("tx: $tx");

    // DeployedContract contract1 = await Constants().loadContract(
    //     contractFileName: "erc20_token", contractAddress: fromToken);
    // // DeployedContract ethContract = await loadContract(tokenAdress: ethAddress);
    // var decimalsfunc = contract1.function('decimals');
    // var senderAddress = Constants.ethereumAddress;
    // final getDecimals = await ethClient.call(
    //     sender: senderAddress,
    //     contract: contract1,
    //     function: decimalsfunc,
    //     params: []);
    // // log(get_decimals.first.toString());

    // double exchangeAmount = fromAmount * math.pow(10, getDecimals[0].toInt());
    // log(exchangeAmount.toString());
    // // log(exchange_amount.toString());
    // var func = contract1.function("allowance");
    // final getAllowance = await ethClient.call(
    //     sender: senderAddress,
    //     contract: contract1,
    //     function: func,
    //     params: [
    //       EthereumAddress.fromHex(_credentials.address.hex),
    //       EthereumAddress.fromHex(fromToken)
    //     ]);
    // int allowance = getAllowance[0].toInt();
    // if (allowance < exchangeAmount) {
    //   var func = contract1.function("approve");
    //   final approve = await ethClient.call(
    //       sender: senderAddress,
    //       contract: contract1,
    //       function: func,
    //       params: [
    //         EthereumAddress.fromHex(_credentials.address.hex),
    //         BigInt.from(allowance)
    //       ]);
    //   log(approve.toString());
    // }
    // WalletTransaction()
    //     .sendTransaction(transactiondata: Transaction(data: swapdata));
    // // qoute0x();
  }

  // void check_allowance() async {
  //   // log(_credentials.address.hex);

  //   var httpsUri = Uri(
  //       scheme: 'https',
  //       host: 'api.1inch.io',
  //       path: '/v4.0/$chain_id/approve/allowance',
  //       queryParameters: check_allowance_query_params);
  //   print(httpsUri);
  //   http.Response response = await http.get(httpsUri);
  //   try {
  //     if (response.statusCode == 200) {
  //       log(response.body.toString());
  //       // ethClient.sendTransaction(_credentials, Transaction());
  //     } else {
  //       log(response.body.toString());
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<String> qoute0x(
      {String selltoken = '',
      String buytoken = '',
      required var amount}) async {
    // log(_credentials.address.hex);
    // var sellAmount = amount;
    var sellAmount = amount * math.pow(10, 18);
    sellAmount = sellAmount.toInt().toString();
    Map<String, String> check_allowance_query_params = {
      // 'sellToken': '0xE68104D83e647b7c1C15a91a8D8aAD21a51B3B3E',
      // 'buyToken': '0x0000000000000000000000000000000000000000',
      // 'amount': '100000000000000000',
      // 'slippage': '1',
      // 'disableEstimate': 'false',
      // 'allowPartialFill': 'false'
      // 'takerAddress': user_address,
      'sellToken': selltoken,
      'buyToken': buytoken,
      'sellAmount': sellAmount
    };
    var httpsUri = Uri(
        scheme: 'https',
        host: 'goerli.api.0x.org',
        path: '/swap/v1/quote',
        queryParameters: check_allowance_query_params);
    // print(httpsUri);
    http.Response response = await http.get(httpsUri);
    var data;
    try {
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        var buyAmount = double.parse(data['buyAmount']) / math.pow(10, 18);
        log(buyAmount.toString());
        swapdata = data;
        return buyAmount.toString();

        // log(data.toString());
        // try {
        //   var sig = _credentials.signPersonalMessageToUint8List(
        //       Uint8List.fromList(utf8.encode(data.toString())));
        //   log(sig.toString());
        //   try {
        //     ethClient.sendTransaction(
        //         _credentials,
        //         Transaction(
        //             data: Uint8List.fromList(utf8.encode(data.toString()))));
        //   } catch (e) {
        //     log(e.toString());
        //   }
        // } catch (e) {
        //   log(e.toString());
        // }
        //
        //
        //
        //
        // final transaction = Transaction(
        //   from: EthereumAddress.fromHex(data["from"]),
        //   to: EthereumAddress.fromHex(data['to']),
        //   // maxGas: hexToDartInt(data['gas']),
        //   // gasPrice: EtherAmount.inWei(hexToInt(data['gasPrice'])),
        //   value: EtherAmount.inWei(hexToInt(data['value'])),
        //   data: hexToBytes(data['data']),
        // );
        // // ethClient.sendTransaction(_credentials, transaction);
        // try {
        //   var sig = await _credentials.signPersonalMessageToUint8List(
        //       Uint8List.fromList(utf8.encode(transaction.toString())));
        //   log(sig.toString());
        //   try {
        //     // await ethClient.sendRawTransaction(sig);
        //     await WalletTransaction()
        //         .sendTransaction(transactiondata: transaction);

        //     // await ethClient.sendTransaction(_credentials, transaction);
        //   } catch (e) {
        //     Fluttertoast.showToast(msg: e.toString());
        //   }
        // } catch (e) {
        //   Fluttertoast.showToast(msg: e.toString());
        // }
      } else {
        var data = jsonDecode(response.body);
        return data;
        // log(response.body.toString());
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return 'error';
  }

  // void ask_allowance() async {
  //   // log(_credentials.address.hex);
  //   var httpsUri = Uri(
  //       scheme: 'https',
  //       host: 'api.1inch.io',
  //       path: '/v4.0/$chain_id/approve/transaction',
  //       queryParameters: ask_allowance_query_params);
  //   print(httpsUri);
  //   http.Response response = await http.get(httpsUri);
  //   try {
  //     if (response.statusCode == 200) {
  //       allowance_transaction = response.body;
  //       String xyz =
  //           KeySig().sign_transaction(transaction: allowance_transaction);
  //       // String final_transaction_hash = await ethClient.sendRawTransaction(
  //       // Uint8List.fromList(utf8.encode(allowance_transaction)));
  //       // log(final_transaction_hash);

  //       // log(response.body.toString());
  //       // log(xyz);
  //       final http.Response response2 = await http.post(
  //         Uri.parse(broadcastApiUrl),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode(<String, String>{"rawTransaction": xyz}),
  //       );
  //       log(response2.body.toString());
  //     } else {
  //       log(response.body.toString());
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  @override
  State<WalletSwap> createState() => _SwapState();
}

class _SwapState extends State<WalletSwap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var maxGas = await WalletTransaction().web3client.estimateGas();
                var gasprice =
                    await WalletTransaction().web3client.getGasPrice();
                WalletTransaction().sendTransaction(
                  transactiondata: Transaction(
                      from: Constants.ethereumAddress,
                      to: EthereumAddress.fromHex(
                          "0x35EFceC1182d758A3c7e96DDaDE4064222d7C270"),
                      value: EtherAmount.inWei(
                        BigInt.from(1000000000000000),
                      ),
                      maxGas: maxGas.toInt(),
                      gasPrice: gasprice),
                );
              },
              child: Text("send"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("allow exchange"),
            ),
          ],
        ),
      ),
    );
  }
}
