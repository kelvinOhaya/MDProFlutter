import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:md_pro/main.dart';
import 'package:md_pro/pages/auth/subWidgets/auto_sign_in.dart';
import 'package:md_pro/pages/auth/subWidgets/email_or_password_form.dart';
import 'package:md_pro/pages/auth/subWidgets/or_divider.dart';

enum Mode { signUp, login }

// Widget for all the main content of the login/sign up screens
// Contains:
//  - Header msg
//  - Continue with icons
//  - Email and password fields
//  - Submit button
//  - Suggestion to login or sign up

double smallConstraint = 824;

class AuthScreen extends StatelessWidget {
  final Mode mode;
  const AuthScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    bool isSignUpPage = mode == Mode.signUp;
    return Align(
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxHeight >= 824;
          if (isLargeScreen) {
            return DefaultLayout(isSignUpPage: isSignUpPage);
          } else {
            return SmallLayout(isSignUpPage: isSignUpPage);
          }
        },
      ),
    );
  }
}

class DefaultLayout extends StatelessWidget {
  final bool isSignUpPage;
  const DefaultLayout({super.key, required this.isSignUpPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width > 400 ? 400 : double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (MediaQuery.sizeOf(context).height > 824)
              Expanded(
                child: Center(
                  child: Text(
                    isSignUpPage ? 'It\'s good to have you' : 'Welcome back',
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > smallConstraint
                          ? 40
                          : 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            SizedBox(height: 24),
            AutoSignIn(isLargeScreen: true),
            SizedBox(height: 24),
            OrDivider(isLargeScreen: true),
            SizedBox(height: 24),
            EmailOrPasswordForm(isSignUpPage: isSignUpPage),
            SizedBox(height: 24),
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    children: [
                      TextSpan(
                        text: isSignUpPage
                            ? "Already have an account?"
                            : "Don't have an account?",
                      ),
                      TextSpan(
                        text: isSignUpPage ? " Login" : "  Create one",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class SmallLayout extends StatelessWidget {
  final bool isSignUpPage;

  const SmallLayout({super.key, required this.isSignUpPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width > smallConstraint
            ? smallConstraint
            : double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                isSignUpPage ? 'It\'s good to have you' : 'Welcome back',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height > smallConstraint
                      ? 40
                      : MediaQuery.of(context).size.height > 650
                      ? 32
                      : 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 48),
            EmailOrPasswordForm(isSignUpPage: isSignUpPage),
            SizedBox(height: 24),
            OrDivider(isLargeScreen: false),
            SizedBox(height: 24),
            AutoSignIn(isLargeScreen: false),
            SizedBox(height: 20),
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
                child: Center(
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
                          text: isSignUpPage ? " Login" : "  Create one",
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
            ),
          ],
        ),
      ),
    );
  }
}
