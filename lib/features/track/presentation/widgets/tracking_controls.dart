import 'package:flutter/material.dart';

class TrackingControls extends StatelessWidget {
  final bool tracking;
  final double distance;
  final Duration duration;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const TrackingControls({
    super.key,
    required this.tracking,
    required this.distance,
    required this.duration,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text('Distance: ${distance.toStringAsFixed(2)} km'),
                Text(
                    'Duration: ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: tracking ? onStop : onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: tracking ? Colors.red : Colors.green,
              minimumSize: const Size.fromHeight(50),
            ),
            child: Text(tracking ? 'Stop' : 'Start',
                style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
