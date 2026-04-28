import 'package:flutter/material.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';

// Use your cleaned widgets (NO wrappers)
import '../widgets/custom_profile_widget.dart';
import '../widgets/gear_widget.dart';
import '../widgets/schedule_widget.dart' hide GearWidget;

// These can remain UI widgets if already clean
import '../../../home/presentation/widgets/suggested_challenge_widget.dart';
import '../../../home/presentation/widgets/badge_widget.dart';
import '../widgets/activity_widget.dart';
import '../widgets/graphical_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String selectedFilter = "Weekly";

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.neutral10,
        body: SingleChildScrollView(
          child: Padding(
            padding: Window.getPadding(all: 16),
            child: Column(
              children: [
                /// Profile (clean widget)
                const CustomProfileWidget(),

                SizedBox(height: Window.getVerticalSize(8)),

                /// Statistics
                _buildStatisticsSection(),

                SizedBox(height: Window.getVerticalSize(12)),

                /// Graph
                SizedBox(
                  height: Window.getVerticalSize(300),
                  width: double.infinity,
                  child: const GraphicalWidget(),
                ),

                /// Activity
                const ActivityWidget(),

                SizedBox(height: Window.getVerticalSize(24)),

                /// Schedule
                const ScheduleWidget(),

                SizedBox(height: Window.getVerticalSize(24)),

                /// Suggested Challenges
                const SuggestedChallengeWidget(),

                SizedBox(height: Window.getVerticalSize(24)),

                /// Gear
                const GearWidget(),

                SizedBox(height: Window.getVerticalSize(24)),

                /// Badges
                const BadgeWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Stack(
      children: [
        /// Title
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Statistics',
              style: AppTextStyles.subtitleMedium,
            ),
          ),
        ),

        /// Dropdown
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(top: 4),
            height: Window.width * 0.1,
            decoration: BoxDecoration(
              color: AppColors.neutral20,
              borderRadius: BorderRadius.circular(24),
            ),
            child: DropdownButton<String>(
              value: selectedFilter,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
              items: ['Weekly', 'Monthly', 'Yearly']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
          ),
        ),

        /// Buttons
        Padding(
          padding: EdgeInsets.only(top: Window.width * 0.1 + 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterButton("Run", Icons.directions_run, true),
                _filterButton("Cycling", Icons.directions_bike, false),
                _filterButton("Hiking", Icons.terrain, false),
                _filterButton("Other", Icons.fitness_center, false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterButton(String label, IconData icon, bool selected) {
    return Padding(
      padding: EdgeInsets.only(right: Window.getHorizontalSize(12)),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon,
            color: selected
                ? AppColors.primaryBlue100
                : AppColors.neutral80),
        label: Text(
          label,
          style: AppTextStyles.bodyBold.copyWith(
            color: selected
                ? AppColors.primaryBlue100
                : AppColors.neutral80,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selected ? AppColors.primaryBlue40 : Colors.transparent,
          side: BorderSide(
            color:
                selected ? AppColors.primaryBlue100 : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}