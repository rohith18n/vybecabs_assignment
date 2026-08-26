import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/driver.dart';
import '../../../domain/entities/ride.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

/// Phase 1: Driver is driving towards the Rider's Pickup point
class DriverApproachingState extends TrackingState {
  final Ride ride;
  final Driver driver;
  final LatLng driverLocation;
  final double bearing;
  final List<LatLng> fullPolyline;
  final List<LatLng> remainingPolyline;
  final int etaMinutes;
  final int etaSeconds;

  const DriverApproachingState({
    required this.ride,
    required this.driver,
    required this.driverLocation,
    required this.bearing,
    required this.fullPolyline,
    required this.remainingPolyline,
    required this.etaMinutes,
    this.etaSeconds = 117,
  });

  @override
  List<Object?> get props => [
        ride,
        driver,
        driverLocation,
        bearing,
        fullPolyline,
        remainingPolyline,
        etaMinutes,
        etaSeconds,
      ];
}

/// Phase 2: Driver has arrived at the Pickup point (Waiting for rider / OTP check)
class DriverArrivedState extends TrackingState {
  final Ride ride;
  final Driver driver;
  final LatLng pickupLocation;

  const DriverArrivedState({
    required this.ride,
    required this.driver,
    required this.pickupLocation,
  });

  @override
  List<Object?> get props => [ride, driver, pickupLocation];
}

/// Phase 3: Rider entered cab, trip started, car navigating along route towards Destination
class TripInProgressState extends TrackingState {
  final Ride ride;
  final Driver driver;
  final LatLng carLocation;
  final double bearing;
  final List<LatLng> fullPolyline;
  final List<LatLng> remainingPolyline;
  final int etaMinutes;
  final int etaSeconds;
  final double progressPercent; // 0.0 to 1.0

  const TripInProgressState({
    required this.ride,
    required this.driver,
    required this.carLocation,
    required this.bearing,
    required this.fullPolyline,
    required this.remainingPolyline,
    required this.etaMinutes,
    this.etaSeconds = 342,
    required this.progressPercent,
  });

  @override
  List<Object?> get props => [
        ride,
        driver,
        carLocation,
        bearing,
        fullPolyline,
        remainingPolyline,
        etaMinutes,
        etaSeconds,
        progressPercent,
      ];
}

/// Phase 4: Trip ended, show completion screen with receipt & rating
class TripCompletedState extends TrackingState {
  final Ride completedRide;
  final int selectedRating;
  final int? selectedTip;

  const TripCompletedState(
    this.completedRide, {
    this.selectedRating = 5,
    this.selectedTip,
  });

  TripCompletedState copyWith({
    Ride? completedRide,
    int? selectedRating,
    int? Function()? selectedTip,
  }) {
    return TripCompletedState(
      completedRide ?? this.completedRide,
      selectedRating: selectedRating ?? this.selectedRating,
      selectedTip: selectedTip != null ? selectedTip() : this.selectedTip,
    );
  }

  @override
  List<Object?> get props => [completedRide, selectedRating, selectedTip];
}
