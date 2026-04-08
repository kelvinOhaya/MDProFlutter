import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:md_pro/main.dart';

//Holds Scaffold and AppBar for a consistent background between route transitions
class AuthShell extends StatelessWidget {
  final Widget child;

  const AuthShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        backgroundColor: Colors.black,
        leading: Row(
          children: [
            SizedBox(width: 32),
            IconButton(
              onPressed: () {
                context.go('/');
              },
              icon: FaIcon(FontAwesomeIcons.lessThan),
            ),
          ],
        ),

        title: Padding(
          padding: EdgeInsetsDirectional.only(start: 8),
          child: Text(
            "MD Pro",
            style: TextStyle(color: AppColors.primary, fontSize: 32),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(decoration: BoxDecoration(color: Colors.black)),
          ),
          child,
        ],
      ),
    );
  }
}
