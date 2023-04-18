// import 'dart:math';

import 'dart:developer';

import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/confirmEmail.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/home.dart';
import 'package:test_project/import.dart';
import 'package:test_project/onboarding2.dart';
import 'package:test_project/screenArgs.dart';
import 'package:test_project/swap.dart';
import 'package:test_project/wallet_creation.dart';
import 'package:web3dart/credentials.dart';

import 'dynamic_link_handler.dart';
import 'package:bip39/bip39.dart' as bip39;

class OnBoarding1Screen extends StatefulWidget {
  String args = '';
  OnBoarding1Screen({super.key, String authcode = ''}) {
    args = authcode;
  }

  @override
  State<OnBoarding1Screen> createState() => _OnBoarding1ScreenState();
}

class _OnBoarding1ScreenState extends State<OnBoarding1Screen> {
  WalletAddress walletAddress = WalletAddress();
  String? pubaddr;
  String? privaddr;
  bool creatingWallet = false;

  void toggleCreateState() {
    setState(() {
      creatingWallet = !creatingWallet;
    });
  }

  goToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    // final args =
    // ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    return Scaffold(
      body: Center(
        child: creatingWallet
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Creating Wallet", style: Constants.h3poppinsStyle),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Welcome to Avex", style: Constants.h1poppinsStyle),
                    Text(
                        textAlign: TextAlign.left,
                        "Best Ecosystem around",
                        style: Constants.h3poppinsStyle),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            creatingWallet = !creatingWallet;
                          });
                          try {
                            
                            if (true) {
                              //Creates a new Crypto Wallet
                              Constants().createWallet();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    title: Text(
                                      "Wallet Created Succesfully",
                                      style: Constants.h4poppinsStyle,
                                    ),
                                    // content: Text("$pubaddr"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            goToHome();
                                          },
                                          child: Text("Continue"))
                                    ],
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                creatingWallet = !creatingWallet;
                              });
                              log("Couldn't Authenticate. Please Try again.");
                            }
                          } catch (E) {
                            log(E.toString());
                          }
                        },
                        child: Text(
                          "Create a new Wallet",
                          style: Constants.h5poppinsStyle,
                        )),
                    ElevatedButton(
                        style: Constants.roundCornerBlue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImportWalletScreen(),
                              ));
                        },
                        child: Text(
                          "Import Existing wallet",
                          style: Constants.h3poppinsStyle,
                        )),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
