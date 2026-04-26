import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/global_store/data/models/user_data_response_model.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/core/widgets/custom_textfield.dart';
import 'package:athlorun/features/profile/data/models/request/update_user_profile_request_model.dart';
import 'package:athlorun/features/profile/data/models/response/profile_targets_response_model.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/settings/presentation/pages/notification_setting_screen.dart';

class ProfileUpdatePageWrapper extends StatelessWidget {
  final UserData? userData;
  const ProfileUpdatePageWrapper({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: ProfileUpdatePage(userData: userData),
    );
  }
}

class ProfileUpdatePage extends StatefulWidget {
  final UserData? userData;
  const ProfileUpdatePage({super.key, this.userData});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  late final ProfileCubit _cubit;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  String? selectedTarget;
  String? selectedLevel;

  List<Datum> _targets = [];
  final List<String> _level = ["Beginner", "Intermediate", "Advanced"];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProfileCubit>();
    _cubit.getTargets();

    _nameController = TextEditingController(text: widget.userData?.name ?? '');
    _emailController =
        TextEditingController(text: widget.userData?.email ?? '');
    _phoneController =
        TextEditingController(text: widget.userData?.phoneNumber ?? '');
    _genderController = TextEditingController(
        text: widget.userData?.gender.toString().toCapitalized ?? '');
    _heightController =
        TextEditingController(text: widget.userData?.height?.toString() ?? '');
    _weightController =
        TextEditingController(text: widget.userData?.weight?.toString() ?? '');
    _ageController =
        TextEditingController(text: widget.userData?.age?.toString() ?? '');

    selectedLevel =
        _level.contains(widget.userData?.exerciseLevel.toString().toCapitalized)
            ? widget.userData?.exerciseLevel.toString().toCapitalized
            : null;

    // Add listeners to update form state when fields change
    _nameController.addListener(_updateFormStatus);
    _emailController.addListener(_updateFormStatus);
    _phoneController.addListener(_updateFormStatus);
    _genderController.addListener(_updateFormStatus);
    _heightController.addListener(_updateFormStatus);
    _weightController.addListener(_updateFormStatus);
    _ageController.addListener(_updateFormStatus);
  }

  void _updateFormStatus() {
    setState(() {}); // This will trigger UI update for button color
  }

  bool get _isFormFilled =>
      _nameController.text.isNotEmpty &&
      selectedLevel != null &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _genderController.text.isNotEmpty &&
      _heightController.text.isNotEmpty &&
      _weightController.text.isNotEmpty &&
      _ageController.text.isNotEmpty &&
      selectedTarget != null;

  @override
  void dispose() {
    _nameController.removeListener(_updateFormStatus);
    _emailController.removeListener(_updateFormStatus);
    _phoneController.removeListener(_updateFormStatus);
    _genderController.removeListener(_updateFormStatus);
    _heightController.removeListener(_updateFormStatus);
    _weightController.removeListener(_updateFormStatus);
    _ageController.removeListener(_updateFormStatus);

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.editProfile,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.neutral100, // Border color
                        width: 2, // Border width
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.userData?.profilePhoto ?? '',
                        height: Window.getVerticalSize(90),
                        width: Window.getVerticalSize(90),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: Window.getVerticalSize(90),
                          width: Window.getVerticalSize(90),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.neutral20,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.neutral100,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: Window.getVerticalSize(90),
                          width: Window.getVerticalSize(90),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.neutral20,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.neutral100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel(AppStrings.registerNameLabel),
                CustomTextFieldWidget(
                    hintText: AppStrings.registerNameHint,
                    keyboardType: TextInputType.text,
                    controller: _nameController),
                _buildLabel(AppStrings.level),
                _buildLevelDropdown(),
                _buildLabel(AppStrings.registerEmailLabel),
                CustomTextFieldWidget(
                    hintText: AppStrings.registerEmailHint,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController),
                _buildLabel(AppStrings.phoneNumber),
                CustomTextFieldWidget(
                    hintText: AppStrings.enterPhoneNumber,
                    readOnlyBool: true,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController),
                _buildLabel(AppStrings.gender),
                CustomTextFieldWidget(
                    hintText: AppStrings.enterGender,
                    readOnlyBool: true,
                    controller: _genderController),
                _buildLabel(AppStrings.height),
                CustomTextFieldWidget(
                    hintText: AppStrings.enterheight,
                    keyboardType: TextInputType.number,
                    controller: _heightController),
                _buildLabel(AppStrings.weight),
                CustomTextFieldWidget(
                    hintText: AppStrings.enterWeight,
                    keyboardType: TextInputType.number,
                    controller: _weightController),
                _buildLabel(AppStrings.age),
                CustomTextFieldWidget(
                    keyboardType: TextInputType.number,
                    hintText: AppStrings.enterAge,
                    controller: _ageController),
                _buildLabel(AppStrings.target),
                BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      updatingUserProfile: () {},
                      updatedUserProfile: (response) {
                        Navigator.pop(context, true);
                      },
                      updateUserProfileError: (error) {
                        Utils.showCustomDialog(
                            context, AppStrings.error, error.toString());
                      },
                      loadedTargets: (targets) {
                        setState(() {
                          // Remove duplicates by converting to a Set and back to a List
                          _targets = targets.data?.toSet().toList() ?? [];

                          // Ensure selectedTarget is valid
                          final validTarget = _targets.firstWhere(
                            (t) => t.name == widget.userData?.target,
                            orElse: () => _targets.isNotEmpty
                                ? _targets.first
                                : Datum(name: ""),
                          );

                          selectedTarget = validTarget.name;
                        });
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    if (_targets.isEmpty) {
                      return const Text("No targets available");
                    }
                    return _buildTargetDropdown(_targets);
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomActionButton(
                        name: AppStrings.updateProfile,
                        onTap: (startLoading, stopLoading, btnState) {
                          _cubit.assignLoadingFunction(
                              startLoading, stopLoading);
                          if (_isFormFilled) {
                            final userProfileUpdate =
                                UpdateUserProfileRequestModel(
                              name: _nameController.text,
                              exerciseLevel:
                                  selectedLevel.toString().toLowerCase(),
                              email: _emailController.text,
                              height: _heightController.text,
                              weight: _weightController.text,
                              age: int.tryParse(_ageController.text),
                              target: selectedTarget,
                            );
                            _cubit.startLoading();

                            _cubit.updateUserProfileData(userProfileUpdate);
                          } else {
                            Utils.showCustomDialog(context, AppStrings.error,
                                AppStrings.pleaseFillAllTheFields);
                          }
                        },
                        isFormFilled: _isFormFilled,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: AppTextStyles.subtitleMedium.copyWith(
          color: AppColors.neutral100,
          fontSize: Window.getFontSize(14),
        ),
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton2<String>(
        dropdownStyleData: DropdownStyleData(
          maxHeight: Window.getVerticalSize(350),
          elevation: 0,
          decoration: BoxDecoration(
            color: AppColors.neutral10,
            border: Border.all(color: AppColors.neutral100, width: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        hint: const Text("Select Level"),
        value: selectedLevel,
        items: _level
            .map(
              (level) => DropdownMenuItem<String>(
                value: level,
                child: Text(
                  level,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral100,
                    fontSize: Window.getFontSize(14),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedLevel = value;
          });
        },
        underline: Container(),
        isExpanded: true,
      ),
    );
  }

  Widget _buildTargetDropdown(List<Datum> targetData) {
    final validTargetNames = _targets.map((e) => e.name).toSet();

    if (!validTargetNames.contains(selectedTarget)) {
      selectedTarget = null;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton2<String>(
        dropdownStyleData: DropdownStyleData(
          maxHeight: Window.getVerticalSize(350),
          elevation: 0,
          decoration: BoxDecoration(
            color: AppColors.neutral10,
            border: Border.all(color: AppColors.neutral100, width: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        hint: const Text("Select Target"),
        value: selectedTarget,
        items: validTargetNames
            .map(
              (name) => DropdownMenuItem<String>(
                value: name,
                child: Text(
                  name.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral100,
                    fontSize: Window.getFontSize(14),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedTarget = value;
          });
        },
        underline: Container(),
        isExpanded: true,
      ),
    );
  }
}
