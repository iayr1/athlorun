import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart'; // Optional animation

class TicketSuccessScreen extends StatelessWidget {
  const TicketSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppImages.successLottie,
                  height: 250,
                  repeat: false,
                ),
                const SizedBox(height: 8),
                Text(
                  'Payment Successful!',
                  style: AppTextStyles.heading3Medium.copyWith(
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Your ticket for "athlorun Marathon" is confirmed.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyRegular,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: Window.getPadding(all: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.neutral20,
                  ),
                  child: const Column(
                    children: [
                      TicketDetailRow(
                          label: 'Event', value: 'athlorun Marathon'),
                      TicketDetailRow(label: 'Date', value: '2025-05-12'),
                      TicketDetailRow(
                          label: 'Ticket ID', value: 'RA-123456789'),
                    ],
                  ),
                ),
                const Spacer(),
                CustomActionButton(
                  onTap: (startLoading, stopLoading, btnState) {
                    Navigator.pop(context);
                  },
                  name: AppStrings.back,
                  isFormFilled: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const TicketDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral50),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppTextStyles.bodyRegular,
          ),
        ],
      ),
    );
  }
}
