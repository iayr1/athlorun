import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class ProfilePodcastPage extends StatelessWidget {
  // Sample user data
  final Map<String, String> userData = {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "profilePic": "assets/profile/profile1.png", // Replace with your local asset
  };

  // Sample watch history
  final List<Map<String, String>> watchHistory = [
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
  ];

  // Sample downloaded podcasts
  final List<Map<String, String>> downloadedPodcasts = [
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
      backgroundColor: AppColors.neutral30,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: Window.getPadding(top: 50, left: 20, bottom: 20),
              child: Text(
                "My Account",
                style: AppTextStyles.heading4Bold.copyWith(
                  color: AppColors.neutral80,
                ),
              ),
            ),

            // User Info Section
            Padding(
              padding: Window.getSymmetricPadding(horizontal: 16),
              child: Row(
                children: [
                  // Profile Picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Window.getRadiusSize(50)),
                    child: Image.asset(
                      userData["profilePic"]!,
                      height: Window.getSize(70),
                      width: Window.getSize(70),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: Window.getHorizontalSize(16)),

                  // User Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData["name"]!,
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: Window.getFontSize(18),
                          color: AppColors.neutral80,
                        ),
                      ),
                      SizedBox(height: Window.getVerticalSize(4)),
                      Text(
                        userData["email"]!,
                        style: AppTextStyles.bodyRegular.copyWith(
                          fontSize: Window.getFontSize(14),
                          color: AppColors.neutral60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: Window.getVerticalSize(20)),

            // Watch History Section
            _buildSectionHeader("Watch History"),
            _buildPodcastList(watchHistory),

            // Downloaded Podcasts Section
            _buildSectionHeader("Downloaded Podcasts"),
            _buildPodcastList(downloadedPodcasts),
          ],
        ),
      ),
    );
  }

  // Helper method to build a section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: Window.getSymmetricPadding(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: AppTextStyles.heading5Bold.copyWith(
          color: AppColors.neutral80,
        ),
      ),
    );
  }

  // Helper method to build the podcast list
  Widget _buildPodcastList(List<Map<String, String>> podcasts) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: podcasts.length,
      itemBuilder: (context, index) {
        final podcast = podcasts[index];
        return GestureDetector(
          onTap: () {
            // Action to play or view podcast details
            print("Selected podcast: ${podcast['title']}");
          },
          child: Container(
            margin: Window.getMargin(left: 16, right: 16.00,  top: 8, bottom: 8),
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
                // Podcast Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
                  child: Image.asset(
                    podcast["thumbnail"]!,
                    height: Window.getVerticalSize(70),
                    width: Window.getHorizontalSize(100),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Window.getHorizontalSize(16)),

                // Podcast Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        podcast["title"]!,
                        style: AppTextStyles.subtitleBold.copyWith(
                          color: AppColors.neutral80,
                          fontSize: Window.getFontSize(16),
                        ),
                      ),
                      SizedBox(height: Window.getVerticalSize(8)),
                      Text(
                        podcast["description"]!,
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
    );
  }
}
