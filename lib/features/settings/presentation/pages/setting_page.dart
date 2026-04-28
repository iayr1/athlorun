import 'package:flutter/material.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        title: "Settings",
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: Window.getPadding(all: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.help_outline,
                    title: "FAQ",
                    onTap: () {},
                  ),
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.info_outline,
                    title: "About App",
                    onTap: () {},
                  ),
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.notifications_outlined,
                    title: "Notification Setting",
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.pushNotification,
                      );
                    },
                  ),
                  _buildSettingsOption(
                    context: context,
                    icon: Icons.delete_outline,
                    title: "Delete Your Account",
                    textColor: Colors.red.shade400,
                    iconColor: Colors.red.shade400,
                    onTap: () {
                      Utils.showConfirmationDialog(
                        context: context,
                        title: "Delete Account",
                        message:
                            "Are you sure you want to permanently delete your account?",
                        confirmText: "Delete",
                        confirmColor: Colors.red.shade400,
                        onConfirm: () {
                          // TODO: call delete API
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Account deleted (UI only)"),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: Window.getSymmetricPadding(vertical: 16.0),
              child: Text(
                "Fitfleet version 0.0.1",
                style: AppTextStyles.captionRegular
                    .copyWith(color: AppColors.neutral50),
              ),
            ),

            CustomActionButton(
              name: "Log Out",
              isFormFilled: true,
              onTap: (startLoading, stopLoading, btnState) {
                Utils.showConfirmationDialog(
                  title: "Log Out",
                  context: context,
                  message: "Are you sure you want to log out?",
                  confirmText: "Log Out",
                  onConfirm: () {
                    startLoading();

                    Future.delayed(const Duration(seconds: 2), () {
                      stopLoading();

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.splashScreen,
                        (route) => false,
                      );
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(
              title,
              style: AppTextStyles.bodySemiBold.copyWith(color: textColor),
            ),
            onTap: onTap,
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.neutral30,
        ),
      ],
    );
  }
}