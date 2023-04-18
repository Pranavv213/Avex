import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:test_project/home.dart';
import 'package:test_project/onboarding1.dart';

import 'dynamic_link_handler.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  String authCode = '';

//Deeplinking is little buggy. Works under some scenarios.

  getToken() async {
    String code = await encryptedSharedPreferences.getString('code');
    if (code.isNotEmpty) {
      setState(() {});
      return code.toString();
    } else {
      setState(() {});
      return;
    }
    log(code);
    // authCode = code;
  }

  // setToken() async {
  //   code = await encryptedSharedPreferences
  //       .setString("code", "gend")
  //       .then((success) async {
  //     if (success) {
  //       code = await encryptedSharedPreferences.getString('code');
  //     } else {
  //       code = '';
  //     }
  //     return null;
  //   });
  //   log(code.toString());
  // }

  @override
  void initState() {
    // TODO: implement initState
    // setToken();
    // authCode = getToken().toString();
    getToken();
    // code = '';
    DynamicLinkHandler.initDynamicLinks(context, FirebaseDynamicLinks.instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return FutureBuilder(
        future: getToken(),
        builder: (context, snapshot) {
          // setState(() {});
          if (snapshot.hasData) {
            return Home();
          } else {
            return OnBoarding1Screen();
          }
        });
  }
}
// Scaffold(
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(onPressed: getToken, child: Text(code)),
//           ElevatedButton(onPressed: setToken, child: Text("set")),
//         ],
//       )),
//     );