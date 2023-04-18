import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'constants.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

GlobalKey<FormState> valueKey = GlobalKey<FormState>();
final _valueController = TextEditingController();
String selectedValue1 = "ETH";
String selectedValue2 = "DAI";
String requestUrl = '';
void generateLink({String token = '', var amount, String address = ''}) {
  String tokenAddress = Constants.tokenAddressList[token].toString().trim();
  requestUrl =
      'https://avexmobile.page.link/?link=https://avexmobile.page.link/request/?token=${tokenAddress}@amount=${amount + "e18"}@sendAddress=$address&apn=com.example.test_project';
  log(requestUrl);
}

generateQR() {
  return QrImage(
    data: requestUrl,
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
  );
}

class _RequestScreenState extends State<RequestScreen> {
  double price = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(55.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                            onChanged: (value) async {
                              // if (_valueController.text.isNotEmpty) {
                              //   var fetchPrice = await Constants()
                              //       .getPrice(token: selectedValue1);
                              //   price = fetchPrice * double.parse(value);
                              //   price = double.parse(price.toStringAsFixed(2));

                              //   setState(() {
                              //     this.price = price;
                              //   });
                              //   log(price.toString());
                              // } else {
                              //   setState(() {
                              //     this.price = 0;
                              //   });
                              // }
                            },
                            keyboardType: TextInputType.number,
                            controller: _valueController,
                            decoration: const InputDecoration(
                                label: Text(
                              "value",
                            )),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    generateLink(
                        token: selectedValue1,
                        amount: _valueController.text,
                        address: Constants.address);
                    bottomSheet(context);
                  },
                  child: Text("Request")),
              // Text(price.toString())
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        generateQR(),
                        Text(
                          requestUrl,
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ));
        },
        context: context);
  }
}
