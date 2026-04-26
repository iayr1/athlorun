import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';

void showDetailsBottomSheet(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedState;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.neutral10,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StatefulBuilder(
          builder: (context, setState) {
            final bool isFormFilled = nameController.text.isNotEmpty &&
                emailController.text.isNotEmpty &&
                selectedState != null;

            return Padding(
              padding: Window.getPadding(all: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Your details", style: AppTextStyles.subtitleBold),

                  SizedBox(height: Window.getVerticalSize(20)),

                  /// Name Input
                  TextField(
                    controller: nameController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: "Enter name *",
                      labelStyle: AppTextStyles.bodyRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(16)),

                  /// Phone (read-only)
                  Row(
                    children: [
                      Container(
                        padding: Window.getSymmetricPadding(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.neutral40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text("+91", style: AppTextStyles.bodyBold),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: "9876543210"),
                          enabled: false,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.neutral20,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Window.getVerticalSize(6)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ⓘ The phone number associated with your account cannot be modified",
                      style: AppTextStyles.captionRegular
                          .copyWith(color: AppColors.neutral60),
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(16)),

                  /// Email Input
                  TextField(
                    controller: emailController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: "Email address *",
                      labelStyle: AppTextStyles.bodyRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(6)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ⓘ Email ID is required to send tickets and updates",
                      style: AppTextStyles.captionRegular
                          .copyWith(color: AppColors.neutral60),
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(16)),

                  /// State Dropdown
                  DropdownButtonFormField<String>(
                    dropdownColor: AppColors.neutral10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Select state",
                      labelStyle: AppTextStyles.bodyRegular,
                    ),
                    value: selectedState,
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                      });
                    },
                    items: [
                      "Andhra Pradesh",
                      "Arunachal Pradesh",
                      "Assam",
                      "Bihar",
                      "Chhattisgarh",
                      "Goa",
                      "Gujarat",
                      "Haryana",
                      "Himachal Pradesh",
                      "Jharkhand",
                      "Karnataka",
                      "Kerala",
                      "Madhya Pradesh",
                      "Maharashtra",
                      "Manipur",
                      "Meghalaya",
                      "Mizoram",
                      "Nagaland",
                      "Odisha",
                      "Punjab",
                      "Rajasthan",
                      "Sikkim",
                      "Tamil Nadu",
                      "Telangana",
                      "Tripura",
                      "Uttar Pradesh",
                      "Uttarakhand",
                      "West Bengal",
                      "Andaman and Nicobar Islands",
                      "Chandigarh",
                      "Dadra and Nagar Haveli and Daman and Diu",
                      "Delhi",
                      "Jammu and Kashmir",
                      "Ladakh",
                      "Lakshadweep",
                      "Puducherry",
                    ].map((state) {
                      return DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: Window.getVerticalSize(6)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ⓘ State is required to generate your invoice",
                      style: AppTextStyles.captionRegular
                          .copyWith(color: AppColors.neutral60),
                    ),
                  ),

                  SizedBox(height: Window.getVerticalSize(24)),

                  /// Confirm Button
                  CustomActionButton(
                    name: "Confirm",
                    isFormFilled: isFormFilled,
                    onTap: (startLoading, stopLoading, btnState) {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
