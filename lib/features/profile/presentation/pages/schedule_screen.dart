import 'package:athlorun/features/profile/presentation/pages/add_schedule_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

enum ScheduleType { upcoming, missed, completed }

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy UI data
  final List<Map<String, dynamic>> scheduleList = [
    {
      "title": "Morning Run",
      "date": "12 Mar",
      "completed": false,
      "past": false,
      "icon": "https://www.svgrepo.com/show/475123/run.svg"
    },
    {
      "title": "Gym Workout",
      "date": "10 Mar",
      "completed": false,
      "past": true,
      "icon": "https://www.svgrepo.com/show/475099/dumbbell.svg"
    },
    {
      "title": "Cycling",
      "date": "08 Mar",
      "completed": true,
      "past": true,
      "icon": "https://www.svgrepo.com/show/475099/bike.svg"
    },
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      appBar: AppBar(
        title: Text(AppStrings.schedule),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          _buildTabBar(),
          const SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(ScheduleType.upcoming),
                _buildList(ScheduleType.missed),
                _buildList(ScheduleType.completed),
              ],
            ),
          )
        ],
      ),

      bottomNavigationBar: Padding(
        padding: Window.getPadding(all: 16),
        child: CustomActionButton(
          name: AppStrings.addSchedule,
          isFormFilled: true,
          onTap: (start, stop, state) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const AddScheduleBottomSheet(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(ScheduleType type) {
    final filtered = scheduleList.where((e) {
      switch (type) {
        case ScheduleType.upcoming:
          return !e["past"] && !e["completed"];
        case ScheduleType.missed:
          return e["past"] && !e["completed"];
        case ScheduleType.completed:
          return e["completed"];
      }
    }).toList();

    if (filtered.isEmpty) {
      return Center(child: Text("No Data"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral30),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryBlue20,
              child: SvgPicture.network(item["icon"]),
            ),
            title: Text(item["title"]),
            subtitle: Text("${AppStrings.schedule} • ${item["date"]}"),
            trailing: type == ScheduleType.completed
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 10),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: "Upcoming"),
        Tab(text: "Missed"),
        Tab(text: "Completed"),
      ],
    );
  }
}


