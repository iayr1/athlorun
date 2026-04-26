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
  late final SplashCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<SplashCubit>();
    Future.delayed(const Duration(seconds: 3), () {
      _cubit.getOnboardingStatus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            state.maybeWhen(
              loadedUserProgressData: (userData, progressData) {
                if (userData.profilePhoto != null &&
                    userData.profilePhoto != "") {
                  progressData.profilePhoto = userData.profilePhoto;
                }
                if (progressData.name == null || progressData.name == "") {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupNameEmailScreen,
                    arguments: progressData,
                  );
                } else if (progressData.email == null ||
                    progressData.email == "") {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupNameEmailScreen,
                    arguments: progressData,
                  );
                } else if (progressData.target == null ||
                    progressData.target == "") {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupTargetScreen,
                    arguments: progressData,
                  );
                } else if (progressData.age == null) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupAgeScreen,
                    arguments: progressData,
                  );
                } else if (progressData.exerciseLevel == null ||
                    progressData.exerciseLevel == "") {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupLevelScreen,
                    arguments: progressData,
                  );
                } else if (progressData.gender == null ||
                    progressData.gender == "") {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupGenderScreen,
                    arguments: progressData,
                  );
                } else if (progressData.activitiesCount == null) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupActivityScreen,
                    arguments: progressData,
                  );
                } else if (progressData.profilePhoto == null ||
                    progressData.profilePhoto == "") {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupProfilePhotoScreen,
                    arguments: progressData,
                  );
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.setupProfilePhotoScreen,
                    arguments: progressData,
                  );
                }
                //  else if (progressData.reminder == null ||
                //     progressData.reminder == "") {
                //   Navigator.pushReplacementNamed(
                //     context,
                //     AppRoutes.setupReminderScreen,
                //     arguments: progressData,
                //   );
                // } else {
                //   Navigator.pushReplacementNamed(
                //     context,
                //     AppRoutes.setupReminderScreen,
                //     arguments: progressData,
                //   );
                // }
              },
              loadUserProgressDataError: (userData, error) {
                UserDataProgressModel progressData = UserDataProgressModel();
                if (userData.profilePhoto != null &&
                    userData.profilePhoto != "") {
                  progressData.profilePhoto = userData.profilePhoto;
                }
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.setupNameEmailScreen,
                  arguments: progressData,
                );
              },
              loadedUserData: (userData) {
                if (userData.name == null || userData.name.isEmpty) {
                  _cubit.getUserDataProgress(userData);
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.dashboardScreen,
                    (route) => false,
                  );
                }
              },
              loadUserDataError: (error) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.loginErrorScreen,
                );
              },
              loadOnboardingStatusError: (error) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.onboarding,
                  (route) => false,
                );
              },
              loadedOnboardingStatus: () {
                _cubit.getAuthData();
              },
              loadedAuthData: (authData) {
                _cubit.getUserData(
                  authData.id,
                  authData.accessToken,
                  authData.refreshToken,
                );
              },
              loadAuthDataError: (error) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signIn,
                  (route) => false,
                );
              },
              orElse: () {},
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.splashGradient,
            ),
            child: Center(
              child: Image.asset(AppImages.raveAboveIcon),
            ),
          ),
        ),
      ),
    );
  }
}
