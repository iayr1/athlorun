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

class SetupAgeScreenWrapper extends StatelessWidget {
  const SetupAgeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupAgeScreen(),
    );
  }
}

class SetupAgeScreen extends StatefulWidget {
  const SetupAgeScreen({super.key});

  @override
  State<SetupAgeScreen> createState() => _SetupAgeScreenState();
}

class _SetupAgeScreenState extends State<SetupAgeScreen> {
  int selectedAge = 17;
  late FixedExtentScrollController _scrollController;
  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    _scrollController = FixedExtentScrollController(
      initialItem: selectedAge - 13,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedAge = _userDataProgressModel.age ?? 17;
        _scrollController.jumpToItem(selectedAge - 13);
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
                  currentScreen: 4, totalScreens: 8, stepText: "4 - 8"),
              SizedBox(height: Window.getVerticalSize(30)),
              Center(
                child: Text(
                  "How old are you?",
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
                  "Tell us your age, this will help us to personalize an exercise program that suits you.",
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
                            selectedAge = index + 13;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            int age = index + 13;
                            return Transform.rotate(
                              angle: -1.5708,
                              child: Text(
                                "$age",
                                style: AppTextStyles.heading1Bold.copyWith(
                                  fontSize: Window.getFontSize(60),
                                  color: selectedAge == age
                                      ? AppColors.primaryBlue100
                                      : AppColors.neutral30,
                                ),
                              ),
                            );
                          },
                          childCount: 83,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: Window.getVerticalSize(190),
                      child: Text(
                        "Years",
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
                        AppRoutes.setupLevelScreen,
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
                      BackButtonWidget(onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.setupWeightScreen,
                          (routes) => false,
                          arguments: _userDataProgressModel,
                        );
                      }),
                      NextButtonWidget(
                        onPressed: () {
                          _userDataProgressModel.age = selectedAge;
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
