import 'package:flutter/material.dart';

class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});
  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController delayedController;
  late Animation<double> opacityAnimation;
  late Animation<double> offsetAnimation;
  late Animation<double> delayedOpacityAnimation;
  late Animation<double> delayedOffsetAnimation;

  Future<void> forwardDelayedAnimation({
    required AnimationController controller,
    required Duration delay,
  }) async {
    await Future.delayed(delay, () {
      if (mounted) {
        controller.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    delayedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    opacityAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {});
        });
    offsetAnimation = Tween<double>(
      begin: -16,
      end: 0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    delayedOpacityAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(
          CurvedAnimation(parent: delayedController, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {});
        });
    delayedOffsetAnimation = Tween<double>(begin: -16, end: 0).animate(
      CurvedAnimation(parent: delayedController, curve: Curves.easeOut),
    );
    controller.forward();
    forwardDelayedAnimation(
      controller: delayedController,
      delay: Duration(milliseconds: 50),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    delayedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.translate(
          offset: Offset(0, offsetAnimation.value),
          child: FadeTransition(
            opacity: opacityAnimation,
            child: Text(
              "Notes have never been easier",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).width > 450 ? 56 : 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, delayedOffsetAnimation.value),
          child: FadeTransition(
            opacity: delayedOpacityAnimation,
            child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "A faster way to get things done",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width > 450 ? 24 : 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
