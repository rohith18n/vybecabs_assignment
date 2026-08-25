import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/ride.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartLiveTrackingEvent extends TrackingEvent {
  final Ride ride;

  const StartLiveTrackingEvent(this.ride);

  @override
  List<Object?> get props => [ride];
}

class DriverApproachTickEvent extends TrackingEvent {
  final LatLng newLocation;
  final double bearing;
  final int remainingWaypointIndex;

  const DriverApproachTickEvent({
    required this.newLocation,
    required this.bearing,
    required this.remainingWaypointIndex,
  });

  @override
  List<Object?> get props => [newLocation, bearing, remainingWaypointIndex];
}

class DriverArrivedEvent extends TrackingEvent {}

class StartTripEvent extends TrackingEvent {}

class TripProgressTickEvent extends TrackingEvent {
  final LatLng newLocation;
  final double bearing;
  final int remainingWaypointIndex;

  const TripProgressTickEvent({
    required this.newLocation,
    required this.bearing,
    required this.remainingWaypointIndex,
  });

  @override
  List<Object?> get props => [newLocation, bearing, remainingWaypointIndex];
}

class CompleteTripEvent extends TrackingEvent {
  final double? rating;
  const CompleteTripEvent({this.rating});

  @override
  List<Object?> get props => [rating];
}

class ResetTrackingEvent extends TrackingEvent {}
