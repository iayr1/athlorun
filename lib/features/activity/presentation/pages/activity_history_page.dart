import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../config/themes/app_theme.dart';
import '../../../../core/services/metrics_store.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/ui_kit.dart';

IconData activityIcon(ActivityKind kind) => switch (kind) {
      ActivityKind.run => Icons.directions_run_rounded,
      ActivityKind.walk => Icons.directions_walk_rounded,
      ActivityKind.ride => Icons.directions_bike_rounded,
    };

Color activityColor(ActivityKind kind) => switch (kind) {
      ActivityKind.run => AppPalette.primary,
      ActivityKind.walk => AppPalette.green,
      ActivityKind.ride => AppPalette.orange,
    };

class ActivityHistoryPage extends StatelessWidget {
  const ActivityHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = MetricsStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Activity history')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final activities = store.activities;
          if (activities.isEmpty) {
            return const Center(
              child: EmptyState(
                icon: Icons.route_rounded,
                title: 'No workouts yet',
                message:
                    'Start a run, walk or ride from the Track tab and it will appear here.',
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => Dismissible(
              key: ValueKey(activities[i].id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: AppPalette.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.delete_outline, color: AppPalette.red),
              ),
              confirmDismiss: (_) => _confirmDelete(context),
              onDismissed: (_) => store.deleteActivity(activities[i].id),
              child: ActivityTile(activity: activities[i]),
            ),
          );
        },
      ),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete workout?'),
      content: const Text('This workout will be removed from your history.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppPalette.red),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}

class ActivityTile extends StatelessWidget {
  final TrackedActivity activity;

  const ActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final color = activityColor(activity.kind);
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ActivityDetailPage(activity: activity),
        ),
      ),
      child: Row(
        children: [
          IconBadge(icon: activityIcon(activity.kind), color: color, size: 50),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${activity.kind.label} · ${Fmt.km(activity.distanceKm)} km',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Fmt.date(activity.startedAt)} · ${Fmt.time(activity.startedAt)}',
                  style: const TextStyle(
                      color: AppPalette.inkSoft, fontSize: 12.5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Fmt.duration(activity.duration),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '${activity.calories.toStringAsFixed(0)} kcal',
                style:
                    const TextStyle(color: AppPalette.orange, fontSize: 12.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityDetailPage extends StatelessWidget {
  final TrackedActivity activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final points = [for (final p in activity.route) LatLng(p[0], p[1])];
    final color = activityColor(activity.kind);

    return Scaffold(
      appBar: AppBar(title: Text('${activity.kind.label} details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 260,
              child: points.isEmpty
                  ? Container(
                      color: color.withValues(alpha: 0.08),
                      child: const Center(
                        child: Text('No GPS route recorded'),
                      ),
                    )
                  : FlutterMap(
                      options: MapOptions(
                        initialCameraFit: points.length > 1
                            ? CameraFit.coordinates(
                                coordinates: points,
                                padding: const EdgeInsets.all(36),
                              )
                            : null,
                        initialCenter: points.first,
                        initialZoom: 16,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.athlorun.app',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: points,
                              strokeWidth: 6,
                              color: color,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            _dot(points.first, AppPalette.green),
                            if (points.length > 1)
                              _dot(points.last, AppPalette.red),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${Fmt.date(activity.startedAt)} at ${Fmt.time(activity.startedAt)}',
            style: const TextStyle(color: AppPalette.inkSoft),
          ),
          const SizedBox(height: 6),
          Text(
            '${Fmt.km(activity.distanceKm)} km ${activity.kind.label.toLowerCase()}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 136,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatTile(
                icon: Icons.timer_outlined,
                color: AppPalette.blue,
                value: Fmt.duration(activity.duration),
                label: 'Duration',
              ),
              StatTile(
                icon: Icons.speed_rounded,
                color: AppPalette.purple,
                value: '${Fmt.pace(activity.paceMinPerKm)} /km',
                label: 'Avg pace',
              ),
              StatTile(
                icon: Icons.bolt_rounded,
                color: AppPalette.cyan,
                value: '${activity.speedKmh.toStringAsFixed(1)} km/h',
                label: 'Avg speed',
              ),
              StatTile(
                icon: Icons.local_fire_department_rounded,
                color: AppPalette.orange,
                value: '${activity.calories.toStringAsFixed(0)} kcal',
                label: 'Calories',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Marker _dot(LatLng point, Color color) {
    return Marker(
      point: point,
      width: 22,
      height: 22,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
