import 'package:flutter/material.dart';
import 'package:athlorun/config/routes/routes.dart';

class NotificationWidget extends StatelessWidget {
  final int notificationCount;

  const NotificationWidget({super.key, this.notificationCount = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.notification);
          },
          icon: const Icon(
            Icons.notifications_none,
            size: 24,
          ),
          tooltip: 'Notifications',
        ),
        if (notificationCount > -1)
          Positioned(
            right: 8,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Center(
                child: Text(
                  notificationCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
