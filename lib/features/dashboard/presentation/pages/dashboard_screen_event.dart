import 'package:flutter/material.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../events/presentation/pages/event_page.dart';
import '../../../orders/order_history.dart';
import '../../../settings/presentation/pages/setting_event_page.dart';

class DashboardScreenEvent extends StatefulWidget {
  const DashboardScreenEvent({super.key});

  @override
  State<DashboardScreenEvent> createState() => _DashboardScreenEventState();
}

class _DashboardScreenEventState extends State<DashboardScreenEvent> {
  int _currentIndex = 0; // Controls the active tab

  final List<Widget> _pages = [
    EventPage(),
    OrderHistoryPage(),
    // EventMapPage(),
    SettingEventPage(),
  ];

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: Window.getPadding(all: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral10,
                  borderRadius: BorderRadius.circular(Window.getRadiusSize(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: Window.getSymmetricPadding(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.event, "Event", 0),
                    _buildNavItem(Icons.history, "Order History", 1),
                    _buildNavItem(Icons.map, "Map", 2),
                    _buildNavItem(Icons.settings, "Settings", 3),
                  ],
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
        updateIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryBlue100 : AppColors.neutral80,
            size: Window.getFontSize(isSelected ? 28 : 24),
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
