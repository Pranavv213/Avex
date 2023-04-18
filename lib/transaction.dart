import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'dart:convert';

class WalletTransaction {
  static String rpc_url =
      "https://goerli.infura.io/v3/a1a50b6285a944d98e643e6efe0bc6bf";
  static http.Client httpClient = http.Client();
  Web3Client web3client = Web3Client(rpc_url, httpClient);
  sendTransaction({required Transaction transactiondata}) async {
    try {
      var chainID = await web3client.getChainId();

      log(chainID.toString());
      String transactionHash = await web3client.sendTransaction(
          chainId: chainID.toInt(), Constants.userCredentials, transactiondata);
      Fluttertoast.showToast(msg: "Sent Succesfully");
      log(transactionHash);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString().substring(
              e.toString().indexOf('"') + 1, e.toString().lastIndexOf('"')));
    }
  }
}
