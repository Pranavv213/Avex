import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  State<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final platform = MethodChannel('polyess.wallet/eth');
  // final storage = FlutterSecureStorage();
  String? walletAddr;
  getAddress(String seed) async {
    walletAddr = await platform
        .invokeMethod("getWallet", <String, String>{'seed': seed});
    // secureSave(seed, walletAddr);
    return walletAddr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Import Using Private Key")]),
      ),
    );
  }
}
