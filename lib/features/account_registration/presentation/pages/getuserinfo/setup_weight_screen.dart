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

class SetupWeightScreenWrapper extends StatelessWidget {
  const SetupWeightScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupWeightScreen(),
    );
  }
}

class SetupWeightScreen extends StatefulWidget {
  const SetupWeightScreen({super.key});

  @override
  State<SetupWeightScreen> createState() => _SetupWeightScreenState();
}

class _SetupWeightScreenState extends State<SetupWeightScreen> {
  int selectedWeight = 65;
  late FixedExtentScrollController _scrollController;
  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    _scrollController = FixedExtentScrollController(
      initialItem: selectedWeight - 30,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedWeight = _userDataProgressModel.weight ?? 65;
        _scrollController.jumpToItem(selectedWeight - 30);
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
                  currentScreen: 3, totalScreens: 8, stepText: "3 - 8"),
              SizedBox(height: Window.getVerticalSize(30)),
              Center(
                child: Text(
                  "What's your weight?",
                  style: AppTextStyles.heading4SemiBold.copyWith(
                    color: AppColors.neutral100,
                    fontSize: Window.getFontSize(22),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(10)),
              Center(
                child: Text(
                  "Knowing your weight helps us personalize your training plan and track progress.",
                  style: AppTextStyles.subtitleRegular.copyWith(
                    color: AppColors.neutral70,
                    fontSize: Window.getFontSize(16),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(30)),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: Window.getVerticalSize(120),
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedWeight = index + 30;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            int weight = index + 30;
                            return Transform.rotate(
                              angle: -1.5708,
                              child: Text(
                                "$weight",
                                style: AppTextStyles.heading1Bold.copyWith(
                                  fontSize: Window.getFontSize(60),
                                  color: selectedWeight == weight
                                      ? AppColors.primaryBlue100
                                      : AppColors.neutral30,
                                ),
                              ),
                            );
                          },
                          childCount: 171, // 30 to 200 kg
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: Window.getVerticalSize(190),
                      child: Text(
                        "Kilograms",
                        style: AppTextStyles.bodyRegular.copyWith(
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
                        AppRoutes.setupAgeScreen, // next step
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
                child: Padding(
                  padding: Window.getSymmetricPadding(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonWidget(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.setupHeightScreen,
                            (routes) => false,
                            arguments: _userDataProgressModel,
                          );
                        },
                      ),
                      NextButtonWidget(
                        onPressed: () {
                          _userDataProgressModel.weight = selectedWeight;
                          _cubit.setUserDataProgreessModel(
                              _userDataProgressModel);
                        },
                      ),
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
}
