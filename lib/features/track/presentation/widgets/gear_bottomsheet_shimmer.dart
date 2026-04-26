import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:shimmer/shimmer.dart';

class GearBottomSheetShimmer extends StatelessWidget {
  const GearBottomSheetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header shimmer (My Gear + See All)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 100, height: 18),
              _shimmerBox(width: 60, height: 16),
            ],
          ),
        ),
        // Gear list shimmer
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: AppColors.neutral20,
                highlightColor: AppColors.neutral30,
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.neutral30, width: 1.2),
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(16)),
                  ),
                  padding: Window.getPadding(all: 16),
                  child: Row(
                    children: [
                      // Circular image shimmer
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text placeholders
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(width: 120, height: 14),
                            const SizedBox(height: 8),
                            _shimmerBox(width: 80, height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _shimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
