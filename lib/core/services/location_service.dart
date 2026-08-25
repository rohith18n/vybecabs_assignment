import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  // Default fallback location (Bangalore Central - MG Road / Church St)
  static const LatLng defaultLocation = LatLng(12.9716, 77.5946);

  /// Requests permissions and retrieves current position, falling back safely if unavailable.
  Future<LatLng> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return defaultLocation;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return defaultLocation;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return defaultLocation;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return defaultLocation;
    }
  }
}
