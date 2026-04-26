import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:shimmer/shimmer.dart';

class ScheduleWidgetSkeleton extends StatelessWidget {
  const ScheduleWidgetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutral20,
      highlightColor: AppColors.neutral30,
      child: Container(
        width: Window.getHorizontalSize(300),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral30),
          borderRadius: BorderRadius.circular(Window.getRadiusSize(10)),
        ),
        child: Padding(
          padding: Window.getPadding(all: 16.0),
          child: Row(
            children: [
              // Circular Skeleton for Image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: Window.getHorizontalSize(16)),

              // Skeleton for Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title Skeleton
                  Container(
                    width: Window.getHorizontalSize(120),
                    height: Window.getVerticalSize(16),
                    color: Colors.white,
                  ),
                  SizedBox(height: Window.getVerticalSize(4)),

                  // Type Skeleton
                  Container(
                    width: Window.getHorizontalSize(80),
                    height: Window.getVerticalSize(12),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
