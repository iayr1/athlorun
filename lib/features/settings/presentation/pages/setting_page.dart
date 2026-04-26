import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/settings/presentation/bloc/settings_cubit.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class SettingScreenWrapper extends StatelessWidget {
  const SettingScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>(),
      child: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<SettingsCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        title: "Settings",
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          state.maybeWhen(
              loggedOut: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.splashScreen,
                  (routes) => false,
                );
              },
              logOutError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.neutral10,
                      ),
                    ),
                    backgroundColor: AppColors.primaryBlue100,
                  ),
                );
              },
              deleteUserError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.neutral10,
                      ),
                    ),
                    backgroundColor: AppColors.primaryBlue100,
                  ),
                );
              },
              deletedUser: (response) {
                _cubit.logout();
              },
              loadedAuthData: (authData) {
                _cubit.deleteUser(authData);
              },
              loadAuthDataError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error,
                      style: AppTextStyles.bodyRegular.copyWith(
                        color: AppColors.neutral10,
                      ),
                    ),
                    backgroundColor: AppColors.primaryBlue100,
                  ),
                );
              },
              orElse: () {});
        },
        child: Padding(
          padding: Window.getPadding(all: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildSettingsOption(
                      icon: Icons.help_outline,
                      title: "FAQ",
                      onTap: () {},
                    ),
                    _buildSettingsOption(
                      icon: Icons.info_outline,
                      title: "About App",
                      onTap: () {},
                    ),
                    _buildSettingsOption(
                      icon: Icons.notifications_outlined,
                      title: "Notification Setting",
                      onTap: () {
                        // Handle About App
                        Navigator.pushNamed(
                            context, AppRoutes.pushNotification);
                      },
                    ),
                    _buildSettingsOption(
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
                            _cubit.getAuthData();
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
                    onConfirm: () {
                      startLoading();
                      Future.delayed(
                        const Duration(seconds: 2),
                        () {
                          stopLoading();
                          _cubit.logout();
                        },
                      );
                    },
                    confirmText: "Log Out",
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
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
        const Divider(height: 1, thickness: 1, color: AppColors.neutral30),
      ],
    );
  }
}
