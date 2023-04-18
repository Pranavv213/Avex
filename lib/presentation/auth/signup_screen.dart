import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_project/core/router.gr.dart';

import '../../core/auth_state.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends AuthState<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Let's get Started!",
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w600, fontSize: 26),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "An amazing web3 journey awaits",
                          style: GoogleFonts.inter(color:const Color(0xFF626164)),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.15),
                    SvgPicture.asset("assets/logo.svg",
                        semanticsLabel: 'Acme Logo'),
                    SizedBox(height: screenHeight * 0.125),
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: GoogleFonts.inter(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      autofocus: false,
                      style:
                          TextStyle(fontSize: 17.0, color: Color(0xFFbdc6cf)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF25252D),
                        hintText: 'Email',
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.15 * 0.25),
                    const Text("Or continue with"),
                    SizedBox(height: screenHeight * 0.15 * 0.25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF25252D)),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset("assets/google_logo.svg"),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=>{
                            AutoRouter.of(context).push(OnboardingRoute())
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Color(0xFF25252D)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SvgPicture.asset("assets/twitter_logo.svg"),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFF25252D)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SvgPicture.asset("assets/fb_logo.svg"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onAuthFailure() {
    // TODO: implement onAuthFailure
  }

  @override
  void onAuthSuccess() {
    // TODO: implement onAuthSuccess
  }
}
