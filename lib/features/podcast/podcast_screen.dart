import 'package:flutter/material.dart';
import '../../config/styles/app_colors.dart';
import '../../config/styles/app_textstyles.dart';
import '../../core/utils/windows.dart';
import '../dashboard/presentation/pages/dashboard_tabbar.dart';

class PodcastHomeScreen extends StatefulWidget {
  const PodcastHomeScreen({super.key});

  @override
  State<PodcastHomeScreen> createState() => _PodcastHomeScreenState();
}

class _PodcastHomeScreenState extends State<PodcastHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: 2); // Set initial tab to Podcast
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Window().adaptDeviceScreenSize(view: View.of(context)); // Initialize Window

    return Scaffold(
      backgroundColor: AppColors.neutral30,
      body: SafeArea(
        child: Column(
          children: [
            // DashboardTabBar(tabController: _tabController),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Streaming Section
                  Padding(
                    padding: Window.getPadding(all: 16),
                    child: Container(
                      height: Window.getVerticalSize(200),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Window.getRadiusSize(20)),
                        color: AppColors.neutral90,
                        image: const DecorationImage(
                          image: AssetImage('assets/123.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.neutral100
                                  .withOpacity(0.4), // Dark overlay
                              borderRadius: BorderRadius.circular(
                                  Window.getRadiusSize(20)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.live_tv,
                                  color: AppColors.secondaryPurple100,
                                  size: Window.getFontSize(40),
                                ),
                                SizedBox(height: Window.getVerticalSize(8)),
                                Text(
                                  "Live: Interview with Usain Bolt",
                                  style: AppTextStyles.subtitleBold
                                      .copyWith(color: AppColors.neutral10),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: Window.getVerticalSize(12)),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.secondaryPurple100,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        Window.getRadiusSize(12),
                                      ),
                                    ),
                                    padding: Window.getSymmetricPadding(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: Text(
                                    "Watch Now",
                                    style: AppTextStyles.bodyBold
                                        .copyWith(color: AppColors.neutral10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Window.getVerticalSize(20)),
                  // Title for Upcoming Podcasts Section
                  Padding(
                    padding: Window.getPadding(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Podcasts",
                          style: AppTextStyles.heading5Bold
                              .copyWith(color: AppColors.neutral90),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "See All",
                            style: AppTextStyles.bodyBold
                                .copyWith(color: AppColors.primaryBlue100),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Upcoming Podcasts List
                  Expanded(
                    child: ListView.builder(
                      padding: Window.getSymmetricPadding(horizontal: 16),
                      itemCount: 10, // Example podcast count
                      itemBuilder: (context, index) {
                        return PodcastItem(
                          title: "Upcoming Podcast #${index + 1}",
                          subtitle:
                              "Exciting discussions and insights coming soon",
                          image: 'assets/123.png',
                          dateTime: "25 Jan 2025, 10:00 AM",
                        );
                      },
                    ),
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

class PodcastItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final String dateTime;

  const PodcastItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Window.getMargin(bottom: 12),
      padding: Window.getPadding(all: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral40.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Podcast Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(Window.getRadiusSize(8)),
            child: Image.asset(
              image,
              width: Window.getSize(60),
              height: Window.getSize(60),
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
                  title,
                  style: AppTextStyles.subtitleBold
                      .copyWith(color: AppColors.neutral90),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Window.getVerticalSize(4)),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.neutral60),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Window.getVerticalSize(8)),
                Text(
                  dateTime,
                  style: AppTextStyles.bodySemiBold
                      .copyWith(color: AppColors.primaryBlue100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
