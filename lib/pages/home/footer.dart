import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:md_pro/main.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Developed by Kelvin Ohaya",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.iconContrast, fontSize: 20),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => {},
              icon: FaIcon(
                FontAwesomeIcons.linkedin,
                color: AppColors.iconContrast,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () => {},
              icon: FaIcon(
                FontAwesomeIcons.code,
                color: AppColors.iconContrast,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
