import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../core/utils/windows.dart';

class RecordedVideoScreen extends StatelessWidget {
  // Sample data for recorded videos
  final List<Map<String, String>> videos = [
    {
      "title": "Podcast Episode 1",
      "description": "Discussing the latest trends in sports.",
      "thumbnail": "assets/123.png", // Local asset path
    },
    {
      "title": "Podcast Episode 2",
      "description": "Insights from industry leaders.",
      "thumbnail": "assets/123.png", // Local asset path
    },
    {
      "title": "Podcast Episode 3",
      "description": "The story behind success.",
      "thumbnail": "assets/123.png", // Local asset path
    },
    {
      "title": "Podcast Episode 4",
      "description": "Tips for beginners in sports.",
      "thumbnail": "assets/123.png", // Local asset path
    },
  ];

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(view: View.of(context)); // Initialize Window

    return Scaffold(
      backgroundColor: AppColors.neutral30, // Light background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header
          Padding(
            padding: Window.getPadding(top: 50, left: 20, bottom: 20),
            child: Text(
              "Recorded Videos",
              style: AppTextStyles.heading4Bold.copyWith(
                color: AppColors.neutral80,
              ),
            ),
          ),

          // List of Recorded Videos
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return GestureDetector(
                  onTap: () {
                    // Action to play video
                    print("Playing video: ${video['title']}");
                  },
                  child: Container(
                    margin: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
                    padding: Window.getPadding(all: 16),
                    decoration: BoxDecoration(
                      color: AppColors.neutral10,
                      borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neutral60.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Video Thumbnail from Assets
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
                          child: Image.asset(
                            video["thumbnail"]!,
                            height: Window.getVerticalSize(70),
                            width: Window.getHorizontalSize(100),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: Window.getHorizontalSize(16)),

                        // Video Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video["title"]!,
                                style: AppTextStyles.bodySemiBold.copyWith(
                                  color: AppColors.neutral80,
                                  fontSize: Window.getFontSize(16),
                                ),
                              ),
                              SizedBox(height: Window.getVerticalSize(8)),
                              Text(
                                video["description"]!,
                                style: AppTextStyles.bodyRegular.copyWith(
                                  color: AppColors.neutral60,
                                  fontSize: Window.getFontSize(14),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Play Button
                        Icon(
                          Icons.play_circle_fill,
                          color: AppColors.primaryBlue100,
                          size: Window.getFontSize(36),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
