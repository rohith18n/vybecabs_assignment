import '../../domain/entities/vehicle_type.dart';

class VehicleTypeModel extends VehicleType {
  const VehicleTypeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.baseFare,
    required super.ratePerKm,
    required super.etaMinutes,
    required super.capacity,
    required super.iconName,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      baseFare: (json['baseFare'] as num).toDouble(),
      ratePerKm: (json['ratePerKm'] as num).toDouble(),
      etaMinutes: json['etaMinutes'] as int,
      capacity: json['capacity'] as int,
      iconName: json['iconName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'baseFare': baseFare,
      'ratePerKm': ratePerKm,
      'etaMinutes': etaMinutes,
      'capacity': capacity,
      'iconName': iconName,
    };
  }

  factory VehicleTypeModel.fromEntity(VehicleType entity) {
    return VehicleTypeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      baseFare: entity.baseFare,
      ratePerKm: entity.ratePerKm,
      etaMinutes: entity.etaMinutes,
      capacity: entity.capacity,
      iconName: entity.iconName,
    );
  }
}
