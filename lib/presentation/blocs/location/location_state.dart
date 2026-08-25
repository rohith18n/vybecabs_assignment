import 'package:equatable/equatable.dart';
import '../../../domain/entities/location_entity.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationEntity currentPickup;
  final LocationEntity? selectedDestination;
  final List<LocationEntity> hotspots;

  const LocationLoaded({
    required this.currentPickup,
    this.selectedDestination,
    required this.hotspots,
  });

  LocationLoaded copyWith({
    LocationEntity? currentPickup,
    LocationEntity? selectedDestination,
    List<LocationEntity>? hotspots,
    bool clearDestination = false,
  }) {
    return LocationLoaded(
      currentPickup: currentPickup ?? this.currentPickup,
      selectedDestination:
          clearDestination ? null : (selectedDestination ?? this.selectedDestination),
      hotspots: hotspots ?? this.hotspots,
    );
  }

  @override
  List<Object?> get props => [currentPickup, selectedDestination, hotspots];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
