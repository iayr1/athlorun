import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'dart:async';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_gradients.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/features/splash/presentation/bloc/splash_cubit.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SplashCubit>(),
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.navigateScreen);
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
            child: Image.asset(AppImages.raveAboveIcon),
          ),
        ),
      ),
    );
  }
}
