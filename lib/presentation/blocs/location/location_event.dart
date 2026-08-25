import 'package:equatable/equatable.dart';
import '../../../domain/entities/location_entity.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocationAndHotspots extends LocationEvent {}

class SelectDestinationEvent extends LocationEvent {
  final LocationEntity destination;
  const SelectDestinationEvent(this.destination);

  @override
  List<Object?> get props => [destination];
}

class SelectPickupEvent extends LocationEvent {
  final LocationEntity pickup;
  const SelectPickupEvent(this.pickup);

  @override
  List<Object?> get props => [pickup];
}

class ClearDestinationEvent extends LocationEvent {}
