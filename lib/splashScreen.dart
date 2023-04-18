import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:test_project/authWrapper.dart';
import 'package:test_project/lend_borrow_screen.dart';
import 'package:test_project/test.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.black,
      splash: Image.asset('assets/logo.png'),
      nextScreen: AuthWrapper(),
      // To maintain session throughout the app. Deeplinking is used.
      splashTransition: SplashTransition.fadeTransition,
      curve: Curves.easeInExpo,
      animationDuration: Duration(seconds: 1, milliseconds: 500),
    );
  }
}
