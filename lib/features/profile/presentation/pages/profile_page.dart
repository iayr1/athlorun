import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/features/home/presentation/widgets/badge_widget.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/profile/presentation/widgets/activity_widget.dart';
import 'package:athlorun/features/profile/presentation/widgets/graphical_widget.dart';
import '../../../../core/utils/windows.dart';
import '../../../home/presentation/widgets/suggested_challenge_widget.dart';
import '../widgets/custom_profile_widget.dart';
import '../widgets/gear_widget.dart';
import '../widgets/schedule_widget.dart';

class ProfilePageWrapper extends StatelessWidget {
  const ProfilePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>(),
      child: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: Window.getPadding(all: 16.0),
              child: Column(
                children: [
                  const CustomProfileWidgetWrapper(),
                  SizedBox(height: Window.getVerticalSize(8)),
                  _buildStatisticsSection(),
                  SizedBox(height: Window.getVerticalSize(12)),
                  SizedBox(
                    height: Window.getVerticalSize(300),
                    width: double.infinity,
                    child: const GraphicalWidget(),
                  ),
                  const ActivityWidget(),
                  SizedBox(height: Window.getVerticalSize(24)),
                  const ScheduleWidgetWrapper(),
                  SizedBox(height: Window.getVerticalSize(24)),
                  const SuggestedChallengeWidgetWrapper(),
                  SizedBox(height: Window.getVerticalSize(24)),
                  const GearWidgetWrapper(),
                  SizedBox(height: Window.getVerticalSize(24)),
                  const BadgeWidget(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Stack(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Statistics',
              style: AppTextStyles.subtitleMedium,
            ),
          ),
        ),

        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(top: 4), // small top spacing
            height: Window.width * 0.1,
            decoration: BoxDecoration(
              color: AppColors.neutral20,
              borderRadius: BorderRadius.circular(24),
            ),
            child: DropdownButton<String>(
              value: 'Weekly',
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppColors.neutral100),
              underline: const SizedBox(),
              dropdownColor: AppColors.neutral10,
              elevation: 8,
              onChanged: (value) {
                // handle selection change
              },
              items: ['Weekly', 'Monthly', 'Yearly']
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: AppTextStyles.bodyRegular),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),

        // Spacer below title and dropdown
        Padding(
          padding: EdgeInsets.only(top: Window.width * 0.1 + 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildOutlinedButton(
                  label: 'Run',
                  icon: Icons.directions_run,
                  isSelected: true,
                  onPressed: () {},
                ),
                _buildOutlinedButton(
                  label: 'Cycling',
                  icon: Icons.directions_bike,
                  isSelected: false,
                  onPressed: () {},
                ),
                _buildOutlinedButton(
                  label: 'Hiking',
                  icon: Icons.terrain,
                  isSelected: false,
                  onPressed: () {},
                ),
                _buildOutlinedButton(
                  label: 'Other',
                  icon: Icons.fitness_center,
                  isSelected: false,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinedButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: Window.getHorizontalSize(12)),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isSelected ? AppColors.primaryBlue100 : AppColors.neutral80,
        ),
        label: Text(
          label,
          style: AppTextStyles.bodyBold.copyWith(
              color:
                  isSelected ? AppColors.primaryBlue100 : AppColors.neutral80),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSelected ? AppColors.primaryBlue100 : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Window.getRadiusSize(20)),
          ),
          backgroundColor:
              isSelected ? AppColors.primaryBlue40 : Colors.transparent,
          padding: Window.getSymmetricPadding(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
