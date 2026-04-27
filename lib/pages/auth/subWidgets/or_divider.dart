import 'package:flutter/material.dart';
import 'package:md_pro/main.dart';

class DividerWithText extends StatelessWidget {
  final String message;
  const DividerWithText({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              style: TextStyle(fontSize: 16, color: AppColors.iconContrast),
            ),
          ),
          Expanded(child: Divider()),
        ],
      ),
    );
  }
}
