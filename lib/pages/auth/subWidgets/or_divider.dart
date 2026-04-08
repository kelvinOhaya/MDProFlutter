import 'package:flutter/material.dart';
import 'package:md_pro/main.dart';

class OrDivider extends StatelessWidget {
  final bool isLargeScreen;
  const OrDivider({super.key, required this.isLargeScreen});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: Text(
              isLargeScreen ? "or" : "or continue with",
              style: TextStyle(fontSize: 16, color: AppColors.iconContrast),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}
