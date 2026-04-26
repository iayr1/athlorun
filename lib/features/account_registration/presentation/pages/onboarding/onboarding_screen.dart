// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';

class OnboardingScreenWrapper extends StatelessWidget {
  const OnboardingScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final AccountRegistrationCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryBlue100.withOpacity(0.08),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: PopScope(
        child: Scaffold(
          body:
              BlocConsumer<AccountRegistrationCubit, AccountRegistrationState>(
            listener: (context, state) {
              state.maybeWhen(
                setOnboardingStatusError: (error) {
                  Utils.showCustomDialog(context, AppStrings.error, error);
                },
                setOnboardingStatus: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.signIn,
                    (route) => false,
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.runnerBackground),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(
                        204,
                        53,
                        125,
                        248,
                      ),
                    ),
                  ),
                  Positioned(
                    top: Window.safeHeight * 0.12,
                    left: 0,
                    right: 0,
                    child: Text(
                      AppStrings.onboardingTitle,
                      style: AppTextStyles.heading2SemiBold
                          .copyWith(
                            color: AppColors.neutral10,
                          )
                          .copyWith(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.welcome,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading3SemiBold.copyWith(
                            color: AppColors.neutral10,
                          ), // Reuse body style
                        ),
                        Text(
                          AppStrings.onboardingSubtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleRegular.copyWith(
                            color: AppColors.neutral10,
                          ), // Reuse body style
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: Window.height * 0.9,
                    left: 12,
                    right: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neutral10,
                          foregroundColor: AppColors.neutral100,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        icon: const Icon(Icons.phone_in_talk),
                        label: const Text(
                          AppStrings.onboardingButtonText,
                          style: AppTextStyles.subtitleMedium,
                        ),
                        onPressed: () {
                          _cubit.setOnboardingStatus(true);
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
