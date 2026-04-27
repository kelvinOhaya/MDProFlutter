import 'dart:async';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:md_pro/firebase_options.dart';
import 'package:md_pro/pages/auth/auth_shell.dart';
import 'package:md_pro/pages/auth/login.dart';
import 'package:md_pro/pages/auth/sign_up.dart';
import 'package:md_pro/pages/dashboard/dashboard.dart';
import 'package:md_pro/pages/home/home_page.dart';
import 'package:md_pro/services/auth_service.dart';
import 'package:md_pro/viewModel/notes_view_model.dart';
import 'package:md_pro/wrapper.dart';
import 'package:provider/provider.dart';

class AppColors {
  static const Color iconContrast = Colors.white54;
  static const Color primary = Color(0xFFAE00BB);
}

Future<void> main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter framework error: ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final transitionDuration = const Duration(milliseconds: 300);
  final reverseTransitionDuration = const Duration(milliseconds: 300);
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        localizationsDelegates: const [FlutterQuillLocalizations.delegate],
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
          tooltipTheme: TooltipThemeData(
            decoration: BoxDecoration(color: Colors.black),
            textStyle: TextStyle(color: AppColors.iconContrast),
            preferBelow: false,
            verticalOffset: 16,
            margin: EdgeInsets.only(right: 32),
          ),
          brightness: Brightness.dark,
        ),
        routerConfig: GoRouter(
          initialLocation: '/',
          refreshListenable: AuthNotifier(),
          redirect: (context, state) {
            final bool loggedIn = FirebaseAuth.instance.currentUser != null;
            final bool isOnDashboard = state.matchedLocation == '/dashboard';
            final bool isOnAuth = state.matchedLocation.startsWith('/auth/');

            if (!loggedIn) {
              if (isOnDashboard) return '/home';
              return null;
            }

            if (isOnAuth) return '/dashboard';
            return null;
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => Wrapper()),
            GoRoute(path: '/home', builder: (context, state) => HomePage()),
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
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => NotesViewModel()),
                ],
                child: Dashboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: avoid_print
