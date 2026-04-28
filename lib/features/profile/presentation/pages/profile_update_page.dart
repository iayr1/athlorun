import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_action_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedLevel;
  String? selectedTarget;

  final List<String> levels = ["Beginner", "Intermediate", "Advanced"];
  final List<String> targets = ["Lose Weight", "Stay Fit", "Build Muscle"];

  bool get isFormFilled =>
      nameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      phoneController.text.isNotEmpty &&
      genderController.text.isNotEmpty &&
      heightController.text.isNotEmpty &&
      weightController.text.isNotEmpty &&
      ageController.text.isNotEmpty &&
      selectedLevel != null &&
      selectedTarget != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: AppBar(
        title: Text(AppStrings.editProfile),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Profile Image
                const SizedBox(height: 20),
                const Center(
                  child: CircleAvatar(
                    radius: 45,
                    child: Icon(Icons.person, size: 40),
                  ),
                ),

                /// Fields
                _label("Name"),
                CustomTextFieldWidget(
                  hintText: "Enter name",
                  controller: nameController,
                ),

                _label("Level"),
                _dropdown(levels, selectedLevel, (val) {
                  setState(() => selectedLevel = val);
                }),

                _label("Email"),
                CustomTextFieldWidget(
                  hintText: "Enter email",
                  controller: emailController,
                ),

                _label("Phone"),
                CustomTextFieldWidget(
                  hintText: "Enter phone",
                  controller: phoneController,
                ),

                _label("Gender"),
                CustomTextFieldWidget(
                  hintText: "Enter gender",
                  controller: genderController,
                ),

                _label("Height"),
                CustomTextFieldWidget(
                  hintText: "Enter height",
                  controller: heightController,
                ),

                _label("Weight"),
                CustomTextFieldWidget(
                  hintText: "Enter weight",
                  controller: weightController,
                ),

                _label("Age"),
                CustomTextFieldWidget(
                  hintText: "Enter age",
                  controller: ageController,
                ),

                _label("Target"),
                _dropdown(targets, selectedTarget, (val) {
                  setState(() => selectedTarget = val);
                }),

                const SizedBox(height: 30),

                /// Button
                CustomActionButton(
                  name: "Update Profile",
                  isFormFilled: isFormFilled,
                  onTap: (start, stop, state) {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        text,
        style: AppTextStyles.subtitleMedium.copyWith(
          color: AppColors.neutral100,
        ),
      ),
    );
  }

  Widget _dropdown(
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton2<String>(
        value: value,
        isExpanded: true,
        hint: const Text("Select"),
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}