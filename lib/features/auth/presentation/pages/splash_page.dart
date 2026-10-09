import 'package:flutter/material.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/widgets/kit.dart';

/// "Splash" screen from the kit: logo mark, wordmark and tagline.
class SplashPage extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const SplashPage({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const KitLogoMark(size: 72),
              const SizedBox(height: 24),
              Text(
                'athlorun',
                style: AppText.headingSm.copyWith(
                  fontSize: 36,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                message ?? 'Your Intelligent Fitness &\nWellness Companion.',
                textAlign: TextAlign.center,
                style: AppText.paragraphMd,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: 180,
                  child: KitButton(
                    label: 'Try again',
                    onPressed: onRetry,
                    trailing: const Icon(Icons.refresh_rounded),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 32),
                const SizedBox(
                  width: 120,
                  child: KitProgressBar(value: 1),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
