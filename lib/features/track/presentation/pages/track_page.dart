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
  StreamSubscription<Position>? _positionSubscription;

  final List<LatLng> _routePoints = [];
  LatLng _center = const LatLng(20.5937, 78.9629);
  bool _isTracking = false;
  double _distanceKm = 0;
  DateTime? _startedAt;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
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
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_center, 16);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleTracking() {
    if (_isTracking) {
      _stopTracking();
    } else {
      _startTracking();
    }
  }

  Future<void> _startTracking() async {
    await _initializeLocation();
    _startedAt = DateTime.now();

    setState(() {
      _isTracking = true;
      _distanceKm = 0;
      _duration = Duration.zero;
      _routePoints.clear();
    });

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((position) {
      final next = LatLng(position.latitude, position.longitude);
      setState(() {
        if (_routePoints.isNotEmpty) {
          final last = _routePoints.last;
          final meters = Geolocator.distanceBetween(
            last.latitude,
            last.longitude,
            next.latitude,
            next.longitude,
          );
          _distanceKm += meters / 1000;
        }
        _routePoints.add(next);
        _center = next;
        _duration = DateTime.now().difference(_startedAt!);
      });
      _mapController.move(next, _mapController.camera.zoom);
    });
  }

  void _stopTracking() {
    _positionSubscription?.cancel();
    setState(() {
      _isTracking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _duration.inMinutes;
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Run'),
        foregroundColor: const Color(0xFF111827),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _initializeLocation,
        icon: const Icon(Icons.my_location),
        label: const Text('Center'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _center, initialZoom: 14),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.athlorun.ui_only',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    strokeWidth: 5,
                    color: const Color(0xFF2D74F0),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 42,
                    height: 42,
                    child: const Icon(
                      Icons.location_pin,
                      size: 38,
                      color: Color(0xFFE11D48),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _TrackMetric(
                            label: 'Distance',
                            value: '${_distanceKm.toStringAsFixed(2)} km',
                          ),
                        ),
                        Expanded(
                          child: _TrackMetric(
                            label: 'Duration',
                            value: '$minutes:$seconds',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isTracking
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF2D74F0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _toggleTracking,
                        icon: Icon(
                          _isTracking ? Icons.stop_circle_outlined : Icons.play_arrow,
                        ),
                        label: Text(_isTracking ? 'Stop Tracking' : 'Start Tracking'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackMetric extends StatelessWidget {
  final String label;
  final String value;

  const _TrackMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ],
    );
  }
}
