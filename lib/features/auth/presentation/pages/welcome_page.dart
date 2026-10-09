import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/widgets/kit.dart';

/// First "Welcome Screen" from the kit.
class WelcomePage extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onSignIn;

  const WelcomePage({
    super.key,
    required this.onGetStarted,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gray10,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const KitLogoMark(size: 64),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  text: 'Welcome to\n',
                  children: [
                    TextSpan(
                      text: 'athlorun ',
                      style: AppText.headingSm.copyWith(
                        color: AppPalette.blue60,
                      ),
                    ),
                    const TextSpan(text: 'App'),
                  ],
                ),
                textAlign: TextAlign.center,
                style: AppText.headingSm,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Image.asset(
                    'assets/onboarding/welcome_1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: KitButton(
                  label: 'Get Started',
                  onPressed: onGetStarted,
                  trailing: const KitPlusIcon(),
                ),
              ),
              const SizedBox(height: 16),
              KitFooterLink(
                prompt: 'Already have an account?',
                action: 'Sign In.',
                onTap: onSignIn,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
