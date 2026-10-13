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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo mark (72) + wordmark (36 tall), 24 apart.
              const KitLogoMark(size: 72),
              const SizedBox(height: 24),
              SizedBox(
                height: 36,
                child: Text(
                  'athlorun',
                  style: AppText.headingSm.copyWith(
                    fontSize: 36,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: message == null ? 238 : null,
                child: Text(
                  message ?? 'Your Intelligent AI Fitness & Wellness Companion.',
                  textAlign: TextAlign.center,
                  style: AppText.paragraphMd,
                ),
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
