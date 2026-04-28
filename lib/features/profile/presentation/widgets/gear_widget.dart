import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/windows.dart';

class GearWidget extends StatelessWidget {
  const GearWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Static dummy UI list (since no data now)
    final gearList = [
      {
        "title": "Nike Pegasus",
        "type": "Running Shoes",
        "image":
            "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/pegasus.png"
      },
      {
        "title": "Adidas Pro",
        "type": "Training Shoes",
        "image":
            "https://assets.adidas.com/images/pro.png"
      },
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.myGear,
              style: AppTextStyles.subtitleMedium
                  .copyWith(color: AppColors.neutral100),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.allGear);
              },
              child: Text(
                AppStrings.sellAll,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primaryBlue100),
              ),
            ),
          ],
        ),

        SizedBox(height: Window.getVerticalSize(20)),

        /// Gear List
        gearList.isNotEmpty
            ? SizedBox(
                height: Window.getVerticalSize(80),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gearList.length,
                  itemBuilder: (context, index) {
                    final gear = gearList[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: _buildGearItem(
                        title: gear["title"]!,
                        type: gear["type"]!,
                        imagePath: gear["image"]!,
                      ),
                    );
                  },
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.addNewGear);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 60,
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      AppStrings.clickToCreateGear,
                      style: AppTextStyles.bodyBold
                          .copyWith(color: AppColors.neutral60),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildGearItem({
    required String title,
    required String type,
    required String imagePath,
  }) {
    return Container(
      width: Window.getHorizontalSize(300),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
      ),
      child: Padding(
        padding: Window.getPadding(all: 16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),

            SizedBox(width: Window.getHorizontalSize(16)),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.neutral100),
                ),
                SizedBox(height: Window.getVerticalSize(4)),
                Text(
                  type,
                  style: AppTextStyles.captionRegular
                      .copyWith(color: AppColors.neutral60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}