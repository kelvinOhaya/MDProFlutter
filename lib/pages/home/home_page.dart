import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:md_pro/main.dart';
import 'package:md_pro/pages/home/animated_title.dart';
import 'package:go_router/go_router.dart';
import 'custom_drawer.dart';
import 'footer.dart';

class HomePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(size: 48.0, color: Colors.white70),
        titleSpacing: 24,
        title: Text(
          "MD Pro",
          style: TextStyle(color: AppColors.primary, fontSize: 32),
        ),
        backgroundColor: Colors.transparent,
      ),
      endDrawer: Drawer(
        width: MediaQuery.sizeOf(context).width <= 450
            ? MediaQuery.sizeOf(context).width
            : 400,
        backgroundColor: Colors.transparent,
        child: CustomDrawer(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [Color(0xFF1F1F1F), Color(0xFF2A2A2A), Color(0xff1c1c1c)],
            stops: [0, 0.6, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (caontext, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      AnimatedTitle(),
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: GetStartedButton(maxWidth: constraints.maxWidth),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Divider(
                            thickness: 1,
                            color: AppColors.iconContrast,
                          ),
                        ),
                      ),
                      Footer(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GetStartedButton extends StatelessWidget {
  final double maxWidth;
  const GetStartedButton({super.key, required this.maxWidth});
  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.sizeOf(context).width < 300
        ? MediaQuery.sizeOf(context).width - 32
        : 300;
    return SizedBox(
      width: buttonWidth,
      child: FloatingActionButton.extended(
        heroTag: null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(180)),
        backgroundColor: AppColors.primary,
        hoverColor: const Color.fromARGB(255, 214, 0, 229),
        elevation: 10,
        onPressed: () {
          context.go('/auth/login');
        },
        label: const Text(
          "Get started",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
