import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  // Register
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _subscription;
  AuthNotifier() {
    _subscription = FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Auth stream error: $error');
        debugPrintStack(stackTrace: stackTrace);
        notifyListeners();
      },
    );
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
