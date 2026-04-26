import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/features/home/presentation/bloc/home_page_cubit.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';

class InstallHealthConnectWidgetWrapper extends StatelessWidget {
  const InstallHealthConnectWidgetWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomePageCubit>(),
      child: const InstallHealthConnectWidget(),
    );
  }
}

class InstallHealthConnectWidget extends StatefulWidget {
  const InstallHealthConnectWidget({super.key});

  @override
  State<InstallHealthConnectWidget> createState() =>
      _InstallHealthConnectWidgetState();
}

class _InstallHealthConnectWidgetState
    extends State<InstallHealthConnectWidget> {
  bool _isVisible = false;
  late final HomePageCubit _cubit;
  late TutorialCoachMark tutorialCoachMark;

  final GlobalKey keyInstallButton = GlobalKey();
  final GlobalKey keyCloseButton = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomePageCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getHealthSdkStatus();
      _createTutorial();
      Future.delayed(Duration.zero, _showTutorial);
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
        listener: (context, state) {
      state.maybeWhen(
        checkedHealthSdkStatus: (status) {
          setState(() {
            _isVisible = !status; // Hide if installed
          });
          if (status) {
            _cubit.requestHealthPermissions([HealthDataType.STEPS],
                permissions: [HealthDataAccess.READ_WRITE]);
          }
        },
        setVisibility: (visibility) {
          setState(() {
            _isVisible = visibility;
          });
        },
        requestedHealthPermissions: (status) {
          if (status) {
            _cubit.getTotalStepsInInterval(
                DateTime(2020, 01, 01), DateTime.now());
          }
        },
        orElse: () {},
      );
    }, builder: (context, state) {
      return Visibility(
        visible: _isVisible,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.health_and_safety,
                        color: AppColors.primaryBlue100,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Google Health Connect",
                        style: AppTextStyles.heading5Bold
                            .copyWith(color: AppColors.neutral100),
                      ),
                    ],
                  ),
                  IconButton(
                    key: keyCloseButton,
                    icon: Icon(Icons.close, color: AppColors.neutral100),
                    onPressed: () {
                      _cubit.setVisibility(false);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Sync your health data seamlessly using Google Health Connect. Install now to get started!",
                style: AppTextStyles.bodyRegular
                    .copyWith(color: AppColors.neutral70),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  key: keyInstallButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    _cubit.installHealthConnect();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download, color: AppColors.neutral10),
                      SizedBox(width: 8),
                      Text(
                        "Install Now",
                        style: AppTextStyles.bodyBold
                            .copyWith(color: AppColors.neutral10),
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
    });
  }

  void _showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void _createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.7),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
    );
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "InstallButton",
        keyTarget: keyInstallButton,
        enableOverlayTab: false, // Allows tap-through to the button
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return Text(
                "Tap to\n install",
                style:
                    AppTextStyles.bodyBold.copyWith(color: AppColors.neutral10),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "CloseButton",
        keyTarget: keyCloseButton,
        enableOverlayTab: true, // Default behavior for the close button
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return Text(
                "Tap here to close this notification if you don't want to install now.",
                style:
                    AppTextStyles.bodyBold.copyWith(color: AppColors.neutral10),
              );
            },
          ),
        ],
      ),
    ];
  }
}
