import 'package:equatable/equatable.dart';
import '../../../domain/entities/driver.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/entities/ride.dart';
import '../../../domain/entities/vehicle_type.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingConfigured extends BookingState {
  final LocationEntity pickup;
  final LocationEntity destination;
  final List<VehicleType> availableVehicles;
  final VehicleType selectedVehicle;
  final double distanceKm;
  final double estimatedFare;

  const BookingConfigured({
    required this.pickup,
    required this.destination,
    required this.availableVehicles,
    required this.selectedVehicle,
    required this.distanceKm,
    required this.estimatedFare,
  });

  BookingConfigured copyWith({
    LocationEntity? pickup,
    LocationEntity? destination,
    List<VehicleType>? availableVehicles,
    VehicleType? selectedVehicle,
    double? distanceKm,
    double? estimatedFare,
  }) {
    return BookingConfigured(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedFare: estimatedFare ?? this.estimatedFare,
    );
  }

  @override
  List<Object?> get props => [
        pickup,
        destination,
        availableVehicles,
        selectedVehicle,
        distanceKm,
        estimatedFare,
      ];
}

class SearchingDriverState extends BookingState {
  final Ride pendingRide;
  final String statusText;

  const SearchingDriverState({
    required this.pendingRide,
    this.statusText = 'Contacting nearby top-rated drivers...',
  });

  SearchingDriverState copyWith({
    Ride? pendingRide,
    String? statusText,
  }) {
    return SearchingDriverState(
      pendingRide: pendingRide ?? this.pendingRide,
      statusText: statusText ?? this.statusText,
    );
  }

  @override
  List<Object?> get props => [pendingRide, statusText];
}

class DriverMatchedState extends BookingState {
  final Ride ride;
  final Driver driver;

  const DriverMatchedState({
    required this.ride,
    required this.driver,
  });

  @override
  List<Object?> get props => [ride, driver];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingCancelledState extends BookingState {}
