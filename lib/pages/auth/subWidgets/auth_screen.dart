import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:md_pro/main.dart';
import 'package:md_pro/pages/auth/subWidgets/email_or_password_form.dart';

/// Auth screen mode.
enum Mode {
  /// Shows sign up content and routes.
  signUp,

  /// Shows login content and routes.
  login,
}

//
double heightThreshold = 824;
double elementGap = 24;
double titleGap = 48;

/// Widget for all the main content of the login/sign up screens
///
/// Contains:
///  - Sign up (or login) message
///  - Email and password fields
///  - Submit button
///  - Suggestion to login or sign up
class AuthScreen extends StatelessWidget {
  /// Controls whether this screen renders sign up or login content.
  final Mode mode;

  /// Main auth screen used by both login and sign up routes.
  const AuthScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    bool isSignUpPage = mode == Mode.signUp;
    return Align(
      alignment: Alignment.center,
      child: AuthContentLayout(isSignUpPage: isSignUpPage),
    );
  }
}

class AuthContentLayout extends StatelessWidget {
  final bool isSignUpPage;
  const AuthContentLayout({super.key, required this.isSignUpPage});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, right: 20, bottom: 20, left: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  isSignUpPage ? 'It\'s good to have you' : 'Welcome back',
                  style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.height > heightThreshold
                        ? 40
                        : 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 0.5,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 48, minHeight: 16),
            ),
            Column(
              children: [
                EmailOrPasswordForm(isSignUpPage: isSignUpPage),
                SizedBox(height: 20),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  if (isSignUpPage) {
                    context.go('/auth/login');
                  } else {
                    context.go('/auth/signup');
                  }
                },
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).width > 400
                          ? 20
                          : 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    children: [
                      TextSpan(
                        text: isSignUpPage
                            ? "Already have an account?"
                            : "Don't have an account?",
                      ),
                      TextSpan(
                        text: isSignUpPage ? " Login" : " Create one",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
