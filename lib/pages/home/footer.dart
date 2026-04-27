import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:md_pro/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  Footer({super.key});
  final Uri _linkedInPath = Uri.parse(
    "https://www.linkedin.com/in/kelvin-ohaya/",
  );
  final Uri _githubPath = Uri.parse(
    "https://github.com/kelvinOhaya/MDProFlutter",
  );
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

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
              onPressed: () {
                _launchUrl(_linkedInPath);
              },
              icon: FaIcon(
                FontAwesomeIcons.linkedin,
                color: AppColors.iconContrast,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                _launchUrl(_githubPath);
              },
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
