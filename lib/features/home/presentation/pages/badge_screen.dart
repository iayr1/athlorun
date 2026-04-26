import 'package:flutter/material.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy badge data
    final List<Map<String, String>> badges = [
      {"title": "Dec Run 100k Challenge", "image": "assets/badges/badge1.png"},
      {
        "title": "Dec Cycling 5K Challenge",
        "image": "assets/badges/badge2.png"
      },
      {"title": "Nov Climbing Challenge", "image": "assets/badges/badge3.png"},
      {"title": "Oct Workout Challenge", "image": "assets/badges/badge4.png"},
      {"title": "Dec Run Climbing", "image": "assets/badges/badge5.png"},
      {"title": "FitFrenzy Challenge", "image": "assets/badges/badge6.png"},
      {"title": "Rapid Racer Run", "image": "assets/badges/badge7.png"},
    ];

    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: customAppBar(
        title: AppStrings.badges,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: Window.getPadding(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge Grid
            Expanded(
              child: GridView.builder(
                itemCount: badges.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of badges per row
                  crossAxisSpacing: Window.getHorizontalSize(16),
                  mainAxisSpacing: Window.getVerticalSize(20),
                  childAspectRatio:
                      0.6, // Adjust aspect ratio for image and text
                ),
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  return Column(
                    children: [
                      // Badge Image
                      Container(
                        height: Window.getSize(100),
                        width: Window.getSize(100),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Window.getRadiusSize(12)),
                          image: DecorationImage(
                            image: AssetImage(badge["image"]!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neutral40.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Window.getVerticalSize(8)),

                      // Badge Title
                      Text(
                        badge["title"]!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: Window.getFontSize(12),
                          color: AppColors.neutral100,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
