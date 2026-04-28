import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/app_strings.dart';

class GearSelectionBottomSheet extends StatelessWidget {
  final List<Map<String, String>> gearList;

  const GearSelectionBottomSheet({
    super.key,
    required this.gearList,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.myGear,
                  style: AppTextStyles.heading5Bold,
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: gearList.isNotEmpty
                      ? ListView.builder(
                          controller: controller,
                          itemCount: gearList.length,
                          itemBuilder: (context, index) {
                            final gear = gearList[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context, gear);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _gearItem(
                                  title: gear["title"] ?? "",
                                  type: gear["type"] ?? "",
                                  imagePath: gear["image"] ?? "",
                                ),
                              ),
                            );
                          },
                        )
                      : const _EmptyGearState(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gearItem({
    required String title,
    required String type,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral30),
        borderRadius: BorderRadius.circular(16),
      ),
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

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.neutral100),
              ),
              const SizedBox(height: 4),
              Text(
                type,
                style: AppTextStyles.captionRegular
                    .copyWith(color: AppColors.neutral60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyGearState extends StatelessWidget {
  const _EmptyGearState();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.addNewGear);
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline,
                size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text(
              AppStrings.clickToCreateGear,
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.neutral60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}