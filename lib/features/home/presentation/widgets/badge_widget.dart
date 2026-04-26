import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../pages/badge_screen.dart';
import '../pages/health_page.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add the Section Header
        _buildSectionHeader('Badges (9)', () {
          print("See all tapped");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BadgesScreen()),
          );
        }),
        _buildBadgeGrid(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.subtitleMedium
              .copyWith(color: AppColors.neutral100), // Custom text style
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "See all",
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.primaryBlue90), // Custom text style
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeGrid() {
    List<Map<String, String>> badges = [
      {
        "imagePath": "assets/badges/badge1.png",
        "label": "Dec Run 100K Challenge",
        "points": "100K"
      },
      {
        "imagePath": "assets/badges/badge2.png",
        "label": "Dec Cycling 5K Challenge",
        "points": "5K"
      },
      {
        "imagePath": "assets/badges/badge3.png",
        "label": "Nov Climbing Challenge",
        "points": ""
      },
      {
        "imagePath": "assets/badges/badge4.png",
        "label": "Nov Climbing Challenge",
        "points": ""
      },
      {
        "imagePath": "assets/badges/badge5.png",
        "label": "Oct Workout Challenge",
        "points": ""
      },
      {
        "imagePath": "assets/badges/badge6.png",
        "label": "Dec Run Climbing",
        "points": ""
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: Window.getVerticalSize(16), // Responsive spacing
        crossAxisSpacing: Window.getHorizontalSize(12), // Responsive spacing
        childAspectRatio: 0.7,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        return _buildBadgeItem(
          badges[index]['imagePath']!,
          badges[index]['label']!,
          badges[index]['points']!,
        );
      },
    );
  }

  Widget _buildBadgeItem(String imagePath, String label, String points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            // Image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  Window.getRadiusSize(16)), // Responsive radius
              child: Image.asset(
                imagePath,
                height: Window.getVerticalSize(100), // Responsive height
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Points Container (if points are provided)
            if (points.isNotEmpty)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Window.getRadiusSize(13)),
                    bottomRight: Radius.circular(Window.getRadiusSize(13)),
                  ),
                  child: Container(
                    color: AppColors.primaryBlue90
                        .withOpacity(0.8), // Custom semi-transparent color
                    padding: Window.getSymmetricPadding(
                        vertical: 4), // Responsive padding
                    alignment: Alignment.center,
                    child: Text(
                      points,
                      style: AppTextStyles.captionBold.copyWith(
                          color: AppColors.neutral10), // Custom text style
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: Window.getVerticalSize(8)), // Responsive spacing

        // Label Text with ellipsis for overflow and two-line wrapping
        SizedBox(
          width: Window.getHorizontalSize(100), // Responsive width
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyBold
                .copyWith(color: AppColors.neutral100), // Custom text style
          ),
        ),
      ],
    );
  }
}
