import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          // Navigate to the search screen when tapped
          Navigator.pushNamed(
              context,
              AppRoutes.search); // Replace with your AppRoutes.search if needed
        },
        child: AbsorbPointer(
          // Prevent interaction with the TextField in the current screen
          child: TextField(
            style: AppTextStyles.bodyRegular
                .copyWith(color: AppColors.neutral100), // Use custom text style
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: AppTextStyles.bodyRegular.copyWith(
                  color: AppColors.neutral50), // Custom hint text style
              prefixIcon: const Icon(Icons.search, color: AppColors.neutral100),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    Window.getRadiusSize(10)), // Use responsive radius
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.neutral20, // Use color from AppColors
              contentPadding:
                  Window.getMarginOrPadding(all: 12), // Add responsive padding
            ),
          ),
        ),
      ),
    );
  }
}
