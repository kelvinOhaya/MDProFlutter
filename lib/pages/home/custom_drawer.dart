import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:md_pro/main.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(10),
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withAlpha(5),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MD Pro",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: AppColors.primary, fontSize: 32),
                  ),
                  IconButton(
                    onPressed: () => {Navigator.pop(context)},
                    icon: FaIcon(FontAwesomeIcons.x),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 32)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        AppColors.primary,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      context.push('/auth/signup');
                    },
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll<BorderSide>(
                        BorderSide(width: 2, color: AppColors.primary),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
