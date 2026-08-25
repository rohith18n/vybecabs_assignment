import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoUtils {
  GeoUtils._();

  /// Calculates bearing (heading) between two coordinates in degrees [0, 360)
  static double calculateBearing(LatLng start, LatLng end) {
    final double lat1 = _degreesToRadians(start.latitude);
    final double lon1 = _degreesToRadians(start.longitude);
    final double lat2 = _degreesToRadians(end.latitude);
    final double lon2 = _degreesToRadians(end.longitude);

    final double dLon = lon2 - lon1;

    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final double radians = math.atan2(y, x);
    final double degrees = _radiansToDegrees(radians);

    return (degrees + 360) % 360;
  }

  /// Linear interpolation between two coordinates
  static LatLng interpolate(LatLng start, LatLng end, double fraction) {
    final double lat = start.latitude + (end.latitude - start.latitude) * fraction;
    final double lng = start.longitude + (end.longitude - start.longitude) * fraction;
    return LatLng(lat, lng);
  }

  /// Subdivides a path into finer points for smooth 60fps / step-wise marker animation
  static List<LatLng> subdividePath(List<LatLng> points, {int stepsBetween = 4}) {
    if (points.length < 2) return points;

    final List<LatLng> result = [];
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      result.add(start);
      for (int step = 1; step <= stepsBetween; step++) {
        final double fraction = step / (stepsBetween + 1);
        result.add(interpolate(start, end, fraction));
      }
    }
    result.add(points.last);
    return result;
  }

  /// Calculates straight-line distance in kilometers (Haversine formula)
  static double calculateDistanceInKm(LatLng p1, LatLng p2) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(p2.latitude - p1.latitude);
    final double dLon = _degreesToRadians(p2.longitude - p1.longitude);

    final double lat1 = _degreesToRadians(p1.latitude);
    final double lat2 = _degreesToRadians(p2.latitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1) * math.cos(lat2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Fits all points into a LatLngBounds with optional padding
  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double minLat = list.first.latitude;
    double maxLat = list.first.latitude;
    double minLng = list.first.longitude;
    double maxLng = list.first.longitude;

    for (final latLng in list) {
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
    }
    return LatLngBounds(
      northeast: LatLng(maxLat, maxLng),
      southwest: LatLng(minLat, minLng),
    );
  }

  static double _degreesToRadians(double degrees) => degrees * (math.pi / 180.0);
  static double _radiansToDegrees(double radians) => radians * (180.0 / math.pi);
}
