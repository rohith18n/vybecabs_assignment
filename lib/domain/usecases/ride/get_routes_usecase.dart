import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../repositories/ride_repository.dart';

class GetPickupRouteUseCase {
  final IRideRepository repository;

  GetPickupRouteUseCase(this.repository);

  Future<List<LatLng>> call(LatLng driverStart, LatLng pickup) {
    return repository.getPickupRoutePolyline(driverStart, pickup);
  }
}

class GetTripRouteUseCase {
  final IRideRepository repository;

  GetTripRouteUseCase(this.repository);

  Future<List<LatLng>> call(LatLng pickup, LatLng destination) {
    return repository.getTripRoutePolyline(pickup, destination);
  }
}
