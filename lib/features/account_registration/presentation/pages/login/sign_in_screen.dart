import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';

class SignInScreenWrapper extends StatelessWidget {
  const SignInScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String selectedCountryName = "India";
  String countryCode = "+91";
  final TextEditingController phoneController = TextEditingController();
  bool _isFormValid = false;
  late final AccountRegistrationCubit _cubit;
  late String _mobileNumber;
  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.neutral10,
        elevation: 0,
        leading: const SizedBox(),
      ),
      body: BlocListener<AccountRegistrationCubit, AccountRegistrationState>(
        listener: (context, state) {
          state.maybeWhen(
            validatedTextField: (isFormValid) {
              setState(
                () {
                  _isFormValid = isFormValid;
                },
              );
            },
            selectedCountry: (name, code) {
              setState(
                () {
                  selectedCountryName = name;
                  countryCode = code;
                },
              );
            },
            sentOtp: (response) {
              Navigator.pushNamed(
                context,
                AppRoutes.enterOtp,
                arguments: {
                  'mobileNumber': countryCode + _mobileNumber,
                  'otpHint': response.data?.message,
                },
              );
            },
            sendOtpError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            orElse: () {},
          );
        },
        child: Padding(
          padding: Window.getMargin(all: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Window.getVerticalSize(20)),
              Text(
                AppStrings.signTitle,
                style: AppTextStyles.heading3Bold.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(5)),
              Text(
                AppStrings.signInToYourAccount,
                style: AppTextStyles.subtitleRegular.copyWith(
                  color: AppColors.neutral60,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(40)),
              Text(
                AppStrings.phone,
                style: AppTextStyles.subtitleBold.copyWith(
                  color: AppColors.neutral100,
                ),
              ),
              SizedBox(height: Window.getVerticalSize(10)),
              Row(
                children: [
                  // GestureDetector(
                  //   onTap: () async {
                  //     context
                  //         .read<AccountRegistrationCubit>()
                  //         .selectCountry(context);
                  //   },
                  //   child: Container(
                  //     height: Window.getVerticalSize(50),
                  //     padding: Window.getSymmetricPadding(horizontal: 10),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.neutral20,
                  //       borderRadius:
                  //           BorderRadius.circular(Window.getRadiusSize(10)),
                  //       border: Border.all(color: AppColors.primaryBlue100),
                  //     ),
                  //     child: Center(
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             countryCode,
                  //             style: AppTextStyles.bodyBold.copyWith(
                  //               color: AppColors.neutral100,
                  //             ),
                  //           ),
                  //           const Icon(
                  //             Icons.arrow_drop_down,
                  //             color: AppColors.primaryBlue100,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(width: Window.getHorizontalSize(10)),
                  // Expanded(
                  //   child: TextField(
                  //     onChanged: (value) {
                  //       _cubit.validateTextField(value, length: 10);
                  //     },
                  //     onSubmitted: (value) {
                  //       _cubit.validateTextField(value, length: 10);
                  //     },
                  //     controller: phoneController,
                  //     maxLength: 10,
                  //     decoration: InputDecoration(
                  //       hintText: AppStrings.enterYourPhoneNumber,
                  //       hintStyle: AppTextStyles.bodyRegular
                  //           .copyWith(color: AppColors.neutral50),
                  //       fillColor: AppColors.neutral20,
                  //       filled: true,
                  //       counterText: "",
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius:
                  //             BorderRadius.circular(Window.getRadiusSize(10)),
                  //         borderSide:
                  //             const BorderSide(color: AppColors.primaryBlue100),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius:
                  //             BorderRadius.circular(Window.getRadiusSize(10)),
                  //         borderSide: const BorderSide(
                  //             color: AppColors.primaryBlue100, width: 2),
                  //       ),
                  //     ),
                  //     keyboardType: TextInputType.phone,
                  //   ),
                  // ),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onChanged: (value) {
                        _cubit.validateTextField(value, length: 10);
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: AppColors.neutral20,
                        hintText: AppStrings.enterYourPhoneNumber,
                        hintStyle: AppTextStyles.bodyRegular
                            .copyWith(color: AppColors.neutral50),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Window.getRadiusSize(10)),
                          borderSide:
                              const BorderSide(color: AppColors.primaryBlue100),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Window.getRadiusSize(10)),
                          borderSide:
                              const BorderSide(color: AppColors.primaryBlue100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Window.getRadiusSize(10)),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue100,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<AccountRegistrationCubit>()
                                  .selectCountry(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    countryCode,
                                    style: AppTextStyles.bodyBold.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.primaryBlue100,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: CustomActionButton(
                  onTap: (startLoading, stopLoading, _) {
                    _mobileNumber = phoneController.text.trim();
                    startLoading();
                    if (_isFormValid) {
                      _cubit.sendOtp(countryCode + _mobileNumber).then(
                        (_) {
                          stopLoading();
                        },
                      );
                    } else if (_mobileNumber.isEmpty) {
                      Utils.showCustomDialog(
                        context,
                        AppStrings.error,
                        AppStrings.pleaseEnterAPhoneNumber,
                      );
                      stopLoading();
                    } else {
                      Utils.showCustomDialog(
                        context,
                        AppStrings.error,
                        AppStrings.pleaseEnterAValidPhoneNumber,
                      );
                      stopLoading();
                    }
                  },
                  name: AppStrings.signIn,
                  isFormFilled: _isFormValid,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
