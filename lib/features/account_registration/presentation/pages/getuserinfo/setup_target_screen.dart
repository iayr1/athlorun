import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/back_button_widget.dart';
import 'package:athlorun/core/widgets/linear_progress_indicator.dart';
import 'package:athlorun/core/widgets/next_button_widget.dart';
import 'package:athlorun/features/account_registration/data/models/targets_response_model.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';

class SetupTargetScreenWrapper extends StatelessWidget {
  const SetupTargetScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupTargetScreen(),
    );
  }
}

class SetupTargetScreen extends StatefulWidget {
  const SetupTargetScreen({super.key});

  @override
  State<SetupTargetScreen> createState() => _SetupTargetScreenState();
}

class _SetupTargetScreenState extends State<SetupTargetScreen> {
  late int selectedIndex;
  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;
  List<Datum> _targets = [];
  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    _cubit.getTargets();

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
        body: BlocConsumer<AccountRegistrationCubit, AccountRegistrationState>(
          listener: (context, state) {
            state.maybeWhen(
              loadedTargets: (targets) {
                _targets = targets.data ?? [];
                selectedIndex = 0;
              },
              setUserProgressData: (progressData) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.setupHeightScreen,
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
          builder: (context, state) {
            return Padding(
              padding: Window.getSymmetricPadding(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Window.getVerticalSize(50)),
                  const ProgressBarWidget(
                      currentScreen: 1, totalScreens: 8, stepText: "1 - 8"),
                  SizedBox(height: Window.getVerticalSize(30)),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "What would you like to achieve?",
                          style: AppTextStyles.heading4SemiBold.copyWith(
                            color: AppColors.neutral100,
                            fontSize: Window.getFontSize(22),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Window.getVerticalSize(10)),
                        Text(
                          "We will help you to achieve your target.",
                          style: AppTextStyles.subtitleRegular.copyWith(
                            color: AppColors.neutral70,
                            fontSize: Window.getFontSize(16),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(10)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _targets.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: Window.getMargin(bottom: 20),
                            height: Window.getVerticalSize(150),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Window.getRadiusSize(15),
                              ),
                              image: DecorationImage(
                                image:
                                    NetworkImage(_targets[index].banner ?? ""),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: Window.getPadding(all: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: selectedIndex == index
                                        ? Container(
                                            width: 26,
                                            height: 26,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primaryBlue100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.radio_button_unchecked,
                                            color: AppColors.neutral10,
                                            size: 26,
                                          ),
                                  ),
                                  SizedBox(height: Window.getVerticalSize(20)),
                                  Expanded(
                                    child: Text(
                                      _targets[index].name ?? "",
                                      style: AppTextStyles.heading5Regular
                                          .copyWith(
                                        color: AppColors.neutral10,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Window.getVerticalSize(80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButtonWidget(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.setupNameEmailScreen,
                              (routes) => false,
                              arguments: _userDataProgressModel,
                            );
                          },
                        ),
                        NextButtonWidget(
                          onPressed: () {
                            _userDataProgressModel.target =
                                _targets[selectedIndex].name;
                            _cubit.setUserDataProgreessModel(
                              _userDataProgressModel,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
