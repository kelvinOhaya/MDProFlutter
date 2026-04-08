import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContinueWithButton extends StatelessWidget {
  final SvgPicture? svgPicture;
  final Icon? icon;
  final String? message;
  const ContinueWithButton({
    super.key,
    this.icon,
    this.svgPicture,
    this.message,
  });
  @override
  Widget build(BuildContext context) {
    return message != null
        ? SizedBox(
            width: 300,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => {},
              extendedPadding: EdgeInsets.all(0),
              elevation: 0,
              backgroundColor: const Color(0x11ffffff),
              icon: null,
              label: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(child: icon ?? svgPicture),
                    Text(
                      message!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: Container(child: icon ?? svgPicture),
                    ),
                  ],
                ),
              ),
            ),
          )
        : FloatingActionButton(
            heroTag: null,
            onPressed: () => {},
            shape: CircleBorder(),
            elevation: 0,
            backgroundColor: const Color(0x11ffffff),
            child: SizedBox(child: icon ?? svgPicture),
          );
  }
}

class AutoSignIn extends StatelessWidget {
  final googleLogoPath = 'assets/googleLogo.svg';
  final microsoftLogoPath = 'assets/microsoftLogo.svg';
  final bool isLargeScreen;
  const AutoSignIn({super.key, required this.isLargeScreen});
  @override
  Widget build(BuildContext context) {
    return isLargeScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              ContinueWithButton(
                icon: Icon(Icons.apple, color: Colors.white, size: 32),
                message: "Continue with apple",
              ),
              ContinueWithButton(
                svgPicture: SvgPicture.asset(googleLogoPath),
                message: "Continue with Google",
              ),
              ContinueWithButton(
                svgPicture: SvgPicture.asset(microsoftLogoPath),
                message: "Continue with Microsoft",
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              ContinueWithButton(
                icon: Icon(Icons.apple, color: Colors.white, size: 48),
              ),
              ContinueWithButton(svgPicture: SvgPicture.asset(googleLogoPath)),
              ContinueWithButton(
                svgPicture: SvgPicture.asset(microsoftLogoPath),
              ),
            ],
          );
  }
}
