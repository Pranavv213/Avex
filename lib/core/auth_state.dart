import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  bool _redirectCalled = false;

  //For One-time get authSessions
  Future<void> redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }
    _redirectCalled = true;
    if (false) {
      onAuthFailure();
    } else
      onAuthSuccess();
  }

  //For Stream Subscription of Auth Sessions
  initAuthSubscription() {
    // _authStateSubscription = SupabaseClient.getAuthSession().listen((event) {
    //   if (_redirectCalled) return;
    //   final session = event!.session;
    //   if (session != null && !_redirectCalled) {
    //     _redirectCalled = true;
    //     onAuthSuccess();
    //   } else {
    //     onAuthFailure();
    //   }
    // });
  }

  disposeAuthSubscription() {
    // _authStateSubscription.cancel();
  }

  void onAuthSuccess();
  void onAuthFailure();
}
