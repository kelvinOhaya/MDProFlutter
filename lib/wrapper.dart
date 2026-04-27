import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:md_pro/pages/auth/auth_shell.dart';
import 'package:md_pro/pages/auth/login.dart';
import 'package:md_pro/pages/dashboard/dashboard.dart';
import 'package:md_pro/pages/home/home_page.dart';
import 'package:md_pro/viewModel/notes_view_model.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Wrapper authStateChanges error: ${snapshot.error}');
          return AuthShell(child: Login());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (_) => NotesViewModel(),
            child: Dashboard(),
          );
        }

        return HomePage();
      },
    );
  }
}
