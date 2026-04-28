import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class InstallHealthConnectWidget extends StatefulWidget {
  const InstallHealthConnectWidget({super.key});

  @override
  State<InstallHealthConnectWidget> createState() =>
      _InstallHealthConnectWidgetState();
}

class _InstallHealthConnectWidgetState
    extends State<InstallHealthConnectWidget> {

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        height: Window.getVerticalSize(220),
        width: Window.width,
        padding: Window.getPadding(all: 16),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral70.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.health_and_safety,
                      color: AppColors.primaryBlue100,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Google Health Connect",
                      style: AppTextStyles.heading5Bold,
                    ),
                  ],
                ),

                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isVisible = false;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Description
            Text(
              "Sync your health data seamlessly using Google Health Connect. Install now to get started!",
              style: AppTextStyles.bodyRegular
                  .copyWith(color: AppColors.neutral70),
            ),

            const Spacer(),

            /// Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  // UI only
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Install Clicked")),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.download, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Install Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}