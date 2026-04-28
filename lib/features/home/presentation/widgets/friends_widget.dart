import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class FriendsWidget extends StatefulWidget {
  const FriendsWidget({super.key});

  @override
  State<FriendsWidget> createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget> {
  bool isTextButton = false;

  @override
  Widget build(BuildContext context) {
    // Example list of friends with hardcoded names and online status
    final List<Map<String, dynamic>> friends = [
      {
        'name': 'Alice',
        'imagePath': 'assets/profile/profile1.png',
        'isOnline': true
      },
      {
        'name': 'Bob',
        'imagePath': 'assets/profile/profile2.png',
        'isOnline': false
      },
      {
        'name': 'Charlie',
        'imagePath': 'assets/profile/profile3.png',
        'isOnline': true
      },
      {
        'name': 'Diana',
        'imagePath': 'assets/profile/profile4.png',
        'isOnline': false
      },
      {
        'name': 'Eve',
        'imagePath': 'assets/profile/profile5.png',
        'isOnline': true
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader('Friends (128)', () {
          Navigator.pushNamed(
              context, AppRoutes.friendsScreen); // Replace with your route
        }),
        SizedBox(height: Window.getVerticalSize(10)),

        // Horizontal Scrollable Friends List
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: friends.map((friend) {
              return _buildFriendAvatar(
                  friend['name'], friend['imagePath'], friend['isOnline']);
            }).toList(),
          ),
        ),
        SizedBox(height: Window.getVerticalSize(10)),

        // Add Friends Button / Share Text Button
        Center(
          child: TextButton.icon(
            onPressed: () {
              Share.share(
                'Join this amazing race with me! Click the link: https://example.com/join-race',
                subject: 'Join the Race!',
              );
            },
            icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
            label: Text(
              'Add Friends',
              style: AppTextStyles.bodyBold
                  .copyWith(color: AppColors.primaryBlue90),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue90,
              backgroundColor: AppColors.neutral10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
              ),
              splashFactory: NoSplash.splashFactory,
              padding: Window.getSymmetricPadding(horizontal: 16, vertical: 12),
            ),
          ),
        ),
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
              .copyWith(color: AppColors.neutral100),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "See all",
            style: AppTextStyles.bodySemiBold
                .copyWith(color: AppColors.primaryBlue90),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendAvatar(String name, String imagePath, bool isOnline) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.friendsProfileScreen, // Replace with your actual route name
          arguments: {
            'name': name,
            'imagePath': imagePath,
          },
        );
      },
      child: Container(
        margin: Window.getMargin(right: 10),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: Window.getSize(30),
                  backgroundImage: AssetImage(imagePath),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 2,
                    right: 0,
                    child: Container(
                      width: Window.getSize(15),
                      height: Window.getSize(15),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGreen100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neutral10,
                          width: Window.getSize(2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: Window.getVerticalSize(5)),
            Text(
              name,
              style: AppTextStyles.bodyBold
                  .copyWith(fontSize: 12, color: AppColors.neutral100),
            ),
          ],
        ),
      ),
    );
  }
}
