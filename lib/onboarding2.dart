import 'dart:developer';

import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter/material.dart';
import 'package:ntcdcrypto/ntcdcrypto.dart';
import 'package:test_project/home.dart';
import 'package:test_project/wallet_creation.dart';
import 'package:web3dart/credentials.dart';
import 'package:bip39/bip39.dart' as bip39;

class OnBoarding2Screen extends StatefulWidget {
  const OnBoarding2Screen({super.key});

  @override
  State<OnBoarding2Screen> createState() => _OnBoarding2ScreenState();
}

class _OnBoarding2ScreenState extends State<OnBoarding2Screen> {
  SSS sss = SSS();

  WalletAddress walletAddress = WalletAddress();
  String? pubaddr;
  String? privaddr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(90.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Your good name?",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => Home())));

                    // String s =
                    //     "omit office bundle actual puppy nothing busy obtain alien suffer pave they";
                    // log("secret: ${s}");
                    // log("secret.length: ${s.length}");
                    // // creates a set of shares
                    // List<String> arr = sss.create(3, 6, s, false);
                    // //log(arr);

                    // // combines shares into secret
                    // var s1 = sss.combine(arr.sublist(0, 5), false);
                    // // log("combines shares 1 length = ${arr.sublist(0, 3).length}");
                    // log("secret: ${s1}");
                    // log("secret.length: ${s1.length}");

                    // var s2 = sss.combine(arr.sublist(3, arr.length), false);
                    // log("combines shares 2 length = ${arr.sublist(3, arr.length).length}");
                    // log("secret: ${s2}");
                    // log("secret.length: ${s2.length}");

                    // var s3 = sss.combine(arr.sublist(1, 5), false);
                    // log("combines shares 3 length = ${arr.sublist(1, 5).length}");
                    // log("secret: ${s3}");
                    // log("secret.length: ${s3.length}");
                    // log(arr.toString());

                    String seed = bip39.mnemonicToSeedHex(
                        "omit office bundle actual puppy nothing busy obtain alien suffer pave they");
                    Chain chain = Chain.seed(seed); //web3dart
                    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/0");
                    Credentials credentials =
                        EthPrivateKey.fromHex(key.privateKeyHex()); //web3dart
                    var address = await credentials.address;
                    log(address.hex); //web3dart
                  },
                  child: Text("Continue"))
            ],
          ),
        ),
      ),
    );
  }
}
