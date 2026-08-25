import '../../domain/entities/ride.dart';
import 'driver_model.dart';
import 'location_model.dart';
import 'vehicle_type_model.dart';

class RideModel extends Ride {
  const RideModel({
    required super.id,
    required super.pickup,
    required super.destination,
    required super.vehicleType,
    super.driver,
    required super.fare,
    required super.distanceKm,
    required super.createdAt,
    super.status,
    super.userRating,
    super.otp,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      pickup: LocationModel.fromJson(json['pickup'] as Map<String, dynamic>),
      destination: LocationModel.fromJson(json['destination'] as Map<String, dynamic>),
      vehicleType: VehicleTypeModel.fromJson(json['vehicleType'] as Map<String, dynamic>),
      driver: json['driver'] != null
          ? DriverModel.fromJson(json['driver'] as Map<String, dynamic>)
          : null,
      fare: (json['fare'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: RideStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'idle'),
        orElse: () => RideStatus.completed,
      ),
      userRating: (json['userRating'] as num?)?.toDouble(),
      otp: json['otp'] as String? ?? '4829',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickup': LocationModel.fromEntity(pickup).toJson(),
      'destination': LocationModel.fromEntity(destination).toJson(),
      'vehicleType': VehicleTypeModel.fromEntity(vehicleType).toJson(),
      'driver': driver != null ? DriverModel.fromEntity(driver!).toJson() : null,
      'fare': fare,
      'distanceKm': distanceKm,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'userRating': userRating,
      'otp': otp,
    };
  }

  factory RideModel.fromEntity(Ride entity) {
    return RideModel(
      id: entity.id,
      pickup: entity.pickup,
      destination: entity.destination,
      vehicleType: entity.vehicleType,
      driver: entity.driver,
      fare: entity.fare,
      distanceKm: entity.distanceKm,
      createdAt: entity.createdAt,
      status: entity.status,
      userRating: entity.userRating,
      otp: entity.otp,
    );
  }
}
