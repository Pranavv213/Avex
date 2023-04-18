import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:test_project/home.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:test_project/lend_borrow_screen.dart';
import 'package:test_project/onboarding1.dart';
import 'package:test_project/presentation/main/home/home_screen.dart';
// import 'package:test_project/presentation/main/request/request_screen.dart';
// import 'package:test_project/presentation/main/send/send_fund_screen.dart';
import 'package:test_project/send.dart';
import 'package:test_project/swap.dart';
import 'package:test_project/test.dart';
import 'package:test_project/wallet_connect/wallet_connect_screen.dart';
import 'authWrapper.dart';
import 'core/router.gr.dart';
import 'dynamic_link_handler.dart';
import 'presentation/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   darkTheme: ThemeData.dark(),
    //   home: HomeScreen(),
    // );
    return MaterialApp.router(
      darkTheme: ThemeData(
          brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black),

      // home: SplashScreen(),
      routerDelegate: _router.delegate(),
      routeInformationParser: _router.defaultRouteParser(),
      themeMode: ThemeMode.dark,
    );
  }
}
