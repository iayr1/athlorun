import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:athlorun/config/themes/app_theme.dart';
import 'package:athlorun/core/services/metrics_store.dart';
import 'package:athlorun/core/utils/formatters.dart';
import 'package:athlorun/features/activity/presentation/pages/activity_history_page.dart';

enum _SessionState { idle, recording, paused }

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  static const _fallbackCenter = LatLng(20.5937, 78.9629);

  final MapController _mapController = MapController();
  final ValueNotifier<Duration> _elapsed = ValueNotifier(Duration.zero);

  StreamSubscription<Position>? _positionSub;
  Timer? _ticker;

  bool _mapReady = false;
  bool _locating = false;
  bool _followUser = true;
  LatLng? _current;
  _SessionState _state = _SessionState.idle;
  ActivityKind _kind = ActivityKind.run;
  DateTime? _startedAt;
  DateTime? _resumedAt;
  Duration _accumulated = Duration.zero;
  double _distanceKm = 0;
  final List<LatLng> _route = [];

  @override
  void initState() {
    super.initState();
    unawaited(_locate());
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _ticker?.cancel();
    _elapsed.dispose();
    MetricsStore.instance.gpsSessionActive = false;
    super.dispose();
  }

  Future<bool> _ensurePermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showMessage('Turn on location services to track workouts.',
            action: const SnackBarAction(
              label: 'Settings',
              onPressed: Geolocator.openLocationSettings,
            ));
        return false;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        _showMessage('Location permission is blocked.',
            action: const SnackBarAction(
              label: 'Settings',
              onPressed: Geolocator.openAppSettings,
            ));
        return false;
      }
      if (permission == LocationPermission.denied) {
        _showMessage('Location permission is required for tracking.');
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('TrackPage: location unavailable ($e)');
      _showMessage('Unable to access location services.');
      return false;
    }
  }

  Future<void> _locate() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      if (!await _ensurePermission()) return;
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      final here = LatLng(position.latitude, position.longitude);
      setState(() {
        _current = here;
        _followUser = true;
      });
      _moveCamera(here, 16.5);
    } catch (e) {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null && mounted) {
        final here = LatLng(last.latitude, last.longitude);
        setState(() => _current = here);
        _moveCamera(here, 16);
      } else {
        _showMessage('Could not get your location. Try again outdoors.');
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _moveCamera(LatLng target, [double? zoom]) {
    if (!_mapReady) return;
    _mapController.move(target, zoom ?? _mapController.camera.zoom);
  }

  Future<void> _start() async {
    if (!await _ensurePermission()) return;
    final now = DateTime.now();
    setState(() {
      _state = _SessionState.recording;
      _startedAt = now;
      _resumedAt = now;
      _accumulated = Duration.zero;
      _distanceKm = 0;
      _route.clear();
      _followUser = true;
      if (_current != null) _route.add(_current!);
    });
    _elapsed.value = Duration.zero;
    MetricsStore.instance.gpsSessionActive = true;

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state == _SessionState.recording && _resumedAt != null) {
        _elapsed.value = _accumulated + DateTime.now().difference(_resumedAt!);
      }
    });

    await _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 4,
      ),
    ).listen(
      _onPosition,
      onError: (Object _) => _showMessage('Lost GPS signal. Retrying…'),
    );
  }

  void _onPosition(Position position) {
    if (!mounted) return;
    final next = LatLng(position.latitude, position.longitude);
    setState(() {
      _current = next;
      if (_state != _SessionState.recording) return;
      // Skip very inaccurate fixes so the route does not zig-zag.
      if (position.accuracy > 35) return;
      if (_route.isNotEmpty) {
        final prev = _route.last;
        final meters = Geolocator.distanceBetween(
          prev.latitude,
          prev.longitude,
          next.latitude,
          next.longitude,
        );
        _distanceKm += meters / 1000;
      }
      _route.add(next);
    });
    if (_followUser) _moveCamera(next);
  }

  void _pause() {
    if (_resumedAt != null) {
      _accumulated += DateTime.now().difference(_resumedAt!);
    }
    _elapsed.value = _accumulated;
    setState(() {
      _state = _SessionState.paused;
      _resumedAt = null;
    });
  }

  void _resume() {
    setState(() {
      _state = _SessionState.recording;
      _resumedAt = DateTime.now();
      // Start a fresh segment so the paused gap is not counted as distance.
      if (_current != null) _route.add(_current!);
    });
  }

  Future<void> _finish() async {
    if (_state == _SessionState.recording) _pause();
    final duration = _accumulated;
    final store = MetricsStore.instance;
    final activity = TrackedActivity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      kind: _kind,
      startedAt: _startedAt ?? DateTime.now(),
      duration: duration,
      distanceKm: _distanceKm,
      calories: store.caloriesFor(_kind, _distanceKm),
      route: [
        for (final p in _route) [p.latitude, p.longitude]
      ],
    );

    final save = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _SummarySheet(activity: activity),
    );
    if (save == null) return; // Sheet dismissed: keep the session paused.

    _ticker?.cancel();
    await _positionSub?.cancel();
    _positionSub = null;
    store.gpsSessionActive = false;
    if (save) {
      await store.addActivity(activity);
      _showMessage('${activity.kind.label} saved to your history 🎉');
    }
    if (!mounted) return;
    setState(() {
      _state = _SessionState.idle;
      _accumulated = Duration.zero;
      _distanceKm = 0;
      _route.clear();
    });
    _elapsed.value = Duration.zero;
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), action: action));
  }

  @override
  Widget build(BuildContext context) {
    final current = _current;
    final color = activityColor(_kind);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: current ?? _fallbackCenter,
              initialZoom: current == null ? 4.5 : 16,
              onMapReady: () {
                _mapReady = true;
                if (_current != null) _moveCamera(_current!, 16.5);
              },
              onPositionChanged: (_, hasGesture) {
                if (hasGesture && _followUser) {
                  setState(() => _followUser = false);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.athlorun.app',
              ),
              if (_route.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: List.of(_route),
                      strokeWidth: 7,
                      color: color,
                      borderColor: Colors.white,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (current != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: current,
                      width: 64,
                      height: 64,
                      child: _UserMarker(color: color),
                    ),
                  ],
                ),
            ],
          ),
          // Soft fade so the header stays readable over the map.
          IgnorePointer(
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppPalette.background.withValues(alpha: 0.95),
                    AppPalette.background.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          switch (_state) {
                            _SessionState.idle => 'Ready to move?',
                            _SessionState.recording => 'Recording',
                            _SessionState.paused => 'Paused',
                          },
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          _state == _SessionState.idle
                              ? 'Pick an activity and hit start'
                              : '${_kind.label} in progress',
                          style: const TextStyle(color: AppPalette.inkSoft),
                        ),
                      ],
                    ),
                  ),
                  _RoundButton(
                    icon: Icons.history_rounded,
                    tooltip: 'History',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ActivityHistoryPage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RoundButton(
                    icon: _followUser
                        ? Icons.my_location_rounded
                        : Icons.location_searching_rounded,
                    tooltip: 'Recenter',
                    loading: _locating,
                    onTap: () {
                      if (_current != null) {
                        setState(() => _followUser = true);
                        _moveCamera(_current!, 16.5);
                      } else {
                        _locate();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _ControlPanel(
              state: _state,
              kind: _kind,
              elapsed: _elapsed,
              distanceKm: _distanceKm,
              onKindChanged: (k) => setState(() => _kind = k),
              onStart: _start,
              onPause: _pause,
              onResume: _resume,
              onFinish: _finish,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMarker extends StatelessWidget {
  final Color color;

  const _UserMarker({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.18),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool loading;

  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        shadowColor: Colors.black26,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: loading ? null : onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : Icon(icon, color: AppPalette.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  final _SessionState state;
  final ActivityKind kind;
  final ValueListenable<Duration> elapsed;
  final double distanceKm;
  final ValueChanged<ActivityKind> onKindChanged;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;

  const _ControlPanel({
    required this.state,
    required this.kind,
    required this.elapsed,
    required this.distanceKm,
    required this.onKindChanged,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final color = activityColor(kind);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state == _SessionState.idle)
              Row(
                children: [
                  for (final k in ActivityKind.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _KindChip(
                          kind: k,
                          selected: k == kind,
                          onTap: () => onKindChanged(k),
                        ),
                      ),
                    ),
                ],
              )
            else
              ValueListenableBuilder<Duration>(
                valueListenable: elapsed,
                builder: (context, value, _) {
                  final pace = distanceKm > 0.01
                      ? value.inSeconds / 60 / distanceKm
                      : null;
                  return Column(
                    children: [
                      Text(
                        Fmt.duration(value),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.5,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _Metric(
                            label: 'Distance',
                            value: Fmt.km(distanceKm),
                            unit: 'km',
                          ),
                          _divider(),
                          _Metric(
                            label: 'Avg pace',
                            value: Fmt.pace(pace),
                            unit: '/km',
                          ),
                          _divider(),
                          _Metric(
                            label: 'Calories',
                            value: MetricsStore.instance
                                .caloriesFor(kind, distanceKm)
                                .toStringAsFixed(0),
                            unit: 'kcal',
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 18),
            switch (state) {
              _SessionState.idle => SizedBox(
                  width: double.infinity,
                  child: _GradientButton(
                    gradient: LinearGradient(
                      colors: [color, Color.lerp(color, Colors.black, 0.2)!],
                    ),
                    icon: Icons.play_arrow_rounded,
                    label: 'Start ${kind.label.toLowerCase()}',
                    onTap: onStart,
                  ),
                ),
              _SessionState.recording => Row(
                  children: [
                    Expanded(
                      child: _GradientButton(
                        gradient: const LinearGradient(
                          colors: [AppPalette.amber, AppPalette.orange],
                        ),
                        icon: Icons.pause_rounded,
                        label: 'Pause',
                        onTap: onPause,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GradientButton(
                        gradient: const LinearGradient(
                          colors: [AppPalette.red, Color(0xFFBE123C)],
                        ),
                        icon: Icons.stop_rounded,
                        label: 'Finish',
                        onTap: onFinish,
                      ),
                    ),
                  ],
                ),
              _SessionState.paused => Row(
                  children: [
                    Expanded(
                      child: _GradientButton(
                        gradient: AppPalette.fresh,
                        icon: Icons.play_arrow_rounded,
                        label: 'Resume',
                        onTap: onResume,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _GradientButton(
                        gradient: const LinearGradient(
                          colors: [AppPalette.red, Color(0xFFBE123C)],
                        ),
                        icon: Icons.flag_rounded,
                        label: 'Finish',
                        onTap: onFinish,
                      ),
                    ),
                  ],
                ),
            },
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 34,
        color: AppPalette.line,
      );
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _Metric({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPalette.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppPalette.muted),
          ),
        ],
      ),
    );
  }
}

class _KindChip extends StatelessWidget {
  final ActivityKind kind;
  final bool selected;
  final VoidCallback onTap;

  const _KindChip({
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = activityColor(kind);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              selected ? color.withValues(alpha: 0.12) : AppPalette.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.6,
          ),
        ),
        child: Column(
          children: [
            Icon(activityIcon(kind),
                color: selected ? color : AppPalette.muted, size: 26),
            const SizedBox(height: 4),
            Text(
              kind.label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? color : AppPalette.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GradientButton({
    required this.gradient,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummarySheet extends StatelessWidget {
  final TrackedActivity activity;

  const _SummarySheet({required this.activity});

  @override
  Widget build(BuildContext context) {
    final color = activityColor(activity.kind);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.emoji_events_rounded, color: color, size: 38),
            ),
            const SizedBox(height: 14),
            Text(
              'Great ${activity.kind.label.toLowerCase()}!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              'Here\'s how you did',
              style: TextStyle(color: AppPalette.inkSoft),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _Metric(
                  label: 'Distance',
                  value: Fmt.km(activity.distanceKm),
                  unit: 'km',
                ),
                _Metric(
                  label: 'Time',
                  value: Fmt.duration(activity.duration),
                  unit: '',
                ),
                _Metric(
                  label: 'Pace',
                  value: Fmt.pace(activity.paceMinPerKm),
                  unit: '/km',
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: color),
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save workout'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Keep going'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPalette.red,
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Discard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
