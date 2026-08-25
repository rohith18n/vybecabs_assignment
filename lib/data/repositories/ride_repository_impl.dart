import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/driver.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/ride.dart';
import '../../domain/entities/vehicle_type.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/local_dummy_datasource.dart';
import '../datasources/ride_local_datasource.dart';
import '../models/ride_model.dart';

class RideRepositoryImpl implements IRideRepository {
  final IRideLocalDataSource localDataSource;

  RideRepositoryImpl({required this.localDataSource});

  @override
  Future<List<LocationEntity>> getDummyLocations() async {
    // Fast local return
    return LocalDummyDataSource.dummyLocations;
  }

  @override
  Future<List<VehicleType>> getVehicleTypes() async {
    return LocalDummyDataSource.dummyVehicles;
  }

  @override
  Future<Driver> findDriverForRide(Ride ride) async {
    // Pick driver matching location or random top driver
    final drivers = LocalDummyDataSource.dummyDrivers;
    final random = math.Random();
    final driver = drivers[random.nextInt(drivers.length)];
    return driver;
  }

  @override
  Future<List<LatLng>> getPickupRoutePolyline(LatLng driverStart, LatLng pickup) async {
    return LocalDummyDataSource.generateSimulatedPath(driverStart, pickup, waypointCount: 14);
  }

  @override
  Future<List<LatLng>> getTripRoutePolyline(LatLng pickup, LatLng destination) async {
    return LocalDummyDataSource.generateSimulatedPath(pickup, destination, waypointCount: 22);
  }

  @override
  Future<List<Ride>> getRideHistory() async {
    return await localDataSource.getRideHistory();
  }

  @override
  Future<void> saveCompletedRide(Ride ride) async {
    await localDataSource.saveCompletedRide(RideModel.fromEntity(ride));
  }
}
