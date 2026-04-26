import 'package:flutter/material.dart';
import 'package:athlorun/features/podcast/podcast_screen.dart';
import 'package:animations/animations.dart';
import 'package:athlorun/features/profile/presentation/pages/profile_podcast_screen.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../recording/presentation/recording_screen.dart';

class DashboardScreenPodcast extends StatefulWidget {
  const DashboardScreenPodcast({super.key});

  @override
  State<DashboardScreenPodcast> createState() => _DashboardScreenPodcastState();
}

class _DashboardScreenPodcastState extends State<DashboardScreenPodcast> {
  int _currentIndex = 0; // Controls the active tab

  final List<Widget> _pages = [
    const PodcastHomeScreen(), // Podcast home screen in the middle
    RecordedVideoScreen(),
    ProfilePodcastPage(), // Placeholder for "Profile" screen
  ];

  // Public method to update _currentIndex
  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(view: View.of(context)); // Initialize Window

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: Window.getSymmetricPadding(horizontal: 20),
            child: Container(
              padding: Window.getSymmetricPadding(vertical: 10, horizontal: 20),
              margin: Window.getMargin(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.neutral10,
                borderRadius: BorderRadius.circular(Window.getRadiusSize(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.videocam, "Recorded", 1),
                  const SizedBox(
                      width: 80), // Placeholder for the floating button
                  _buildNavItem(Icons.person, "Profile", 2),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: GestureDetector(
              onTap: () {
                updateIndex(0); // Navigate to Podcast Home
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: Window.getSize(80),
                width: Window.getSize(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue100, AppColors.primaryBlue80],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue100.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mic,
                  color: AppColors.neutral10,
                  size: Window.getFontSize(40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        updateIndex(index); // Use the public method to update index
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryBlue100 : AppColors.neutral80,
            size: Window.getFontSize(28),
          ),
          Text(
            label,
            style: isSelected
                ? AppTextStyles.bodySemiBold.copyWith(
                    color: AppColors.primaryBlue100,
                    fontSize: Window.getFontSize(12),
                  )
                : AppTextStyles.bodyRegular.copyWith(
                    color: AppColors.neutral80,
                    fontSize: Window.getFontSize(12),
                  ),
          ),
        ],
      ),
    );
  }
}
