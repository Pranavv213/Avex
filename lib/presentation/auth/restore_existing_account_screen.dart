import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../widget/button.dart';

class RestoreExistingAccountScreen extends ConsumerWidget {
  const RestoreExistingAccountScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text(
                    "Restore existing wallet",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 24),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                    "To import an existing wallet,enter your seedphase below"),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    "Enter your seed phrase here",
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                autofocus: false,
                style: TextStyle(fontSize: 17.0, color: Color(0xFFbdc6cf)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF25252D),
                  hintText: 'Email',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Expanded(child: Container()),
              const SizedBox(
                height: 12,
              ),
              CustomButton(
                onClick: () => {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        //the rounded corner is created here
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 4,
                                width: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 52,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Share this social key image with trusted contacts",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Container(
                                  width: 200,
                                  color: Colors.white,
                                  child:
                                      QrImage(data: "https://www.google.com")),
                              const SizedBox(
                                height: 24,
                              ),
                              Text("https://www.google.com"),
                              const SizedBox(
                                height: 24,
                              ),
                              CustomButton(title: "Share", onClick: () => {})
                            ],
                          ),
                        );
                      })
                },
                title: "Open My Email",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
