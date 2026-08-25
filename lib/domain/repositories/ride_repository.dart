import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entities/driver.dart';
import '../entities/location_entity.dart';
import '../entities/ride.dart';
import '../entities/vehicle_type.dart';

abstract class IRideRepository {
  Future<List<LocationEntity>> getDummyLocations();
  Future<List<VehicleType>> getVehicleTypes();
  Future<Driver> findDriverForRide(Ride ride);
  Future<List<LatLng>> getPickupRoutePolyline(LatLng driverStart, LatLng pickup);
  Future<List<LatLng>> getTripRoutePolyline(LatLng pickup, LatLng destination);
  Future<List<Ride>> getRideHistory();
  Future<void> saveCompletedRide(Ride ride);
}
