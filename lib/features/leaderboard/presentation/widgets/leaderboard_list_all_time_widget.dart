import 'package:flutter/material.dart';
import '../../../../core/utils/windows.dart';
import 'leaderboard_tile_widget.dart';

class LeaderboardListAllTimeWidget extends StatelessWidget {
  const LeaderboardListAllTimeWidget({super.key});

  final List<Map<String, dynamic>> leaderboardData = const [
    {'name': 'Elanor Pena', 'distance': '10.9', 'change': '3'},
    {'name': 'Devon Lane', 'distance': '9.5', 'change': '-1'},
    {'name': 'Jenny Wilson', 'distance': '9.2', 'change': '-'},
    {'name': 'Robert Bell', 'distance': '9.1', 'change': '-1'},
    {'name': 'Arlene', 'distance': '8.9', 'change': '2'},
    {'name': 'Guy Hawkins', 'distance': '8.2', 'change': '-'},
    {'name': 'Marvin McKinney', 'distance': '8.0', 'change': '-'},
    {'name': 'Ralph Edwards', 'distance': '7.9', 'change': '-'},
    {'name': 'Robert Bell', 'distance': '9.1', 'change': '-1'},
    {'name': 'Arlene', 'distance': '8.9', 'change': '2'},
    {'name': 'Guy Hawkins', 'distance': '8.2', 'change': '-'},
    {'name': 'Marvin McKinney', 'distance': '8.0', 'change': '-'},
    {'name': 'Ralph Edwards', 'distance': '7.9', 'change': '-'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leaderboardData.length,
      padding: Window.getPadding(all: 16), // Responsive padding
      itemBuilder: (context, index) {
        final player = leaderboardData[index];
        return Padding(
          padding: Window.getMargin(bottom: 12), // Responsive spacing between items
          child: LeaderboardTileWidget(
            position: index + 1,
            name: player['name'],
            distance: player['distance'],
            change: player['change'], // Slightly darker background for odd rows
          ),
        );
      },
    );
  }
}
