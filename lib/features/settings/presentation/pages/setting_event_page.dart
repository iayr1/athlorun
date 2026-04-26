import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class SettingEventPage extends StatelessWidget {
  // List of settings items with updated dynamic data
  final List<Map<String, dynamic>> settingsOptions = [
    {
      "title": "Manage Notifications",
      "icon": Icons.notifications,
      "onTap": () {
        // Navigate or perform action for Manage Notifications
        print("Navigated to Manage Notifications");
      },
    },
    {
      "title": "View Event Calendar",
      "icon": Icons.calendar_today,
      "onTap": () {
        // Navigate or perform action for View Event Calendar
        print("Navigated to View Event Calendar");
      },
    },
    {
      "title": "View Payment History",
      "icon": Icons.payment,
      "onTap": () {
        // Navigate or perform action for View Payment History
        print("Navigated to View Payment History");
      },
    },
    {
      "title": "Help & Support",
      "icon": Icons.help,
      "onTap": () {
        // Navigate or perform action for Help & Support
        print("Navigated to Help & Support");
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral30, // Light background for clean design
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: Window.getPadding(top: 50, left: 20, bottom: 20),
            child: Text(
              "Settings",
              style: AppTextStyles.heading4Bold.copyWith(
                color: AppColors.neutral80,
              ),
            ),
          ),

          // List of Settings Options
          Expanded(
            child: ListView.builder(
              itemCount: settingsOptions.length,
              itemBuilder: (context, index) {
                final item = settingsOptions[index];
                return GestureDetector(
                  onTap: item["onTap"], // Handle dynamic actions
                  child: Container(
                    margin: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
                    padding: Window.getPadding(all: 16),
                    decoration: BoxDecoration(
                      color: AppColors.neutral10,
                      borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neutral60.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item["icon"], // Dynamic Icon
                          color: AppColors.primaryBlue100,
                          size: Window.getFontSize(24),
                        ),
                        SizedBox(width: Window.getHorizontalSize(16)),
                        Text(
                          item["title"], // Dynamic Title
                          style: AppTextStyles.bodySemiBold.copyWith(
                            color: AppColors.neutral80,
                            fontSize: Window.getFontSize(16),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: Window.getFontSize(16),
                          color: AppColors.neutral60,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
