import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../config/routes/routes.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../core/widgets/custom_action_button.dart';

class TrackingSummaryBottomSheet extends StatelessWidget {
  final double distance;
  final Duration duration;
  final int calories;
  final String avgPace;
  final List<LatLng> polylinePoints;
  final String selectedSportItem;
  final String sportId;

  TrackingSummaryBottomSheet({
    required this.distance,
    required this.duration,
    required this.calories,
    required this.avgPace,
    required this.polylinePoints,
    required this.selectedSportItem,
    required this.sportId,
  });

  String _formatDistance(double distance) {
    return distance < 1.0
        ? "${(distance * 1000).toStringAsFixed(0)} m"
        : "${distance.toStringAsFixed(2)} km";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatPolylineToString(List<LatLng> points) {
    final distance = const Distance();
    List<LatLng> filtered = [];

    if (points.isEmpty) return "";

    // Always include the first point
    LatLng lastAdded = points.first;
    filtered.add(lastAdded);

    for (final point in points) {
      final d = distance.as(LengthUnit.Meter, lastAdded, point);
      if (d >= 50) {
        filtered.add(point);
        lastAdded = point;
      }
    }

    return filtered.map((p) => "${p.latitude},${p.longitude}").join('|');
  }

  @override
  Widget build(BuildContext context) {
    final polylineString = _formatPolylineToString(polylinePoints);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedSportItem,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryBlue100,
              fontWeight: FontWeight.w600,
            ),
          ),
          if ([
            "7f675519-73d0-41ff-afb8-d228953d7680",
            "b918691f-993c-4c54-96b5-3cba5ed51e20",
            "daeac52b-ac83-4082-bf60-dc2e84e3c47f",
            "ac337315-3d67-4c2e-9763-18afe21d0c47"
          ].contains(sportId)) ...[
            Text(
              _formatDistance(distance),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Distance",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey[300]),
          ] else
            ...[],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn(_formatDuration(duration), "Duration"),
              _buildMetricColumn(calories.toString(), "Calories"),
              _buildMetricColumn(avgPace, "Avg Pace"),
            ],
          ),
          const SizedBox(height: 32),

          /// 🚀 Custom Action Button
          CustomActionButton(
            name: "View Activity",
            isFormFilled: true,
            onTap: (startLoading, stopLoading, btnState) async {
              startLoading();
              await Future.delayed(const Duration(milliseconds: 300));
              stopLoading();
              print("Formatted polyline: $polylineString");
              Navigator.pushNamed(
                context,
                AppRoutes.mapActivityScreen,
                arguments: {
                  'polylineString': polylineString,
                  'distance': distance,
                  'duration': duration,
                  'calories': calories,
                  'avgPace': avgPace,
                  'selectedSport': selectedSportItem,
                  'sportId': sportId,
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
