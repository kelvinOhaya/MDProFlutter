import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    try {
      // iOS Safari/PWA can be picky about target windows.
      if (kIsWeb) {
        final openedInNewTab = await launchUrl(
          url,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );
        if (openedInNewTab) return true;

        // Fallback for environments that block opening a new tab/window.
        return launchUrl(
          url,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_self',
        );
      }

      return launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
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
      ),
    );
  }
}
