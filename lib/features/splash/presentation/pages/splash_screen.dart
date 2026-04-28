import 'package:flutter/material.dart';
import 'dart:async';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_gradients.dart';
import 'package:athlorun/config/images/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.navigateScreen,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.splashGradient,
          ),
          child: Center(
            child: Image.asset(
              AppImages.raveAboveIcon,
              width: 140,
              height: 140,
            ),
          ),
        ),
      ),
    );
  }
}