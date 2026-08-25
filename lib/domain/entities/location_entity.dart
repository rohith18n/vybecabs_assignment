import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final double latitude;
  final double longitude;
  final String category; // 'Airport', 'Tech Park', 'Mall', 'Station', 'Popular'

  const LocationEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  @override
  List<Object?> get props => [id, title, subtitle, latitude, longitude, category];
}
