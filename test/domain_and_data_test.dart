import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vybecabs_assignment/core/utils/geo_utils.dart';
import 'package:vybecabs_assignment/data/datasources/local_dummy_datasource.dart';
import 'package:vybecabs_assignment/data/datasources/ride_local_datasource.dart';
import 'package:vybecabs_assignment/data/models/driver_model.dart';
import 'package:vybecabs_assignment/data/models/location_model.dart';
import 'package:vybecabs_assignment/data/models/ride_model.dart';
import 'package:vybecabs_assignment/data/models/vehicle_type_model.dart';
import 'package:vybecabs_assignment/data/repositories/ride_repository_impl.dart';
import 'package:vybecabs_assignment/domain/entities/ride.dart';

void main() {
  group('GeoUtils Tests', () {
    test('calculateBearing returns valid angles [0, 360)', () {
      const p1 = LatLng(12.9716, 77.5946);
      const p2 = LatLng(12.9784, 77.6408);
      final bearing = GeoUtils.calculateBearing(p1, p2);
      expect(bearing, greaterThanOrEqualTo(0));
      expect(bearing, lessThan(360));
    });

    test('interpolate calculates correct midpoint', () {
      const p1 = LatLng(10.0, 20.0);
      const p2 = LatLng(20.0, 40.0);
      final mid = GeoUtils.interpolate(p1, p2, 0.5);
      expect(mid.latitude, equals(15.0));
      expect(mid.longitude, equals(30.0));
    });

    test('calculateDistanceInKm returns accurate distance', () {
      const p1 = LatLng(12.9716, 77.5946); // Bangalore
      const p2 = LatLng(13.1986, 77.7066); // BLR Airport (~28-30 km straight line)
      final distance = GeoUtils.calculateDistanceInKm(p1, p2);
      expect(distance, greaterThan(20.0));
      expect(distance, lessThan(40.0));
    });

    test('subdividePath generates expected step points', () {
      const p1 = LatLng(12.0, 77.0);
      const p2 = LatLng(12.1, 77.1);
      final path = GeoUtils.subdividePath([p1, p2], stepsBetween: 3);
      expect(path.length, equals(5)); // start + 3 intermediate + end
      expect(path.first, equals(p1));
      expect(path.last, equals(p2));
    });
  });

  group('Data Models & Serialization Tests', () {
    test('LocationModel serializes and deserializes cleanly', () {
      const loc = LocationModel(
        id: 'loc_1',
        title: 'Indiranagar 100ft Rd',
        subtitle: 'Near Metro',
        latitude: 12.9784,
        longitude: 77.6408,
        category: 'Popular',
      );

      final json = loc.toJson();
      final fromJson = LocationModel.fromJson(json);

      expect(fromJson.id, equals(loc.id));
      expect(fromJson.title, equals(loc.title));
      expect(fromJson.latitude, equals(loc.latitude));
      expect(fromJson.longitude, equals(loc.longitude));
    });

    test('VehicleTypeModel calculates fare correctly', () {
      const vehicle = VehicleTypeModel(
        id: 'vybe_go',
        name: 'Vybe Go',
        description: 'Hatchback',
        baseFare: 40.0,
        ratePerKm: 15.0,
        etaMinutes: 3,
        capacity: 4,
        iconName: 'hatchback',
      );

      final fare = vehicle.calculateFare(10.0);
      expect(fare, equals(40.0 + (10.0 * 15.0))); // 190.0
    });

    test('DriverModel serializes and deserializes cleanly', () {
      const driver = DriverModel(
        id: 'drv_1',
        name: 'Rajesh Verma',
        photoUrl: 'https://example.com/photo.jpg',
        carModel: 'Tata Nexon EV',
        carNumber: 'KA 01 MJ 4829',
        rating: 4.95,
        totalTrips: 3420,
        phone: '+91 98450 12345',
        latitude: 12.973,
        longitude: 77.599,
      );

      final json = driver.toJson();
      final fromJson = DriverModel.fromJson(json);

      expect(fromJson.name, equals('Rajesh Verma'));
      expect(fromJson.carNumber, equals('KA 01 MJ 4829'));
      expect(fromJson.rating, equals(4.95));
    });

    test('RideModel JSON roundtrip works flawlessly', () {
      const pickup = LocationModel(
        id: 'p1',
        title: 'Indiranagar',
        subtitle: '100ft Road',
        latitude: 12.9784,
        longitude: 77.6408,
        category: 'Popular',
      );
      const dest = LocationModel(
        id: 'd1',
        title: 'Airport',
        subtitle: 'Terminal 1',
        latitude: 13.1986,
        longitude: 77.7066,
        category: 'Airport',
      );
      const vehicle = VehicleTypeModel(
        id: 'vybe_ev',
        name: 'Vybe EV Prime',
        description: 'Electric',
        baseFare: 75.0,
        ratePerKm: 19.0,
        etaMinutes: 2,
        capacity: 4,
        iconName: 'ev',
      );

      final ride = RideModel(
        id: 'ride_test_123',
        pickup: pickup,
        destination: dest,
        vehicleType: vehicle,
        fare: 680.0,
        distanceKm: 31.8,
        createdAt: DateTime(2026, 8, 25, 14, 30),
        status: RideStatus.completed,
        userRating: 5.0,
      );

      final json = ride.toJson();
      final parsed = RideModel.fromJson(json);

      expect(parsed.id, equals('ride_test_123'));
      expect(parsed.fare, equals(680.0));
      expect(parsed.status, equals(RideStatus.completed));
      expect(parsed.userRating, equals(5.0));
    });
  });

  group('Ride Repository & Dummy Data Tests', () {
    late RideRepositoryImpl repository;
    late RideLocalDataSource localDataSource;

    setUp(() {
      localDataSource = RideLocalDataSource();
      repository = RideRepositoryImpl(localDataSource: localDataSource);
    });

    test('getDummyLocations returns 6 realistic hotspots', () async {
      final hotspots = await repository.getDummyLocations();
      expect(hotspots.length, equals(6));
      expect(hotspots.first.title, contains('Indiranagar'));
    });

    test('getVehicleTypes returns 4 distinct categories', () async {
      final vehicles = await repository.getVehicleTypes();
      expect(vehicles.length, equals(4));
      expect(vehicles.map((v) => v.name), contains('Vybe EV Prime'));
    });

    test('getRideHistory returns past rides and preserves new completed rides', () async {
      final initialHistory = await repository.getRideHistory();
      expect(initialHistory.length, greaterThanOrEqualTo(6));

      final newRide = Ride(
        id: 'new_completed_ride_99',
        pickup: LocalDummyDataSource.dummyLocations[0],
        destination: LocalDummyDataSource.dummyLocations[1],
        vehicleType: LocalDummyDataSource.dummyVehicles[0],
        fare: 220.0,
        distanceKm: 8.5,
        createdAt: DateTime.now().add(const Duration(minutes: 1)),
        status: RideStatus.completed,
      );

      await repository.saveCompletedRide(newRide);

      final updatedHistory = await repository.getRideHistory();
      expect(updatedHistory.length, equals(initialHistory.length + 1));
      expect(updatedHistory.first.id, equals('new_completed_ride_99'));
    });
  });
}
