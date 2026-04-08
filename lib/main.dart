import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:md_pro/pages/auth/auth_shell.dart';
import 'package:md_pro/pages/auth/login.dart';
import 'package:md_pro/pages/auth/sign_up.dart';
import 'package:md_pro/pages/home/home_page.dart';

class AppColors {
  static const Color iconContrast = Colors.white54;
  static const Color primary = Color(0xFFAE00BB);
}

void main() {
  debugPaintSizeEnabled = false;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  final transitionDuration = const Duration(milliseconds: 300);
  final reverseTransitionDuration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(primary: AppColors.primary),
        iconTheme: IconThemeData(color: AppColors.iconContrast),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        brightness: Brightness.dark,
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          ShellRoute(
            builder: (context, state, child) => AuthShell(child: child),
            routes: [
              GoRoute(
                path: '/auth/login',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: Login(),
                    transitionDuration: transitionDuration,
                    reverseTransitionDuration: reverseTransitionDuration,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          Animatable<Offset> inTween = Tween<Offset>(
                            begin: Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutCubic));
                          Animatable<Offset> outTween = Tween<Offset>(
                            begin: Offset.zero,
                            end: Offset(-1.0, 0.0),
                          ).chain(CurveTween(curve: Curves.easeOutCubic));

                          return SlideTransition(
                            position: secondaryAnimation.drive(outTween),
                            child: SlideTransition(
                              position: animation.drive(inTween),
                              child: child,
                            ),
                          );
                        },
                  );
                },
              ),
              GoRoute(
                path: '/auth/signup',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: SignUp(),
                    transitionDuration: transitionDuration,
                    reverseTransitionDuration: reverseTransitionDuration,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          Animatable<Offset> inTween = Tween<Offset>(
                            begin: Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutCubic));
                          Animatable<Offset> outTween = Tween<Offset>(
                            begin: Offset.zero,
                            end: Offset(1.0, 0.0),
                          ).chain(CurveTween(curve: Curves.easeOutCubic));

                          return SlideTransition(
                            position: secondaryAnimation.drive(outTween),
                            child: SlideTransition(
                              position: animation.drive(inTween),
                              child: child,
                            ),
                          );
                        },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
