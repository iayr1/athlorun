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
    if (!serviceEnabled) return;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_center, 16);
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
      appBar: AppBar(title: const Text('Track')),
      floatingActionButton: FloatingActionButton(
        onPressed: _initializeLocation,
        child: const Icon(Icons.my_location),
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
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(markers: [
                Marker(
                  point: _center,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_pin,
                      size: 36, color: Colors.red),
                ),
              ]),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Distance: ${_distanceKm.toStringAsFixed(2)} km'),
                        Text('Duration: $minutes:$seconds'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _toggleTracking,
                      icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                      label: Text(_isTracking ? 'Stop' : 'Start'),
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
