import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:shimmer/shimmer.dart';

class ChallengeShimmer extends StatelessWidget {
  const ChallengeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: Window.getPadding(all: 16.0),
      itemCount: 5, // Show 5 shimmer items during loading
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: Window.getHorizontalSize(12)),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: Window.getHorizontalSize(220),
              margin: EdgeInsets.only(right: Window.getHorizontalSize(12)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
                color: Colors.white, // Shimmer placeholder color
              ),
              padding: EdgeInsets.all(Window.getSize(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: Window.getSize(70),
                    width: Window.getSize(70),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(12)),
                  Container(
                    height: Window.getVerticalSize(16),
                    width: Window.getHorizontalSize(120),
                    color: Colors.white,
                  ),
                  SizedBox(height: Window.getVerticalSize(6)),
                  Container(
                    height: Window.getVerticalSize(14),
                    width: Window.getHorizontalSize(100),
                    color: Colors.white,
                  ),
                  SizedBox(height: Window.getVerticalSize(6)),
                  Container(
                    height: Window.getVerticalSize(14),
                    width: Window.getHorizontalSize(100),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChallengeItemShimmer extends StatelessWidget {
  const ChallengeItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutral10,
      highlightColor: Colors.grey[300]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: Window.getPadding(all: 16),
        decoration: BoxDecoration(
          color: AppColors.neutral10,
          borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral100.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
              child: Container(
                width: Window.getHorizontalSize(100),
                height: Window.getVerticalSize(100),
                color: Colors.white,
              ),
            ),
            SizedBox(width: Window.getHorizontalSize(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    height: Window.getVerticalSize(16),
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: Window.getVerticalSize(8)),
                  // Date placeholder
                  Container(
                    height: Window.getVerticalSize(14),
                    width: Window.getHorizontalSize(150),
                    color: Colors.white,
                  ),
                  SizedBox(height: Window.getVerticalSize(4)),
                  // Description placeholder
                  Container(
                    height: Window.getVerticalSize(14),
                    width: Window.getHorizontalSize(180),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveCardShimmer extends StatelessWidget {
  const LeaveCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Window.getSymmetricPadding(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: Window.getHorizontalSize(150),
          height: Window.getVerticalSize(250),
          margin: Window.getMargin(right: 12),
          decoration: BoxDecoration(
            color: AppColors.neutral10,
            borderRadius: BorderRadius.circular(Window.getRadiusSize(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(-2, -2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.neutral10.withOpacity(0.9),
                AppColors.neutral10,
                AppColors.neutral10.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for Image Container
              Padding(
                padding: Window.getPadding(all: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
                  child: Container(
                    height: Window.getVerticalSize(70),
                    width: Window.getVerticalSize(70),
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(height: Window.getVerticalSize(8)),

              // Shimmer for Challenge Title
              Padding(
                padding: Window.getSymmetricPadding(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  height: Window.getVerticalSize(16),
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: Window.getVerticalSize(8)),

              // Shimmer for Date Range
              Padding(
                padding: Window.getSymmetricPadding(horizontal: 8),
                child: Container(
                  width: Window.getHorizontalSize(100),
                  height: Window.getVerticalSize(14),
                  color: Colors.grey[400],
                ),
              ),
              const Spacer(),

              // Shimmer for Join Button
              Padding(
                padding: Window.getPadding(all: 8),
                child: Container(
                  width: double.infinity,
                  height: Window.getVerticalSize(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
