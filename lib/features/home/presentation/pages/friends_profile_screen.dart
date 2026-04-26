import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class FriendsProfileScreen extends StatelessWidget {
  const FriendsProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String name = args['name'];
    final String imagePath = args['imagePath'];

    final List<String> imagePaths = [
      'assets/badges/badge1.png',
      'assets/badges/badge2.png',
      'assets/badges/badge3.png',
      'assets/badges/badge4.png',
      'assets/badges/badge5.png',
      'assets/badges/badge6.png',
      'assets/badges/badge7.png',
      'assets/badges/badge8.png',
      'assets/badges/badge9.png',
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlue10,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Window.getPadding(all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.neutral100),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Profile',
                      style: AppTextStyles.heading4Bold
                          .copyWith(color: AppColors.neutral100),
                    ),
                    const SizedBox(width: 48), // Placeholder for alignment
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(16)),

                // Profile Image
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: Window.getSize(60),
                        backgroundImage: AssetImage(imagePath),
                        backgroundColor: AppColors.primaryBlue40,
                      ),
                      SizedBox(height: Window.getVerticalSize(12)),
                      Text(
                        name,
                        style: AppTextStyles.heading3Bold
                            .copyWith(color: AppColors.neutral100),
                      ),
                      SizedBox(height: Window.getVerticalSize(8)),
                      Text(
                        'Adventurer | Challenge Enthusiast',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyRegular
                            .copyWith(color: AppColors.neutral60),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(24)),

                // Stats Row
                Container(
                  padding:
                      Window.getSymmetricPadding(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue20,
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Followers', '256'),
                      _buildStatColumn('Following', '180'),
                      _buildStatColumn('Challenges', '34'),
                    ],
                  ),
                ),
                SizedBox(height: Window.getVerticalSize(24)),

                // Follow and Message Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      'Follow',
                      AppColors.primaryBlue100,
                      AppColors.neutral10,
                      Icons.person_add,
                      () {},
                    ),
                  ],
                ),
                SizedBox(height: Window.getVerticalSize(24)),

                // Badges Section Header
                Text(
                  'Achievements',
                  style: AppTextStyles.heading5Bold
                      .copyWith(color: AppColors.neutral100),
                ),
                SizedBox(height: Window.getVerticalSize(12)),

                // Grid View with Badges
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: imagePaths.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue20,
                        borderRadius:
                            BorderRadius.circular(Window.getRadiusSize(8)),
                        image: DecorationImage(
                          image: AssetImage(imagePaths[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.heading4Bold
              .copyWith(color: AppColors.primaryBlue100),
        ),
        SizedBox(height: Window.getVerticalSize(4)),
        Text(
          label,
          style: AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral60),
        ),
      ],
    );
  }

  Widget _buildButton(
    String label,
    Color backgroundColor,
    Color textColor,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: Window.getSize(16)),
      label: Text(
        label,
        style: AppTextStyles.bodyBold,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: Window.getSymmetricPadding(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Window.getRadiusSize(20)),
        ),
        minimumSize: Size(200, 40), // Set a minimum width and height
      ),
    );
  }
}
