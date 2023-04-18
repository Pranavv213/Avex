import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:test_project/swap.dart';

List<DropdownMenuItem<String>> tokens = [
  DropdownMenuItem(child: Text("Ethereum Mainnet"), value: "ETH"),
  DropdownMenuItem(child: Text("Goerli Testnet"), value: "GOERLI"),
  // DropdownMenuItem(child: Text("UDSC"), value: "USDC"),
  // DropdownMenuItem(child: Text("LINK"), value: "LINK"),
  // DropdownMenuItem(child: Text("USDT"), value: "USDT"),
  // DropdownMenuItem(child: Text("UNI"), value: "UNI"),
  // DropdownMenuItem(child: Text("Wrapped BTC"), value: "WBTC"),
  // DropdownMenuItem(child: Text("FRAX"), value: "FRAX"),
  // DropdownMenuItem(child: Text("USD Mapped Token"), value: "USDM"),
  // DropdownMenuItem(child: Text("WETH"), value: "WETH"),
  // DropdownMenuItem(child: Text("BUSD"), value: "BUSD"),
];
String? selectedValue;

class Receive {
  static show(BuildContext context) {
    showModalBottomSheet(
        // backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Recieve"),
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                        items: tokens,
                        onChanged: (String? value) {
                          // setState(() {
                          //   selectedValue2 = value;
                          // });
                          log(value.toString());
                        }))
              ],
            ),
          );
        });
  }
}
