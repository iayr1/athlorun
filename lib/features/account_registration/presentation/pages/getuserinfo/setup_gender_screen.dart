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

class SetupGenderScreenWrapper extends StatelessWidget {
  const SetupGenderScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupGenderScreen(),
    );
  }
}

class SetupGenderScreen extends StatefulWidget {
  const SetupGenderScreen({super.key});

  @override
  State<SetupGenderScreen> createState() => _SetupGenderScreenState();
}

class _SetupGenderScreenState extends State<SetupGenderScreen> {
  int selectedGenderIndex = 0;
  String selectedGenderText = "Male";
  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_userDataProgressModel.gender == "male") {
          selectedGenderText = "Male";
          selectedGenderIndex = 0;
        } else if (_userDataProgressModel.gender == "female") {
          selectedGenderText = "Female";
          selectedGenderIndex = 1;
        } else if (_userDataProgressModel.gender == "other") {
          selectedGenderText = "Other";
          selectedGenderIndex = 2;
        } else {
          selectedGenderText = "Male";
          selectedGenderIndex = 0;
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
                  currentScreen: 6, totalScreens: 8, stepText: "6 - 8"),
              SizedBox(height: Window.getVerticalSize(30)),
              Center(
                child: Text(
                  "What is your gender?",
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
                  "Select your gender, this helps us create a tailored experience for you.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitleRegular.copyWith(
                    fontSize: Window.getFontSize(16),
                    color: AppColors.neutral70,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGenderOption(0, "Male"),
                    SizedBox(height: Window.getVerticalSize(10)),
                    _buildGenderOption(1, "Female")
                  ],
                ),
              ),
              BlocListener<AccountRegistrationCubit, AccountRegistrationState>(
                listener: (context, state) {
                  state.maybeWhen(
                    setUserProgressData: (progressData) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.setupActivityScreen,
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
                          AppRoutes.setupLevelScreen,
                          (routes) => false,
                          arguments: _userDataProgressModel,
                        );
                      }),
                      NextButtonWidget(onPressed: () {
                        _userDataProgressModel.gender =
                            selectedGenderText.toLowerCase();
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

  Widget _buildGenderOption(int index, String genderText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGenderIndex = index;
          selectedGenderText = genderText;
        });
      },
      child: Container(
        padding: Window.getPadding(all: 15),
        decoration: BoxDecoration(
          color: selectedGenderIndex == index
              ? AppColors.primaryBlue30
              : AppColors.neutral10,
          borderRadius: BorderRadius.circular(Window.getRadiusSize(30)),
          border: Border.all(
            color: selectedGenderIndex == index
                ? AppColors.primaryBlue100
                : AppColors.neutral30,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              genderText,
              style: AppTextStyles.bodyBold.copyWith(
                fontSize: Window.getFontSize(16),
                color: selectedGenderIndex == index
                    ? AppColors.primaryBlue100
                    : AppColors.neutral100,
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(10)),
            if (selectedGenderIndex == index)
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
