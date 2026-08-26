import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';

class MapOverlayBuilder {
  MapOverlayBuilder._();

  static Set<Circle> buildCircles({
    LatLng? carLocation,
    LatLng? pickupLocation,
    double? auraRadius,
    double? auraOpacity,
  }) {
    final Set<Circle> circles = {};

    // Bouncing animated car aura
    if (carLocation != null && auraRadius != null && auraOpacity != null) {
      circles.add(
        Circle(
          circleId: const CircleId('car_bouncing_aura'),
          center: carLocation,
          radius: auraRadius,
          fillColor: AppColors.primary.withValues(alpha: auraOpacity),
          strokeColor: AppColors.primary.withValues(alpha: auraOpacity * 1.5),
          strokeWidth: 1,
          zIndex: 4,
        ),
      );
    }

    // Pickup aura
    if (pickupLocation != null) {
      circles.add(
        Circle(
          circleId: const CircleId('pickup_aura'),
          center: pickupLocation,
          radius: 35,
          fillColor: AppColors.success.withValues(alpha: 0.15),
          strokeColor: AppColors.success.withValues(alpha: 0.5),
          strokeWidth: 1,
          zIndex: 2,
        ),
      );
    }

    return circles;
  }

  static Set<Marker> buildMarkers({
    LatLng? pickupLocation,
    LatLng? dropLocation,
    LatLng? carLocation,
    double carBearing = 0.0,
    BitmapDescriptor? pickupIcon,
    BitmapDescriptor? dropIcon,
    BitmapDescriptor? carIcon,
  }) {
    final Set<Marker> markers = {};

    // Pickup Marker
    if (pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup_marker'),
          position: pickupLocation,
          icon: pickupIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          anchor: const Offset(0.5, 0.9),
          zIndexInt: 5,
        ),
      );
    }

    // Drop Location Marker
    if (dropLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('drop_marker'),
          position: dropLocation,
          icon: dropIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
          anchor: const Offset(0.5, 0.9),
          zIndexInt: 5,
        ),
      );
    }

    // Animated Car Marker
    if (carLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_car_marker'),
          position: carLocation,
          rotation: carBearing,
          icon: carIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: const InfoWindow(title: 'Vybe Captain'),
          anchor: const Offset(0.5, 0.5),
          flat: true,
          zIndexInt: 10,
        ),
      );
    }

    return markers;
  }

  static Set<Polyline> buildPolylines({
    List<LatLng>? polylineCoordinates,
    Color polylineColor = AppColors.primary,
  }) {
    final Set<Polyline> polylines = {};

    if (polylineCoordinates != null && polylineCoordinates.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_polyline'),
          points: polylineCoordinates,
          color: polylineColor,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    return polylines;
  }
}
