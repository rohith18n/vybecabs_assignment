import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/utils/geo_utils.dart';

class TrackingCalculator {
  TrackingCalculator._();

  static double calculateBearingForWaypoint(
    List<LatLng> path,
    int index,
  ) {
    if (path.isEmpty) return 0.0;
    if (index >= path.length - 1) return 0.0;
    return GeoUtils.calculateBearing(path[index], path[index + 1]);
  }

  static ({int etaMinutes, int etaSeconds}) calculateApproachEta(
    int currentIndex,
    int totalPoints,
  ) {
    final double fractionRemaining =
        (totalPoints - currentIndex) / totalPoints;
    const int totalSeconds = 120;
    final int remainingSeconds =
        (fractionRemaining * totalSeconds).round().clamp(5, totalSeconds);
    final int remainingEta = (remainingSeconds / 60).ceil().clamp(1, 3);
    return (etaMinutes: remainingEta, etaSeconds: remainingSeconds);
  }

  static ({int etaMinutes, int etaSeconds, double progress}) calculateTripEta(
    int currentIndex,
    int totalPoints,
  ) {
    final double progress = currentIndex / (totalPoints - 1);
    const int totalTripSeconds = 360;
    final int remainingTripSeconds =
        ((1.0 - progress) * totalTripSeconds).round().clamp(5, totalTripSeconds);
    final int remainingEta = (remainingTripSeconds / 60).ceil().clamp(1, 6);
    return (
      etaMinutes: remainingEta,
      etaSeconds: remainingTripSeconds,
      progress: progress,
    );
  }
}
