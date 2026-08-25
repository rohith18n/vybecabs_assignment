import 'package:equatable/equatable.dart';
import '../../../domain/entities/driver.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/entities/ride.dart';
import '../../../domain/entities/vehicle_type.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class ConfigureBookingEvent extends BookingEvent {
  final LocationEntity pickup;
  final LocationEntity destination;

  const ConfigureBookingEvent({
    required this.pickup,
    required this.destination,
  });

  @override
  List<Object?> get props => [pickup, destination];
}

class SelectVehicleTypeEvent extends BookingEvent {
  final VehicleType vehicleType;

  const SelectVehicleTypeEvent(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}

class RequestBookRideEvent extends BookingEvent {}

class DriverFoundEvent extends BookingEvent {
  final Driver driver;
  final Ride ride;

  const DriverFoundEvent({
    required this.driver,
    required this.ride,
  });

  @override
  List<Object?> get props => [driver, ride];
}

class CancelBookingEvent extends BookingEvent {}

class ResetBookingEvent extends BookingEvent {}
