import 'package:flutter/material.dart';
import 'package:ntcdcrypto/ntcdcrypto.dart';
import 'dart:developer';
import 'package:bip39/bip39.dart' as bip39;
import 'package:test_project/constants.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

SSS sss = new SSS();
String data1 = '', data2 = '', data3 = '';
Map<String, int> data = {"data1": 0, "data2": 1, "data3": 2};
void generateShares() {
  String s = Constants.seedPhrase;
  log("secret: ${s}");
  log("secret.length: ${s.length}");
  // creates a set of shares using seed phrase.

  List<String> arr = sss.create(2, 3, s, false);
  // Different number of shares can be created and combined to recover the seed phrase
  //In this case 2 out of 3 shares are required to recover the secret
  //Here FIrst and Second share is being combined to recover the seed phrase
  log(arr.toString());
  switch (numberOfTasks) {
    case 2:
      {
        var s1;
        List<String> l1 = [arr[0], arr[arr.length - 1]];
        data.removeWhere((key, value) => value == "");
        if (data["data1"] != "" && data["data2"] != "") {
          s1 = sss.combine(arr.sublist(0, 2), false);
          //This seed can now be used to import the wallet/account
          bip39.validateMnemonic(s1) ? log("valid") : log("invalid");
        } else if (data["data1"] != "" && data["data3"] != "") {
          arr.removeRange(1, 2);
          s1 = sss.combine(arr, false);
          //This seed can now be used to import the wallet/account
          bip39.validateMnemonic(s1) ? log("valid") : log("invalid");
        } else if (data["data2"] != "" && data["data3"] != "") {
          s1 = sss.combine(arr.sublist(1, 3), false);
          //This seed can now be used to import the wallet/account
          bip39.validateMnemonic(s1) ? log("valid") : log("invalid");
        }
        log("secret: ${s1}");
        log(s.toString());
        Constants().createAccount(s1, true);
        // log("secret.length:}");

        break;
      }
    case 3:
      {
        var s1;
        s1 = sss.combine(arr.sublist(0, arr.length - 1), false);
        //This seed can now be used to import the wallet/account
        bip39.validateMnemonic(s1) ? log("valid") : log("invalid");
        Constants().createAccount(s1, true);
        log("3 tasks done");
        break;
      }
    default:
      {
        log("Already Recovered");
      }
  }
}

int numberOfTasks = 0;
taskDone() {
  numberOfTasks++;
  log(numberOfTasks.toString());
  if (numberOfTasks >= 2) {
    log("can recover");
    generateShares();
  }
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
//Simulation of Different tasks being done

            ElevatedButton(
                onPressed: () {
                  data["data1"] = 0;
                  taskDone();
                  log(data.toString());
                },
                child: Text("Task 1")),
            ElevatedButton(
                onPressed: () {
                  data["data2"] = 1;
                  taskDone();
                  log(data.toString());
                },
                child: Text("Task 2")),
            ElevatedButton(
                onPressed: () {
                  data["data3"] = 2;
                  taskDone();
                  log(data.toString());
                },
                child: Text("Task 3")),
            ElevatedButton(
                onPressed: () {
                  numberOfTasks = 0;
                  data.clear();
                  log(numberOfTasks.toString());
                  log(data.toString());
                  // Constants().getPrice(token: "polygon");
                },
                child: Text("Reset")),
            ElevatedButton(onPressed: () {}, child: Text("Recover")),
          ],
        ),
      ),
    );
  }
}
