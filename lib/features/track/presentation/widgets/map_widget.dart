import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng center;
  final List<LatLng> route;
  final List<Marker> markers;

  const MapWidget({
    super.key,
    required this.center,
    required this.route,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: 16),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        PolylineLayer(
          polylines: [
            Polyline(points: route, color: Colors.blue, strokeWidth: 5),
          ],
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
