import 'package:equatable/equatable.dart';
import 'driver.dart';
import 'location_entity.dart';
import 'vehicle_type.dart';

enum RideStatus {
  idle,
  searching,
  driverAssigned,
  driverArrived,
  inProgress,
  completed,
  cancelled,
}

class Ride extends Equatable {
  final String id;
  final LocationEntity pickup;
  final LocationEntity destination;
  final VehicleType vehicleType;
  final Driver? driver;
  final double fare;
  final double distanceKm;
  final DateTime createdAt;
  final RideStatus status;
  final double? userRating;
  final String? otp;

  const Ride({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.vehicleType,
    this.driver,
    required this.fare,
    required this.distanceKm,
    required this.createdAt,
    this.status = RideStatus.idle,
    this.userRating,
    this.otp = '4829',
  });

  Ride copyWith({
    String? id,
    LocationEntity? pickup,
    LocationEntity? destination,
    VehicleType? vehicleType,
    Driver? driver,
    double? fare,
    double? distanceKm,
    DateTime? createdAt,
    RideStatus? status,
    double? userRating,
    String? otp,
  }) {
    return Ride(
      id: id ?? this.id,
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      vehicleType: vehicleType ?? this.vehicleType,
      driver: driver ?? this.driver,
      fare: fare ?? this.fare,
      distanceKm: distanceKm ?? this.distanceKm,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      userRating: userRating ?? this.userRating,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pickup,
        destination,
        vehicleType,
        driver,
        fare,
        distanceKm,
        createdAt,
        status,
        userRating,
        otp,
      ];
}
