import 'package:flutter/material.dart';
import 'package:md_pro/pages/auth/subWidgets/auth_screen.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return AuthScreen(mode: Mode.signUp);
  }
}
