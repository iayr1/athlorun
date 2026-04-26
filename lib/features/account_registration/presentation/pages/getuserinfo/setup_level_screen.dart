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

class SetupLevelScreenWrapper extends StatelessWidget {
  const SetupLevelScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupLevelScreen(),
    );
  }
}

class SetupLevelScreen extends StatefulWidget {
  const SetupLevelScreen({super.key});

  @override
  State<SetupLevelScreen> createState() => _SetupLevelScreenState();
}

class _SetupLevelScreenState extends State<SetupLevelScreen> {
  int selectedLevelindex = 0;
  String selectedLevelText = "Beginner";
  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;
  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_userDataProgressModel.exerciseLevel == "beginner") {
          selectedLevelText = "Beginner";
          selectedLevelindex = 0;
        } else if (_userDataProgressModel.exerciseLevel == "intermediate") {
          selectedLevelText = "Intermediate";
          selectedLevelindex = 1;
        } else if (_userDataProgressModel.exerciseLevel == "advanced") {
          selectedLevelText = "Advanced";
          selectedLevelindex = 2;
        } else {
          selectedLevelText = "Beginner";
          selectedLevelindex = 0;
        }
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
                  currentScreen: 5, totalScreens: 8, stepText: "5 - 8"),
              SizedBox(height: Window.getVerticalSize(30)),
              Center(
                child: Text(
                  "What is your level?",
                  style: AppTextStyles.heading4SemiBold.copyWith(
                    fontSize: Window.getFontSize(22),
                    color: AppColors.neutral100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(10)),
              Center(
                child: Text(
                  "Choose your level, this will help us to personalize an exercise program that suits you.",
                  style: AppTextStyles.subtitleRegular.copyWith(
                    fontSize: Window.getFontSize(16),
                    color: AppColors.neutral70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLevelOption(0, "Beginner"),
                    SizedBox(height: Window.getVerticalSize(10)),
                    _buildLevelOption(1, "Intermediate"),
                    SizedBox(height: Window.getVerticalSize(10)),
                    _buildLevelOption(2, "Advanced"),
                  ],
                ),
              ),
              BlocListener<AccountRegistrationCubit, AccountRegistrationState>(
                listener: (context, state) {
                  state.maybeWhen(
                    setUserProgressData: (progressData) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.setupGenderScreen,
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
                          AppRoutes.setupAgeScreen,
                          (routes) => false,
                          arguments: _userDataProgressModel,
                        );
                      }),
                      NextButtonWidget(onPressed: () {
                        _userDataProgressModel.exerciseLevel =
                            selectedLevelText.toLowerCase();
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

  Widget _buildLevelOption(int index, String levelText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLevelindex = index;
          selectedLevelText = levelText;
        });
      },
      child: Container(
        padding: Window.getPadding(all: 15),
        decoration: BoxDecoration(
          color: selectedLevelindex == index
              ? AppColors.primaryBlue30
              : AppColors.neutral10,
          borderRadius: BorderRadius.circular(Window.getRadiusSize(30)),
          border: Border.all(
            color: selectedLevelindex == index
                ? AppColors.primaryBlue100
                : AppColors.neutral30,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              levelText,
              style: AppTextStyles.bodySemiBold.copyWith(
                fontSize: Window.getFontSize(16),
                color: selectedLevelindex == index
                    ? AppColors.primaryBlue100
                    : AppColors.neutral100,
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(10)),
            if (selectedLevelindex == index)
              Icon(
                Icons.check,
                color: AppColors.primaryBlue100,
                size: Window.getFontSize(20),
              ),
          ],
        ),
      ),
    );
  }
}
