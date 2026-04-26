import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../../../../../config/routes/routes.dart';
import '../../../../core/widgets/custom_action_button.dart';

class LoginErrorScreen extends StatelessWidget {
  final String errorMessage;

  const LoginErrorScreen({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10, 
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Lottie.asset(
                'assets/login.json', 
                height: 400,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitleRegular.copyWith(
                color: AppColors.secondaryPurple50,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomActionButton(
              onTap: (startLoading, stopLoading, btnState) {
                startLoading();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signIn, 
                      (route) => false,
                );
                stopLoading();
              },
              name: "Retry",
              isFormFilled: true, 
            ),
          ),

          const SizedBox(height: 24), 
        ],
      ),
    );
  }
}
