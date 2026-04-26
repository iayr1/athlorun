import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/global_store/data/models/user_auth_data_model.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/settings/data/model/get_notification_preference_response_model.dart';
import 'package:athlorun/features/settings/presentation/bloc/settings_cubit.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class NotificationSettingScreenWrapper extends StatelessWidget {
  const NotificationSettingScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>(),
      child: const NotificationSettingScreen(),
    );
  }
}

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool notificationsEnabled = true;
  late final SettingsCubit _cubit;
  late List<Datum> _notificationPreferences = [];
  late UserAuthDataModel _authDataModel;

  @override
  void initState() {
    _cubit = context.read<SettingsCubit>();
    _cubit.getAuthData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Notification Settings",
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
        state.maybeWhen(
            updatedNotificationPreferences: (items) async {
              if (kDebugMode) {
                print(
                    "fcm token : ${await (FirebaseMessaging.instance.getToken())}");
              }

              for (Datum item in items) {
                for (Datum element in _notificationPreferences) {
                  if (item.id == element.id) {
                    int index = _notificationPreferences.indexOf(element);
                    _notificationPreferences.removeAt(index);
                    _notificationPreferences.insert(index, item);
                  }
                }
              }
              notificationsEnabled =
                  _notificationPreferences.every((e) => e.isEnabled == true);
            },
            loadedNotificationPreferences: (response) {
              _notificationPreferences = response.data ?? [];
              notificationsEnabled =
                  _notificationPreferences.every((e) => e.isEnabled == true);
            },
            loadedAuthData: (authData) {
              _authDataModel = authData;
              _cubit.getNotificationPreferences(authData);
            },
            orElse: () {});
      }, builder: (context, state) {
        return Padding(
          padding: Window.getPadding(all: 16.0),
          child: ListView(
            children: [
              Text(
                "Enable Notifications",
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.neutral100),
              ),
              SizedBox(height: Window.getVerticalSize(16)),
              SwitchListTile(
                title:
                    const Text("Notifications", style: AppTextStyles.bodyBold),
                subtitle: Text(
                  "Enable or disable all notifications",
                  style: AppTextStyles.captionRegular
                      .copyWith(color: AppColors.neutral60),
                ),
                value: notificationsEnabled,
                onChanged: (value) {
                  _cubit.updateNotificationPreferences(
                    _authDataModel.id,
                    _notificationPreferences
                        .map(
                          (e) => Datum(
                            id: e.id,
                            type: e.type,
                            isEnabled: !notificationsEnabled,
                          ),
                        )
                        .toList(),
                  );
                },
                activeColor: AppColors.primaryBlue100,
              ),
              ..._notificationPreferences.map(
                (e) => _buildSwitch(
                  e.type ?? "",
                  e.isEnabled ?? false,
                  (value) {
                    _cubit.updateNotificationPreferences(
                      _authDataModel.id,
                      [
                        Datum(
                          id: e.id,
                          type: e.type,
                          isEnabled: !(e.isEnabled ?? true),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSwitch(String type, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        type.replaceAll("_", " ").toTitleCase,
        style: AppTextStyles.bodyBold,
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryBlue100,
    );
  }
}

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}
