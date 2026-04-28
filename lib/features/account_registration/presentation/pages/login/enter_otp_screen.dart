import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:telephony/telephony.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../../../../../core/utils/windows.dart';
import '../../../../../core/widgets/custom_action_button.dart';
import '../../../../../core/widgets/custom_appbar.dart';

class EnterOTPScreenWrapper extends StatelessWidget {
  const EnterOTPScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const EnterOTPScreen(),
    );
  }
}

class EnterOTPScreen extends StatefulWidget {
  const EnterOTPScreen({super.key});

  @override
  State<EnterOTPScreen> createState() => _EnterOTPScreenState();
}

class _EnterOTPScreenState extends State<EnterOTPScreen> {
  final OtpFieldController otpController = OtpFieldController();
  final Telephony telephony = Telephony.instance;

  late String otpValue;
  bool isOtpComplete = false;
  late Timer _timer;
  int _timeRemaining = 120;
  bool _canResend = false;
  late final AccountRegistrationCubit _cubit;
  late String mobileNumber;
  bool _debugOtpHintShown = false;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    super.initState();
    requestSmsPermissions();
    if (Platform.isAndroid) {
      listenForIncomingSms();
    }
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// Request SMS Permissions
  Future<void> requestSmsPermissions() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "SMS permissions are required to autofill the OTP.",
            style:
                AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral10),
          ),
          backgroundColor: AppColors.primaryBlue100,
        ),
      );
    }
  }

  /// Listen for Incoming SMS
  void listenForIncomingSms() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // Extract OTP and autofill
        final extractedOtp = extractOtp(message.body ?? "");
        if (extractedOtp.isNotEmpty) {
          setState(() {
            otpValue = extractedOtp;
            otpController.set(extractedOtp.split('')); // Autofill the OTP field
            isOtpComplete = true;
          });
        }
      },
      listenInBackground: false,
    );
  }

  /// Extract the OTP from the SMS using regex
  String extractOtp(String sms) {
    final RegExp otpRegex = RegExp(r'\b\d{4}\b'); // Match exactly 4 digits
    final Match? match = otpRegex.firstMatch(sms);
    return match?.group(0) ?? "";
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void resendCode() {
    if (_timer.isActive) _timer.cancel();
    setState(() {
      _canResend = false;
      _timeRemaining = 120;
      otpValue = "1234";
      otpController.set(otpValue.split(""));
      isOtpComplete = true;
    });
    startTimer();
  }

  String? _extractOtpFromHint(String? hint) {
    if (hint == null || hint.isEmpty) return null;
    final match = RegExp(r'\b\d{4}\b').firstMatch(hint);
    return match?.group(0);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
    mobileNumber = args['mobileNumber']?.toString() ?? '';
    final otpHint = args['otpHint']?.toString();

    if (!_debugOtpHintShown && otpHint != null && otpHint.isNotEmpty) {
      _debugOtpHintShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Utils.showCustomDialog(
          context,
          AppStrings.verificationCode,
          otpHint,
        );
      });
    }

    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.verificationCode,
        backgroundColor: AppColors.neutral10,
        onBackPressed: () => Navigator.pop(context),
      ),
      backgroundColor: AppColors.neutral10,
      body: BlocConsumer<AccountRegistrationCubit, AccountRegistrationState>(
        listener: (context, state) {
          state.maybeWhen(
            loadedUserData: (authData, userData) {
              if (userData.name == null || userData.name == "") {
                UserDataProgressModel progressData = UserDataProgressModel();
                if (userData.profilePhoto != null &&
                    userData.profilePhoto != "") {
                  progressData.profilePhoto = userData.profilePhoto;
                }
                Navigator.pushNamed(
                  context,
                  AppRoutes.setupNameEmailScreen,
                  arguments: progressData,
                );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboardScreen,
                  (routes) => false,
                );
              }
            },
            loadUserDataError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            sendOtpError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            sentOtp: (response) {
              final otpHint = response.data?.message;
              final resentOtp = _extractOtpFromHint(otpHint);

              if (_timer.isActive) {
                _timer.cancel();
              }

              setState(() {
                _canResend = false;
                _timeRemaining = 120;
                if (resentOtp != null) {
                  otpValue = resentOtp;
                  otpController.set(resentOtp.split(''));
                  isOtpComplete = true;
                }
              });
              startTimer();

              Utils.showCustomDialog(
                context,
                AppStrings.codeResend,
                otpHint?.isNotEmpty == true
                    ? otpHint
                    : AppStrings.verificationCodeReset,
              );
            },
            setAuthData: (authData) {
              _cubit.getUserData(authData);
            },
            setAuthDataError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            verifiedOtp: (response) {
              final authData = response.data;

              if (authData?.id == null ||
                  authData?.accessToken == null ||
                  authData?.refreshToken == null) {
                Utils.showCustomDialog(
                  context,
                  AppStrings.error,
                  AppStrings.somethingWentWrong,
                );
                return;
              }

              _cubit.setAuthData(
                authData!.id!,
                authData.accessToken!,
                authData.refreshToken!,
              );
            },
            verifyOtpError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            orElse: () {},
          );
        },
        builder: (context, snapshot) {
          return Padding(
            padding: Window.getPadding(all: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Window.getVerticalSize(20)),
                Text(
                  AppStrings.enterTheVerificationCodeWeSentTo,
                  style: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.neutral60),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Window.getVerticalSize(5)),
                Text(
                  mobileNumber,
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.neutral100),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Window.getVerticalSize(30)),
                OTPTextField(
                  controller: otpController,
                  length: 4,
                  width: Window.width / 1.5,
                  fieldWidth: Window.getHorizontalSize(50),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: Window.getRadiusSize(10),
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 18),
                  onChanged: (pin) {
                    setState(() {
                      otpValue = pin;
                      isOtpComplete = pin.length == 4;
                    });
                  },
                  onCompleted: (pin) {
                    setState(() {
                      otpValue = pin;
                      isOtpComplete = true;
                    });
                  },
                ),
                SizedBox(height: Window.getVerticalSize(20)),
                if (_canResend)
                  GestureDetector(
                    onTap: resendCode,
                    child: Text(
                      "Didn't get the code? Resend",
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primaryBlue100,
                      ),
                    ),
                  )
                else
                  Text(
                    "Resend available in ${formatTime(_timeRemaining)}",
                    style: AppTextStyles.bodyRegular
                        .copyWith(color: AppColors.neutral60),
                  ),
                const Spacer(),
                CustomActionButton(
                  name: "Submit",
                  onTap: (startLoading, stopLoading, btnState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.navigateScreen,
                      (routes) => false,
                    );
                  },
                  isFormFilled: isOtpComplete,
                  isError: !isOtpComplete,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
