import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'geo_utils.dart';

class PathGenerator {
  PathGenerator._();

  static List<LatLng> generateSimulatedPath(
    LatLng start,
    LatLng end, {
    int waypointCount = 18,
  }) {
    final List<LatLng> points = [];
    points.add(start);

    final random = math.Random(start.latitude.toInt() + end.longitude.toInt());

    for (int i = 1; i <= waypointCount; i++) {
      final t = i / (waypointCount + 1);
      final interpolated = GeoUtils.interpolate(start, end, t);

      // Introduce small organic city road deviations
      final sinOffset = math.sin(t * math.pi) * 0.0022 * (random.nextBool() ? 1 : -1);
      final cosOffset = math.cos(t * math.pi * 2) * 0.0018 * (random.nextBool() ? 1 : -1);

      points.add(LatLng(interpolated.latitude + sinOffset, interpolated.longitude + cosOffset));
    }

    points.add(end);
    return points;
  }
}
