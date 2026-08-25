import 'package:equatable/equatable.dart';

class VehicleType extends Equatable {
  final String id;
  final String name;
  final String description;
  final double baseFare;
  final double ratePerKm;
  final int etaMinutes;
  final int capacity;
  final String iconName; // 'sedan', 'suv', 'ev', 'bike'

  const VehicleType({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.ratePerKm,
    required this.etaMinutes,
    required this.capacity,
    required this.iconName,
  });

  double calculateFare(double distanceInKm) {
    return baseFare + (distanceInKm * ratePerKm);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        baseFare,
        ratePerKm,
        etaMinutes,
        capacity,
        iconName,
      ];
}
