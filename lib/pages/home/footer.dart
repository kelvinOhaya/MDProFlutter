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
  Future<bool> _launchUrl(Uri url) async {
    if (!await canLaunchUrl(url)) {
      return false;
    }

    return launchUrl(
      url,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
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
              onPressed: () async {
                final didLaunch = await _launchUrl(_linkedInPath);
                if (!didLaunch && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open LinkedIn.')),
                  );
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.linkedin,
                color: AppColors.iconContrast,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () async {
                final didLaunch = await _launchUrl(_githubPath);
                if (!didLaunch && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open GitHub.')),
                  );
                }
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
