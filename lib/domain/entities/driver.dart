import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String name;
  final String photoUrl;
  final String carModel;
  final String carNumber;
  final double rating;
  final int totalTrips;
  final String phone;
  final double latitude;
  final double longitude;

  const Driver({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.carModel,
    required this.carNumber,
    required this.rating,
    required this.totalTrips,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        photoUrl,
        carModel,
        carNumber,
        rating,
        totalTrips,
        phone,
        latitude,
        longitude,
      ];
}
