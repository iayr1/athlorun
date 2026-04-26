import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../config/styles/app_colors.dart';
import '../../../../../config/styles/app_textstyles.dart';
import '../utils/windows.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final bool? readOnlyBool;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator; // Validator property
  final List<TextInputFormatter>? inputFormatters; // Input formatters property

  const CustomTextFieldWidget({
    Key? key,
    this.labelText,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.readOnlyBool,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnlyBool ?? false,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: AppTextStyles.bodyRegular.copyWith(
        fontSize: Window.getFontSize(14),
        color: AppColors.neutral100,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: Window.getFontSize(14),
          color: AppColors.neutral70,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.bodyRegular.copyWith(
          fontSize: Window.getFontSize(14),
          color: AppColors.neutral70,
        ),
        filled: true,
        fillColor:
            readOnlyBool == true ? AppColors.neutral20 : AppColors.neutral20,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Window.getRadiusSize(10)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: readOnlyBool == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(Window.getRadiusSize(10)),
                borderSide: BorderSide.none)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(Window.getRadiusSize(10)),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue100,
                  width: 2,
                ),
              ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Window.getRadiusSize(10)),
          borderSide: BorderSide(
              color: readOnlyBool == true
                  ? AppColors.neutral20
                  : AppColors.neutral20),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
