import 'dart:async';
import 'dart:developer';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:test_project/constants.dart';
import 'package:test_project/lend_borrow_screen.dart';
import 'package:test_project/recovery.dart';
import 'package:test_project/request.dart';
import 'package:test_project/send.dart';
import 'package:test_project/swap.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<DropdownMenuItem<String>> networks = [
    DropdownMenuItem(child: Text("Ethereum Mainnet"), value: "ETH"),
    DropdownMenuItem(child: Text("Goerli Testnet"), value: "GOERLI"),
  ];
  String selectedValue2 = "ETH";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SendScreen()));
                },
                child: Text(
                  "Send",
                  style: Constants.h5poppinsStyle,
                )),
            ElevatedButton(
                onPressed: () {
                  _bottomSheet(context);
                },
                child: Text(
                  "Recieve",
                  style: Constants.h5poppinsStyle,
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SwapScreen()));
                },
                child: Text(
                  "Swap",
                  style: Constants.h5poppinsStyle,
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LendBorrowScreen()));
                },
                child: Text(
                  "Lend/Borrow",
                  style: Constants.h5poppinsStyle,
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecoveryScreen()));
                },
                child: Text(
                  "Recover",
                  style: Constants.h5poppinsStyle,
                )),
            // ElevatedButton(
            //     onPressed: () {
            //       setState(() {
            //         encryptedSharedPreferences.clear();
            //         encryptedSharedPreferences.reload();
            //       });
            //     },
            //     child: Text("LogOut")),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) => Container(
              // height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Recieve"),
                  DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: selectedValue2,
                          items: networks,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue2 = value.toString();
                            });
                            log(value.toString());
                          })),
                  QrImage(
                    data: Constants.address,
                    size: 150,
                    backgroundColor: Colors.white,
                    // foregroundColor: Colors.pinkAccent,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Constants.address),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                                  ClipboardData(text: Constants.address))
                              .then((_) {
                            Fluttertoast.showToast(msg: "Copied to Clipboard");
                          });
                        },
                        icon: Icon(Icons.copy),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.request_quote),
                            Text("Request payment")
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Icon(Icons.share), Text("Share Address")],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        context: context);
  }
}
