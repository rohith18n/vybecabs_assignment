import '../../domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    required super.photoUrl,
    required super.carModel,
    required super.carNumber,
    required super.rating,
    required super.totalTrips,
    required super.phone,
    required super.latitude,
    required super.longitude,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      carModel: json['carModel'] as String,
      carNumber: json['carNumber'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalTrips: json['totalTrips'] as int,
      phone: json['phone'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'carModel': carModel,
      'carNumber': carNumber,
      'rating': rating,
      'totalTrips': totalTrips,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory DriverModel.fromEntity(Driver entity) {
    return DriverModel(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      carModel: entity.carModel,
      carNumber: entity.carNumber,
      rating: entity.rating,
      totalTrips: entity.totalTrips,
      phone: entity.phone,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
