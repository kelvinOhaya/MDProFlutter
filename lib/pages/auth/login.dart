import 'package:flutter/material.dart';
import 'package:md_pro/pages/auth/subWidgets/auth_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return AuthScreen(mode: Mode.login);
  }
}
