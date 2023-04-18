import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/router.gr.dart';
import '../widget/button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C83A0),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    size: 62,
                    Icons.mail,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Confirm you’re email",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500, fontSize: 40),
              ),
              Text(
                "Check your email on this device to verify your account",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Expanded(child: Container()),
              Text(
                "You can resend in 28 seconds",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400, fontSize: 16),
              ),
              Text(
                "Sent to xyz@gmail.com",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFFDEDEDE)),
              ),
              SizedBox(
                height: 12,
              ),
              CustomButton(
                onClick: () => {
                  AutoRouter.of(context).push(SeedRecoveryRoute())
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
