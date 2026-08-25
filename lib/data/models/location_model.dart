import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.latitude,
    required super.longitude,
    required super.category,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String? ?? 'Popular',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      latitude: entity.latitude,
      longitude: entity.longitude,
      category: entity.category,
    );
  }
}
