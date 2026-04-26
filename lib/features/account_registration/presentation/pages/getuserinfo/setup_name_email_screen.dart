import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/windows.dart';
import '../../../../../core/widgets/custom_textfield.dart';
import '../../../../../core/widgets/custom_action_button.dart';

class SetupNameEmailScreenWrapper extends StatelessWidget {
  const SetupNameEmailScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isCheckboxChecked = false;
  late final AccountRegistrationCubit _cubit;
  late UserDataProgressModel _userDataProgressModel;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userDataProgressModel.name != null &&
          _userDataProgressModel.name != "" &&
          _userDataProgressModel.email != null &&
          _userDataProgressModel.email != "") {
        _cubit.checkbox(true);
        nameController.text = _userDataProgressModel.name ?? "";
        emailController.text = _userDataProgressModel.email ?? "";
      }
    });
    super.initState();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name must contain only letters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
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
          listener: (_, state) {
            state.maybeWhen(
              setUserProgressData: (progressData) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.setupTargetScreen,
                  arguments: progressData,
                );
              },
              setUserProgressDataError: (error) {
                Utils.showCustomDialog(context, AppStrings.error, error);
              },
              checkboxLoaded: (valid) {
                setState(() {
                  isCheckboxChecked = valid;
                });
              },
              orElse: () {},
            );
          },
          builder: (context, snapshot) {
            return Stack(
              children: [
                Padding(
                  padding: Window.getSymmetricPadding(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 150),
                          Text(
                            AppStrings.registerTitle,
                            style: AppTextStyles.heading4SemiBold.copyWith(
                              color: AppColors.neutral100,
                              fontSize: Window.getFontSize(24),
                            ),
                          ),
                          SizedBox(height: Window.getVerticalSize(5)),
                          Text(
                            AppStrings.registerSubtitle,
                            style: AppTextStyles.subtitleRegular.copyWith(
                              color: AppColors.neutral70,
                              fontSize: Window.getFontSize(16),
                            ),
                          ),
                          SizedBox(height: Window.getVerticalSize(30)),
                          Text(
                            AppStrings.registerNameLabel,
                            style: AppTextStyles.subtitleMedium.copyWith(
                              color: AppColors.neutral100,
                              fontSize: Window.getFontSize(18),
                            ),
                          ),
                          SizedBox(height: Window.getVerticalSize(8)),
                          CustomTextFieldWidget(
                            hintText: AppStrings.registerNameHint,
                            controller: nameController,
                            validator: _validateName,
                          ),
                          SizedBox(height: Window.getVerticalSize(20)),
                          Text(
                            AppStrings.registerEmailLabel,
                            style: AppTextStyles.subtitleMedium.copyWith(
                              color: AppColors.neutral100,
                              fontSize: Window.getFontSize(18),
                            ),
                          ),
                          SizedBox(height: Window.getVerticalSize(8)),
                          CustomTextFieldWidget(
                            hintText: AppStrings.registerEmailHint,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          SizedBox(height: Window.getVerticalSize(15)),
                          Row(
                            children: [
                              Transform.translate(
                                offset: const Offset(-11, -11),
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    activeColor: AppColors.primaryBlue100,
                                    value: isCheckboxChecked,
                                    onChanged: (bool? value) {
                                      _cubit.checkbox(
                                          isCheckboxChecked = value ?? false);
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Transform.translate(
                                  offset: const Offset(-10, 0),
                                  child: Text.rich(
                                    TextSpan(
                                      text: AppStrings.registerTermsText,
                                      style: AppTextStyles.bodyRegular.copyWith(
                                        color: AppColors.neutral60,
                                        fontSize: Window.getFontSize(14),
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              AppStrings.registerTermsOfService,
                                          style:
                                              AppTextStyles.bodyBold.copyWith(
                                            color: AppColors.primaryBlue100,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ". See our ",
                                          style: AppTextStyles.bodyRegular
                                              .copyWith(
                                            color: AppColors.neutral60,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              AppStrings.registerPrivacyPolicy,
                                          style:
                                              AppTextStyles.bodyBold.copyWith(
                                            color: AppColors.primaryBlue100,
                                          ),
                                        ),
                                        const TextSpan(text: "."),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CustomActionButton(
                      name: AppStrings.registerButton,
                      onTap: (startLoading, stopLoading, btnState) {
                        if (_formKey.currentState!.validate() &&
                            isCheckboxChecked) {
                          _userDataProgressModel.name = nameController.text;
                          _userDataProgressModel.email = emailController.text;
                          _cubit.setUserDataProgreessModel(
                              _userDataProgressModel);
                        } else if (!isCheckboxChecked) {
                          Utils.showCustomDialog(context, AppStrings.error,
                              "Please agree to the terms and conditions");
                        }
                      },
                      isFormFilled: isCheckboxChecked,
                      isError: !isCheckboxChecked,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
