import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final MapController _mapController = MapController();
  final ValueNotifier<_TrackViewData> _trackData = ValueNotifier(
    _TrackViewData.initial(),
  );

  StreamSubscription<Position>? _positionSubscription;
  Timer? _durationTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeLocation());
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationTimer?.cancel();
    _trackData.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Location services are disabled.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _showMessage('Location permission is required for tracking.');
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final center = LatLng(position.latitude, position.longitude);

    _trackData.value = _trackData.value.copyWith(currentLocation: center);
    _mapController.move(center, 16);
  }

  void _startTracking() {
    final startAt = DateTime.now();

    _durationTimer?.cancel();
    _positionSubscription?.cancel();

    _trackData.value = _trackData.value.copyWith(
      isTracking: true,
      distanceKm: 0,
      elapsed: Duration.zero,
      startedAt: startAt,
      routePoints: <LatLng>[],
    );

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final data = _trackData.value;
      if (!data.isTracking || data.startedAt == null) {
        return;
      }
      _trackData.value = data.copyWith(
        elapsed: DateTime.now().difference(data.startedAt!),
      );
    });

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen(
      _onPositionUpdate,
      onError: (Object error) {
        _showMessage('Unable to track location updates.');
      },
    );
  }

  void _onPositionUpdate(Position position) {
    final next = LatLng(position.latitude, position.longitude);
    final data = _trackData.value;
    final updatedRoute = List<LatLng>.from(data.routePoints)..add(next);

    var distanceKm = data.distanceKm;
    if (data.routePoints.isNotEmpty) {
      final previous = data.routePoints.last;
      final distanceMeters = Geolocator.distanceBetween(
        previous.latitude,
        previous.longitude,
        next.latitude,
        next.longitude,
      );
      distanceKm += distanceMeters / 1000;
    }

    _trackData.value = data.copyWith(
      currentLocation: next,
      distanceKm: distanceKm,
      routePoints: updatedRoute,
    );

    _mapController.move(next, _mapController.camera.zoom);
  }

  void _stopTracking() {
    _positionSubscription?.cancel();
    _durationTimer?.cancel();
    _trackData.value = _trackData.value.copyWith(isTracking: false);
  }

  Future<void> _toggleTracking() async {
    if (_trackData.value.isTracking) {
      _stopTracking();
      return;
    }

    await _initializeLocation();
    _startTracking();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Live Track'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0F172A),
      ),
      floatingActionButton: ValueListenableBuilder<_TrackViewData>(
        valueListenable: _trackData,
        builder: (_, data, __) {
          return FloatingActionButton.extended(
            onPressed: _initializeLocation,
            icon: const Icon(Icons.my_location_rounded),
            label: Text(data.isTracking ? 'Recenter' : 'Locate me'),
          );
        },
      ),
      body: ValueListenableBuilder<_TrackViewData>(
        valueListenable: _trackData,
        builder: (_, data, __) {
          final paceMinPerKm = _calculatePace(data.distanceKm, data.elapsed);

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: data.currentLocation,
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.athlorun.ui_only',
                  ),
                  if (data.routePoints.length > 1)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: data.routePoints,
                          strokeWidth: 6,
                          color: const Color(0xFF2563EB),
                          gradientColors: const [
                            Color(0xFF22D3EE),
                            Color(0xFF2563EB),
                            Color(0xFF4F46E5),
                          ],
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: data.currentLocation,
                        width: 56,
                        height: 56,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x332563EB),
                          ),
                          child: const Icon(
                            Icons.directions_run_rounded,
                            size: 34,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: kToolbarHeight + 18,
                left: 16,
                right: 16,
                child: _GradientSummaryCard(
                  distanceKm: data.distanceKm,
                  elapsed: data.elapsed,
                  paceMinPerKm: paceMinPerKm,
                  pointsCount: data.routePoints.length,
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: _ActionCard(
                  isTracking: data.isTracking,
                  onToggleTracking: _toggleTracking,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _calculatePace(double distanceKm, Duration elapsed) {
    if (distanceKm <= 0) return '--:-- /km';

    final minutesPerKm = elapsed.inSeconds / 60 / distanceKm;
    final paceMinutes = minutesPerKm.floor();
    final paceSeconds = ((minutesPerKm - paceMinutes) * 60)
        .round()
        .clamp(0, 59)
        .toInt();

    return '$paceMinutes:${paceSeconds.toString().padLeft(2, '0')} /km';
  }
}

class _TrackViewData {
  final LatLng currentLocation;
  final bool isTracking;
  final double distanceKm;
  final Duration elapsed;
  final DateTime? startedAt;
  final List<LatLng> routePoints;

  const _TrackViewData({
    required this.currentLocation,
    required this.isTracking,
    required this.distanceKm,
    required this.elapsed,
    required this.startedAt,
    required this.routePoints,
  });

  factory _TrackViewData.initial() {
    return const _TrackViewData(
      currentLocation: LatLng(20.5937, 78.9629),
      isTracking: false,
      distanceKm: 0,
      elapsed: Duration.zero,
      startedAt: null,
      routePoints: <LatLng>[],
    );
  }

  _TrackViewData copyWith({
    LatLng? currentLocation,
    bool? isTracking,
    double? distanceKm,
    Duration? elapsed,
    Object? startedAt = _none,
    List<LatLng>? routePoints,
  }) {
    return _TrackViewData(
      currentLocation: currentLocation ?? this.currentLocation,
      isTracking: isTracking ?? this.isTracking,
      distanceKm: distanceKm ?? this.distanceKm,
      elapsed: elapsed ?? this.elapsed,
      startedAt: startedAt == _none ? this.startedAt : startedAt as DateTime?,
      routePoints: routePoints ?? this.routePoints,
    );
  }
}

const Object _none = Object();

class _GradientSummaryCard extends StatelessWidget {
  final double distanceKm;
  final Duration elapsed;
  final String paceMinPerKm;
  final int pointsCount;

  const _GradientSummaryCard({
    required this.distanceKm,
    required this.elapsed,
    required this.paceMinPerKm,
    required this.pointsCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalMinutes = elapsed.inMinutes;
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetricChip(
              title: 'Distance',
              value: '${distanceKm.toStringAsFixed(2)} km',
            ),
          ),
          Expanded(
            child: _MetricChip(
              title: 'Time',
              value: '$totalMinutes:$seconds',
            ),
          ),
          Expanded(
            child: _MetricChip(
              title: 'Pace',
              value: paceMinPerKm,
            ),
          ),
          Expanded(
            child: _MetricChip(
              title: 'Points',
              value: pointsCount.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String title;
  final String value;

  const _MetricChip({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFBFDBFE),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onToggleTracking;

  const _ActionCard({required this.isTracking, required this.onToggleTracking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isTracking ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onToggleTracking,
          icon: Icon(
            isTracking ? Icons.stop_circle_outlined : Icons.play_arrow_rounded,
          ),
          label: Text(
            isTracking ? 'Stop Tracking' : 'Start Activity',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
