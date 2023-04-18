import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/transaction.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ens_dart/ens_dart.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class SendScreen extends StatefulWidget {
  String token = '', amount = '', sendAddress = '';
  bool? isRecieve;
  //Send screen can open in 2 scenarios, normally or via a payment request link.
  //Whlie opening links payment parameters need to be captured from the link and displayed
  SendScreen(
      {String token = '',
      String amount = '',
      String sendAddress = '',
      bool isRecieve = false}) {
    this.token = token;
    this.amount = amount;
    this.sendAddress = sendAddress;
    this.isRecieve = isRecieve;
  }

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  setValues() {
    setState(() {
      widget.token = Constants.tokenAddressList.keys.firstWhere(
          (k) => Constants.tokenAddressList[k] == widget.token,
          orElse: () => '');
      selectedValue1 = widget.token;
      widget.amount = widget.amount.substring(0, widget.amount.indexOf('e'));
      _valueController.text = widget.amount;
      addressController.value = widget.sendAddress.isNotEmpty
          ? TextEditingValue(text: widget.sendAddress)
          : TextEditingValue(text: Constants.dummyAddress);
    });
  }

  GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  GlobalKey<FormState> valueKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final _valueController = TextEditingController();
  static var httpClient = http.Client();
  static String rpc_url = "https://eth.llamarpc.com";
  static var ethClient = Web3Client(rpc_url, httpClient);
  final ensClient = Ens(client: ethClient);
  static var addr = '';
  late int value;
  String selectedValue1 = "ETH";
  String selectedAddress = "0x8Cf6b290F1b478bC0FEeF9E05DA498a0167babaE";
  @override
  void initState() {
    bool? x = widget.isRecieve;
    x! ? setValues() : null;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(Constants.dummyAddress + Constants.seedPhrase),

          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("From:"),
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                        items: Constants.accountsList,
                        value: selectedAddress,
                        onChanged: (String? value) {
                          setState(() {
                            selectedAddress = value.toString();
                          });
                          log(value.toString());
                        })),
              ],
            ),
          ),
          Form(
            key: addressKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                  onChanged: (value) async {
                    var trimmed = value.trim();
                    if (trimmed.isNotEmpty && !trimmed.contains(" ")) {
                      if (addressController.text.endsWith(".eth")) {
                        try {
                          var ens = await fetchENS(addressController.text);
                          addr = ens;
                        } catch (e) {}
                      } else if (addressController.text.startsWith("0x") &&
                          addressController.text.length == 42) {
                        addr = addressController.text;
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please enter a valid ENS or Address");
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please enter a valid ENS or Address");
                    }
                  },
                  // cursorColor: Color(0xFF064848),
                  controller: addressController,
                  decoration: InputDecoration(
                      label: Text(
                    "Address or ENS",
                  )),
                  autovalidateMode: AutovalidateMode.onUserInteraction),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        items: Constants.tokens,
                        value: selectedValue1,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue1 = value.toString();
                          });
                          log(value.toString());
                        })),
              ),
              Expanded(
                child: Form(
                  key: valueKey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextFormField(
                        // onChanged: ,
                        keyboardType: TextInputType.number,
                        controller: _valueController,
                        decoration: const InputDecoration(
                            label: Text(
                          "Value",
                        )),
                        autovalidateMode: AutovalidateMode.onUserInteraction),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                var maxGas = await WalletTransaction().web3client.estimateGas();
                var gasprice =
                    await WalletTransaction().web3client.getGasPrice();
                if (addressController.text.isNotEmpty &&
                    _valueController.text.isNotEmpty) {
                  double sendValue = double.parse(_valueController.text);
                  sendValue = sendValue * math.pow(10, 18);
                  WalletTransaction().sendTransaction(
                      transactiondata: Transaction(
                          from: Constants.ethereumAddress,
                          to: EthereumAddress.fromHex(addr),
                          value: EtherAmount.fromBigInt(
                              EtherUnit.wei,
                              BigInt.from(
                                  double.parse(sendValue.toInt().toString()))),
                          maxGas: maxGas.toInt(),
                          gasPrice: gasprice));
                } else {
                  Fluttertoast.showToast(
                      msg: "Please enter a valid ENS or Address or Value");
                }
                // Constants().createAccount(Constants.seedPhrase, false);
                // log(Constants.accountsList.toString());
              },
              child: Text("Send"))
        ],
      )),
    );
  }

  fetchENS(var add) async {
    var ens;
    try {
      add = await ensClient.withName(add).getAddress();
      if (add.hex.toString().contains("Service Unavailable") ||
          add.hex
              .toString()
              .contains("0x0000000000000000000000000000000000000000") ||
          add.hex.toString().contains("Connection")) {
        Fluttertoast.showToast(msg: "Couldnt find ENS, Please try again");
      } else {
        Fluttertoast.showToast(msg: "Found a valid ENS");
        ens = add.toString();
      }
      // log(add.toString());
    } catch (e) {
      // log(e.toString());
    }
    return ens;
  }
}
