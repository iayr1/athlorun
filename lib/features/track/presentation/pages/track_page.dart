import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/track/presentation/widgets/choose_sport_bottom_sheet.dart';
import 'package:athlorun/features/track/presentation/widgets/details_bottomsheet.dart';
import '../../../../config/di/dependency_injection.dart';
import '../../../../config/styles/app_colors.dart';
import '../../data/models/choose_sport_response_model.dart';
import '../bloc/track_page_cubit.dart';

class TrackPage extends StatelessWidget {
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrackPageCubit>(),
      child: const TrackPageView(),
    );
  }
}

class TrackPageView extends StatefulWidget {
  const TrackPageView({super.key});

  @override
  State<TrackPageView> createState() => _TrackPageViewState();
}

class _TrackPageViewState extends State<TrackPageView> {
  SportsList? selectedSportItem;
  late final TrackPageCubit _cubit;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<TrackPageCubit>();
    _cubit.loadAvailableSports();
    _cubit.initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        backgroundColor: AppColors.neutral10,
        centerTitle: true,
        titleWidget: BlocBuilder<TrackPageCubit, TrackPageState>(
          builder: (context, state) {
            final cubit = context.read<TrackPageCubit>();
            final selected = cubit.selectedSportItem?.name ?? 'Running';

            return GestureDetector(
              onTap: () {
                _showChooseSportBottomSheet(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.primaryBlue100, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selected[0].toUpperCase() + selected.substring(1),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryBlue100,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primaryBlue100,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _goToCurrentLocation,
        child: const Icon(Icons.my_location, color: Colors.blue),
      ),
      body: BlocBuilder<TrackPageCubit, TrackPageState>(
        builder: (context, state) {
          return state.maybeWhen(
            loadedLocation: (center) => _buildTrackingView(
              context: context,
              center: center,
              route: [],
              tracking: false,
            ),
            trackingStarted: (route, dist, dur, _) => _buildTrackingView(
              context: context,
              center: route.isNotEmpty ? route.last : LatLng(0, 0),
              route: route,
              tracking: true,
              distance: dist,
              duration: dur,
            ),
            trackingUpdated: (route, dist, dur, _) => _buildTrackingView(
              context: context,
              center: route.isNotEmpty ? route.last : LatLng(0, 0),
              route: route,
              tracking: true,
              distance: dist,
              duration: dur,
            ),
            trackingStopped: (route, dist, dur, _) => _buildTrackingView(
              context: context,
              center: route.isNotEmpty ? route.last : LatLng(0, 0),
              route: route,
              tracking: false,
              distance: dist,
              duration: dur,
            ),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildTrackingView({
    required BuildContext context,
    required LatLng center,
    required List<LatLng> route,
    required bool tracking,
    double distance = 0.0,
    Duration duration = Duration.zero,
  }) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: center, initialZoom: 16),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(points: route, strokeWidth: 5, color: Colors.blue)
              ],
            ),
            MarkerLayer(markers: _buildMarkers(route, tracking)),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tracking || route.isNotEmpty)
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  final state = context.read<TrackPageCubit>().state;

                  final isTracking = state.maybeMap(
                    trackingStarted: (_) => true,
                    trackingUpdated: (_) => true,
                    trackingStopped: (_) => false,
                    orElse: () => false,
                  );

                  if (isTracking) {
                    _cubit.stopTracking();
                    Future.delayed(const Duration(milliseconds: 200), () {
                      final updatedState = _cubit.state;
                      updatedState.maybeWhen(
                        trackingStopped: (route, dist, dur, _) {
                          _showSummary(context, dist, dur);
                        },
                        orElse: () {},
                      );
                    });
                  } else {
                    _showChooseSportBottomSheet(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: tracking ? Colors.red : Colors.green,
                    child: Text(
                      tracking ? 'Stop' : 'Start',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers(List<LatLng> route, bool tracking) {
    final List<Marker> markers = [];
    if (route.isNotEmpty) {
      markers.add(
        Marker(
          point: route.first,
          child: const Icon(Icons.place, color: Colors.green, size: 40),
        ),
      );
      if (!tracking && route.length > 1) {
        markers.add(
          Marker(
            point: route.last,
            child: const Icon(Icons.place, color: Colors.red, size: 40),
          ),
        );
      }
    }
    return markers;
  }

  void _goToCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final newLatLng = LatLng(position.latitude, position.longitude);
    _mapController.move(newLatLng, 16);
  }

  _showChooseSportBottomSheet(BuildContext context) {
    final cubit = context.read<TrackPageCubit>();

    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: ChooseSportBottomSheet(
          onSportSelected: (sport) {
            cubit.setSport(sport);
            debugPrint('[TrackPageView] ➜ Sport selected with ID: ${sport.id}');
            setState(() {
              selectedSportItem = sport;
            });
          },
        ),
      ),
    );
  }

  void _showSummary(BuildContext context, double distance, Duration duration) {
    final cubit = _cubit;
    final state = cubit.state;

    List<LatLng> route = [];
    state.maybeWhen(
      trackingStopped: (r, _, __, ___) => route = r,
      orElse: () {},
    );

    final selectedSport = cubit.selectedSportItem;
    if (selectedSport == null || selectedSport.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Sport info missing. Please select a sport.")),
      );
      return;
    }

    debugPrint('✅ Selected Sport ID in _showSummary: ${selectedSport.id}');

    final avgPace = calculateAvgPace(duration, distance);
    final calories = calculateCalories(selectedSport, distance, duration);
    final polylineString = cubit.polylineString;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PopScope(
        canPop: false,
        child: TrackingSummaryBottomSheet(
          distance: distance,
          duration: duration,
          calories: calories,
          avgPace: avgPace,
          polylinePoints: route,
          selectedSportItem: selectedSport.name,
          sportId: selectedSport.id,
        ),
      ),
    ).whenComplete(() {
      debugPrint(
          '🚀 Forwarding to /activity with sportId: ${selectedSport.id}');
      Navigator.pushNamed(
        context,
        '/activity',
        arguments: {
          'selectedSport': selectedSport,
          'polylineString': polylineString,
          'sportId': selectedSport.id,
        },
      );
      cubit.resetAfterStop();
    });
  }

  String calculateAvgPace(Duration duration, double distanceInKm) {
    if (distanceInKm <= 0 || duration.inSeconds == 0) return "0";
    final totalMinutes = duration.inSeconds / 60;
    final pace = totalMinutes / distanceInKm;
    final paceMinutes = pace.floor();
    final paceSeconds = ((pace - paceMinutes) * 60).round();
    return '${paceMinutes.toString().padLeft(2, '0')}:${paceSeconds.toString().padLeft(2, '0')}';
  }

  int calculateCalories(
      SportsList sport, double distanceInKm, Duration duration) {
    double met;
    switch (sport.name.toLowerCase()) {
      case 'running':
        met = 9.8;
        break;
      case 'walking':
        met = 3.8;
        break;
      case 'cycling':
        met = 7.5;
        break;
      default:
        met = 1.0;
    }

    const double weightKg = 70;
    final hours = duration.inSeconds / 3600.0;
    return (met * weightKg * hours).round();
  }
}
