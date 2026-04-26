import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

class SportsEventPage extends StatefulWidget {
  @override
  State<SportsEventPage> createState() => _SportsEventPageState();
}

class _SportsEventPageState extends State<SportsEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderSection(),
              _buildEventDetails(),
              SizedBox(height: Window.getVerticalSize(24)),
              _buildAboutSection(),
              SizedBox(height: Window.getVerticalSize(12)),
              _buildCTAButton(),
              SizedBox(height: Window.getVerticalSize(24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Stack(
      children: [
        Container(
          height: Window.getVerticalSize(240),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/123.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: Window.getVerticalSize(16),
          left: Window.getHorizontalSize(16),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: AppColors.neutral10,
              )),
        ),
        Positioned(
          bottom: Window.getVerticalSize(32),
          left: Window.getHorizontalSize(16),
          right: Window.getHorizontalSize(16),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none, // Ensure overflow is visible
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile/profile1.png'),
                    radius: Window.getSize(15),
                  ),
                  Positioned(
                    left: Window.getHorizontalSize(18), // Adjust overlap
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/profile/profile2.png'),
                      radius: Window.getSize(15),
                    ),
                  ),
                  Positioned(
                    left: Window.getHorizontalSize(36), // Adjust overlap
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/profile/profile3.png'),
                      radius: Window.getSize(15),
                    ),
                  ),
                ],
              ),
              SizedBox(width: Window.getHorizontalSize(30)),
              Text(
                "+50 Going",
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.primaryBlue100),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue100,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(12)),
                  ),
                ),
                child: Text(
                  "Invite",
                  style: AppTextStyles.bodyBold
                      .copyWith(color: AppColors.neutral10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Padding(
      padding: Window.getPadding(left: 16, right: 16, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "National Soccer Championship",
            style:
                AppTextStyles.heading4Bold.copyWith(color: AppColors.neutral90),
          ),
          SizedBox(height: Window.getVerticalSize(12)),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  color: AppColors.primaryBlue70, size: 20),
              SizedBox(width: Window.getHorizontalSize(8)),
              Text(
                "20 January, 2025 | 5:00 PM - 9:00 PM",
                style: AppTextStyles.captionRegular
                    .copyWith(color: AppColors.neutral70),
              ),
            ],
          ),
          SizedBox(height: Window.getVerticalSize(8)),
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryBlue70, size: 20),
              SizedBox(width: Window.getHorizontalSize(8)),
              Expanded(
                child: Text(
                  "National Stadium, New York, USA",
                  style: AppTextStyles.captionRegular
                      .copyWith(color: AppColors.neutral70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: Window.getVerticalSize(16)),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/123.png'),
                radius: Window.getSize(20),
              ),
              SizedBox(width: Window.getHorizontalSize(8)),
              Text(
                "John Doe",
                style: AppTextStyles.bodySemiBold
                    .copyWith(color: AppColors.neutral90),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: AppColors.neutral30,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Window.getRadiusSize(8)),
                  ),
                ),
                child: Text("Follow",
                    style: AppTextStyles.bodyBold
                        .copyWith(color: AppColors.primaryBlue100)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: Window.getSymmetricPadding(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Event",
              style: AppTextStyles.heading5SemiBold
                  .copyWith(color: AppColors.neutral90)),
          SizedBox(height: Window.getVerticalSize(8)),
          Text(
            "Join the thrilling soccer championship where teams from across the nation compete for glory. Witness spectacular gameplay, enjoy the stadium atmosphere, and cheer for your favorite team!",
            style:
                AppTextStyles.bodyRegular.copyWith(color: AppColors.neutral70),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton() {
    return Padding(
      padding: Window.getSymmetricPadding(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue100,
            padding: Window.getSymmetricPadding(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Window.getRadiusSize(12)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BUY TICKET",
                style:
                    AppTextStyles.bodyBold.copyWith(color: AppColors.neutral10),
              ),
              SizedBox(width: Window.getHorizontalSize(8)),
              Text(
                "\$50",
                style:
                    AppTextStyles.bodyBold.copyWith(color: AppColors.neutral10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
