import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("gmail khol lvde"),
            ElevatedButton(
                onPressed: () async {
                  await LaunchApp.openApp(
                      androidPackageName: 'com.google.android.gm',
                      openStore: false);
                },
                child: Text("open mail"))
          ],
        ),
      ),
    );
  }
}
