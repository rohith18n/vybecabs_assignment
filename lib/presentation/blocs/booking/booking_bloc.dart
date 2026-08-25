import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/geo_utils.dart';
import '../../../domain/entities/ride.dart';
import '../../../domain/usecases/ride/find_driver_usecase.dart';
import '../../../domain/usecases/ride/get_vehicle_types_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;
  final FindDriverUseCase _findDriverUseCase;
  final Uuid _uuid = const Uuid();

  Timer? _searchTimer;

  BookingBloc({
    required GetVehicleTypesUseCase getVehicleTypesUseCase,
    required FindDriverUseCase findDriverUseCase,
  })  : _getVehicleTypesUseCase = getVehicleTypesUseCase,
        _findDriverUseCase = findDriverUseCase,
        super(BookingInitial()) {
    on<ConfigureBookingEvent>(_onConfigureBooking);
    on<SelectVehicleTypeEvent>(_onSelectVehicleType);
    on<RequestBookRideEvent>(_onRequestBookRide);
    on<DriverFoundEvent>(_onDriverFound);
    on<CancelBookingEvent>(_onCancelBooking);
    on<ResetBookingEvent>(_onResetBooking);
  }

  Future<void> _onConfigureBooking(
    ConfigureBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final vehicles = await _getVehicleTypesUseCase();
      final double distanceKm = GeoUtils.calculateDistanceInKm(
        event.pickup.latLng,
        event.destination.latLng,
      );

      final selectedVehicle = vehicles.first;
      final double fare = selectedVehicle.calculateFare(distanceKm);

      emit(BookingConfigured(
        pickup: event.pickup,
        destination: event.destination,
        availableVehicles: vehicles,
        selectedVehicle: selectedVehicle,
        distanceKm: distanceKm,
        estimatedFare: fare,
      ));
    } catch (e) {
      emit(BookingError('Failed to configure booking: ${e.toString()}'));
    }
  }

  void _onSelectVehicleType(
    SelectVehicleTypeEvent event,
    Emitter<BookingState> emit,
  ) {
    if (state is BookingConfigured) {
      final current = state as BookingConfigured;
      final double newFare = event.vehicleType.calculateFare(current.distanceKm);
      emit(current.copyWith(
        selectedVehicle: event.vehicleType,
        estimatedFare: newFare,
      ));
    }
  }

  Future<void> _onRequestBookRide(
    RequestBookRideEvent event,
    Emitter<BookingState> emit,
  ) async {
    if (state is! BookingConfigured) return;

    final config = state as BookingConfigured;
    final pendingRide = Ride(
      id: 'vybe_ride_${_uuid.v4().substring(0, 8)}',
      pickup: config.pickup,
      destination: config.destination,
      vehicleType: config.selectedVehicle,
      fare: config.estimatedFare,
      distanceKm: config.distanceKm,
      createdAt: DateTime.now(),
      status: RideStatus.searching,
    );

    emit(SearchingDriverState(
      pendingRide: pendingRide,
      statusText: 'Connecting to nearby ${config.selectedVehicle.name} captains...',
    ));

    _searchTimer?.cancel();
    // Simulate searching animation (3.5 seconds)
    _searchTimer = Timer(const Duration(milliseconds: 3500), () async {
      try {
        final driver = await _findDriverUseCase(pendingRide);
        final assignedRide = pendingRide.copyWith(
          driver: driver,
          status: RideStatus.driverAssigned,
        );
        add(DriverFoundEvent(driver: driver, ride: assignedRide));
      } catch (e) {
        add(CancelBookingEvent());
      }
    });
  }

  void _onDriverFound(
    DriverFoundEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(DriverMatchedState(
      ride: event.ride,
      driver: event.driver,
    ));
  }

  void _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) {
    _searchTimer?.cancel();
    emit(BookingCancelledState());
  }

  void _onResetBooking(
    ResetBookingEvent event,
    Emitter<BookingState> emit,
  ) {
    _searchTimer?.cancel();
    emit(BookingInitial());
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}
