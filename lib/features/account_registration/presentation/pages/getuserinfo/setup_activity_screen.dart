import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';
import '../../../../../core/utils/windows.dart';
import '../../../../../core/widgets/linear_progress_indicator.dart';
import 'package:athlorun/core/widgets/back_button_widget.dart';
import 'package:athlorun/core/widgets/next_button_widget.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';

class SetupActivityScreenWrapper extends StatelessWidget {
  const SetupActivityScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupActivityScreen(),
    );
  }
}

class SetupActivityScreen extends StatefulWidget {
  const SetupActivityScreen({super.key});

  @override
  State<SetupActivityScreen> createState() => _SetupActivityScreenState();
}

class _SetupActivityScreenState extends State<SetupActivityScreen> {
  int selectedActivity = 15;
  late FixedExtentScrollController _scrollController;

  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    _scrollController =
        FixedExtentScrollController(initialItem: selectedActivity - 10);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedActivity = _userDataProgressModel.activitiesCount ?? 15;
        _scrollController.jumpToItem(selectedActivity - 10);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userDataProgressModel =
        ModalRoute.of(context)!.settings.arguments as UserDataProgressModel;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.neutral10,
        body: Padding(
          padding: Window.getSymmetricPadding(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Window.getVerticalSize(50)),
              const ProgressBarWidget(
                  currentScreen: 7, totalScreens: 8, stepText: "7 - 8"),
              SizedBox(height: Window.getVerticalSize(30)),
              Center(
                child: Text(
                  "How many activities do you want to do?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading4SemiBold.copyWith(
                    fontSize: Window.getFontSize(22),
                    color: AppColors.neutral100,
                  ),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(10)),
              Center(
                child: Text(
                  "Make sure the number is reasonable to you.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitleRegular.copyWith(
                    fontSize: Window.getFontSize(16),
                    color: AppColors.neutral70,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: Window.getHorizontalSize(120),
                        perspective: 0.005,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedActivity = index + 10;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            int activity = index + 10;
                            return Center(
                              child: Transform.rotate(
                                angle: -1.5708,
                                child: Text(
                                  "$activity",
                                  style:
                                      AppTextStyles.heading1SemiBold.copyWith(
                                    fontSize: Window.getFontSize(60),
                                    color: selectedActivity == activity
                                        ? AppColors.primaryBlue100
                                        : AppColors.neutral30,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: 21,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: Window.getVerticalSize(190),
                      child: Text(
                        "Activities",
                        style: AppTextStyles.subtitleMedium.copyWith(
                          fontSize: Window.getFontSize(16),
                          color: AppColors.neutral70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Window.getVerticalSize(30)),
              BlocListener<AccountRegistrationCubit, AccountRegistrationState>(
                listener: (context, state) {
                  state.maybeWhen(
                    setUserProgressData: (progressData) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.setupProfilePhotoScreen,
                        (routes) => false,
                        arguments: progressData,
                      );
                    },
                    setUserProgressDataError: (error) {
                      Utils.showCustomDialog(context, AppStrings.error, error);
                    },
                    orElse: () {},
                  );
                },
                child: SizedBox(
                  height: Window.getVerticalSize(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonWidget(onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.setupGenderScreen,
                          (routes) => false,
                          arguments: _userDataProgressModel,
                        );
                      }),
                      NextButtonWidget(onPressed: () {
                        _userDataProgressModel.activitiesCount =
                            selectedActivity;
                        _cubit
                            .setUserDataProgreessModel(_userDataProgressModel);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
