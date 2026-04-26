import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/images/app_images.dart';
import 'package:athlorun/config/routes/routes.dart';
import 'package:athlorun/core/global_store/data/models/user_data_progress_model.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/features/account_registration/presentation/bloc/account_registration_cubit.dart';
import 'dart:io';
import '../../../../../core/utils/windows.dart';
import '../../../../../core/widgets/linear_progress_indicator.dart';
import 'package:athlorun/core/widgets/back_button_widget.dart';
import 'package:athlorun/core/widgets/next_button_widget.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';

class SetupProfilePhotoScreenWrapper extends StatelessWidget {
  const SetupProfilePhotoScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountRegistrationCubit>(),
      child: const SetupProfilePhotoScreen(),
    );
  }
}

class SetupProfilePhotoScreen extends StatefulWidget {
  const SetupProfilePhotoScreen({super.key});

  @override
  State<SetupProfilePhotoScreen> createState() => _PhotoProfileScreenState();
}

class _PhotoProfileScreenState extends State<SetupProfilePhotoScreen> {
  File? _profileImage;
  late final AccountRegistrationCubit _cubit;
  bool _showUploadedImage = false;
  late UserDataProgressModel _userDataProgressModel;

  @override
  void initState() {
    _cubit = context.read<AccountRegistrationCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userDataProgressModel.profilePhoto != null &&
          _userDataProgressModel.profilePhoto != "") {
        _showUploadedImage = true;
        _cubit.updateState();
      }
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
        body: BlocConsumer<AccountRegistrationCubit, AccountRegistrationState>(
          listener: (context, state) {
            state.maybeWhen(
              loadedUserData: (authData, userData) {
                _userDataProgressModel.phoneNumber = userData.phoneNumber ?? "";
                _cubit.patchUserData(
                    authData.id, authData.accessToken, _userDataProgressModel);
                _cubit.uploadSelfie(authData.id, _profileImage!);
              },
              loadUserDataError: (error) {
                Utils.showCustomDialog(context, AppStrings.error, error);
              },
              patchedUserData: (userData) {
                _cubit.setUserDataProgreessModel(_userDataProgressModel);
              },
              patchUserDataError: (error) {
                Utils.showCustomDialog(context, AppStrings.error, error);
              },
              uploadedSelfie: (response) {
                _userDataProgressModel.profilePhoto =
                    response.data?.profilePhoto ?? "";
                _cubit.setUserDataProgreessModel(_userDataProgressModel);
              },
              uploadSelfieError: (error) {
                Utils.showCustomDialog(context, AppStrings.error, error);
              },
              gotAuthData: (authData) {
                _cubit.getUserData(authData);
              },
              getAuthDataError: (error) {
                Utils.showCustomDialog(context, AppStrings.error, error);
              },
              setUserProgressData: (progressData) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboardScreen,
                  (route) => false,
                );
              },
              setUserProgressDataError: (error) {
                Utils.showCustomDialog(context, AppStrings.error, error);
              },
              orElse: () {},
            );
          },
          builder: (context, snapshot) {
            return Padding(
              padding: Window.getSymmetricPadding(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Window.getVerticalSize(50)),
                  const ProgressBarWidget(
                      currentScreen: 8, totalScreens: 8, stepText: "8 - 8"),
                  SizedBox(height: Window.getVerticalSize(30)),
                  Center(
                    child: Text(
                      "Add your photo profile",
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
                      "By adding a photo to your profile, other users can easily find you.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitleRegular.copyWith(
                        fontSize: Window.getFontSize(16),
                        color: AppColors.neutral70,
                      ),
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(50)),
                  GestureDetector(
                    onTap: () {
                      _showImagePickerBottomSheet(context);
                    },
                    child: Center(
                        child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _showUploadedImage
                            ? CircleAvatar(
                                radius: Window.getHorizontalSize(100),
                                backgroundColor: AppColors.primaryBlue30,
                                backgroundImage: NetworkImage(
                                    _userDataProgressModel.profilePhoto ?? ""),
                              )
                            : CircleAvatar(
                                radius: Window.getHorizontalSize(100),
                                backgroundColor: AppColors.primaryBlue10,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? CircleAvatar(
                                        radius: Window.getHorizontalSize(
                                          85,
                                        ),
                                        backgroundColor: AppColors.primaryBlue50
                                            .withOpacity(.4),
                                        child: SvgPicture.asset(
                                          AppImages.profileCamera,
                                          width: Window.getFontSize(60),
                                          color: AppColors.primaryBlue100,
                                        ),
                                      )
                                    : null,
                              ),
                        if (_showUploadedImage || _profileImage != null)
                          Positioned(
                            bottom: 18,
                            right: 18,
                            child: GestureDetector(
                              onTap: () => _showImagePickerBottomSheet(context),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryBlue100,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                  SizedBox(height: Window.getVerticalSize(20)),
                  Center(
                    child: Text(
                      _userDataProgressModel.name ?? "",
                      style: AppTextStyles.bodyBold.copyWith(
                        fontSize: Window.getFontSize(18),
                        color: AppColors.neutral100,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonWidget(onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.setupActivityScreen,
                          (routes) => false,
                          arguments: _userDataProgressModel,
                        );
                      }),
                      NextButtonWidget(
                        text: "Let's Start",
                        onPressed: () {
                          // if (_showUploadedImage) {
                          //   Navigator.pushNamedAndRemoveUntil(
                          //     context,
                          //     AppRoutes.setupReminderScreen,
                          //     (routes) => false,
                          //     arguments: _userDataProgressModel,
                          //   );
                          // } else {
                          //   _cubit.getAuthData();
                          // }
                          _cubit.getAuthData();
                        },
                        isEnabled: _profileImage != null || _showUploadedImage,
                      ),
                    ],
                  ),
                  SizedBox(height: Window.getVerticalSize(20)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.neutral10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(Window.getRadiusSize(15))),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: Window.getVerticalSize(10)),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.neutral30,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt,
                      color: AppColors.primaryBlue100),
                  title: Text(
                    "Take a Picture",
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library,
                      color: AppColors.primaryBlue100),
                  title: Text(
                    "Choose from Gallery",
                    style: AppTextStyles.bodyRegular.copyWith(
                      color: AppColors.neutral100,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        File image = File(pickedFile.path.replaceFirst('file://', ''));
        setState(() {
          _profileImage = image;
          _showUploadedImage = false;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }
}
