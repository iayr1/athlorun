import 'package:flutter/material.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:shimmer/shimmer.dart';

class CustomProfileWidgetSkeleton extends StatelessWidget {
  const CustomProfileWidgetSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: Window.getVerticalSize(80),
                width: Window.getVerticalSize(80),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: Window.getHorizontalSize(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBar(width: 150),
                    const SizedBox(height: 8),
                    _buildShimmerBar(width: 100),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildShimmerBar(width: 200),
          const SizedBox(height: 10),
          _buildShimmerList(),
        ],
      ),
    );
  }

  Widget _buildShimmerBar({double width = double.infinity}) {
    return Container(
      height: 12,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: _buildShimmerBar(width: double.infinity),
        ),
      ),
    );
  }
}
