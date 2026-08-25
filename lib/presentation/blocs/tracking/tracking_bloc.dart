import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/utils/geo_utils.dart';
import '../../../domain/entities/driver.dart';
import '../../../domain/entities/ride.dart';
import '../../../domain/usecases/ride/get_routes_usecase.dart';
import '../../../domain/usecases/ride/save_completed_ride_usecase.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetPickupRouteUseCase _getPickupRouteUseCase;
  final GetTripRouteUseCase _getTripRouteUseCase;
  final SaveCompletedRideUseCase _saveCompletedRideUseCase;

  Timer? _movementTimer;
  List<LatLng> _currentPath = [];
  int _currentIndex = 0;
  Ride? _activeRide;
  Driver? _activeDriver;

  TrackingBloc({
    required GetPickupRouteUseCase getPickupRouteUseCase,
    required GetTripRouteUseCase getTripRouteUseCase,
    required SaveCompletedRideUseCase saveCompletedRideUseCase,
  })  : _getPickupRouteUseCase = getPickupRouteUseCase,
        _getTripRouteUseCase = getTripRouteUseCase,
        _saveCompletedRideUseCase = saveCompletedRideUseCase,
        super(TrackingInitial()) {
    on<StartLiveTrackingEvent>(_onStartLiveTracking);
    on<DriverApproachTickEvent>(_onDriverApproachTick);
    on<DriverArrivedEvent>(_onDriverArrived);
    on<StartTripEvent>(_onStartTrip);
    on<TripProgressTickEvent>(_onTripProgressTick);
    on<CompleteTripEvent>(_onCompleteTrip);
    on<ResetTrackingEvent>(_onResetTracking);
  }

  Future<void> _onStartLiveTracking(
    StartLiveTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    _movementTimer?.cancel();
    emit(TrackingLoading());

    _activeRide = event.ride;
    _activeDriver = event.ride.driver!;

    final driverStart = LatLng(_activeDriver!.latitude, _activeDriver!.longitude);
    final pickupPoint = event.ride.pickup.latLng;

    // Fetch pickup route
    _currentPath = await _getPickupRouteUseCase(driverStart, pickupPoint);
    _currentIndex = 0;

    final initialLocation = _currentPath.first;
    final initialBearing = _currentPath.length > 1
        ? GeoUtils.calculateBearing(_currentPath[0], _currentPath[1])
        : 0.0;

    emit(DriverApproachingState(
      ride: _activeRide!,
      driver: _activeDriver!,
      driverLocation: initialLocation,
      bearing: initialBearing,
      fullPolyline: _currentPath,
      remainingPolyline: _currentPath,
      etaMinutes: 3,
    ));

    // Start animated waypoint ticks every 1.4s
    _startApproachMovement();
  }

  void _startApproachMovement() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (_currentIndex < _currentPath.length - 1) {
        _currentIndex++;
        final currentPoint = _currentPath[_currentIndex];
        final nextPoint = _currentIndex + 1 < _currentPath.length
            ? _currentPath[_currentIndex + 1]
            : _currentPath[_currentIndex];
        final bearing = GeoUtils.calculateBearing(currentPoint, nextPoint);

        add(DriverApproachTickEvent(
          newLocation: currentPoint,
          bearing: bearing,
          remainingWaypointIndex: _currentIndex,
        ));
      } else {
        timer.cancel();
        add(DriverArrivedEvent());
      }
    });
  }

  void _onDriverApproachTick(
    DriverApproachTickEvent event,
    Emitter<TrackingState> emit,
  ) {
    if (state is DriverApproachingState) {
      final current = state as DriverApproachingState;
      final remaining = _currentPath.sublist(event.remainingWaypointIndex);
      final int totalPoints = _currentPath.length;
      final double fractionRemaining =
          (totalPoints - event.remainingWaypointIndex) / totalPoints;
      final int remainingEta = (fractionRemaining * 3).ceil().clamp(1, 3);

      emit(DriverApproachingState(
        ride: current.ride,
        driver: current.driver,
        driverLocation: event.newLocation,
        bearing: event.bearing,
        fullPolyline: current.fullPolyline,
        remainingPolyline: remaining,
        etaMinutes: remainingEta,
      ));
    }
  }

  void _onDriverArrived(
    DriverArrivedEvent event,
    Emitter<TrackingState> emit,
  ) {
    if (_activeRide == null || _activeDriver == null) return;
    _movementTimer?.cancel();

    final arrivedRide = _activeRide!.copyWith(status: RideStatus.driverArrived);
    _activeRide = arrivedRide;

    emit(DriverArrivedState(
      ride: arrivedRide,
      driver: _activeDriver!,
      pickupLocation: arrivedRide.pickup.latLng,
    ));

    // Auto-advance to Trip Start after 4 seconds if user doesn't press "Start Ride" manually
    Timer(const Duration(seconds: 4), () {
      if (state is DriverArrivedState) {
        add(StartTripEvent());
      }
    });
  }

  Future<void> _onStartTrip(
    StartTripEvent event,
    Emitter<TrackingState> emit,
  ) async {
    if (_activeRide == null || _activeDriver == null) return;
    _movementTimer?.cancel();

    final inProgressRide = _activeRide!.copyWith(status: RideStatus.inProgress);
    _activeRide = inProgressRide;

    final pickupPoint = inProgressRide.pickup.latLng;
    final destinationPoint = inProgressRide.destination.latLng;

    // Fetch trip route to destination
    _currentPath = await _getTripRouteUseCase(pickupPoint, destinationPoint);
    _currentIndex = 0;

    final initialLocation = _currentPath.first;
    final initialBearing = _currentPath.length > 1
        ? GeoUtils.calculateBearing(_currentPath[0], _currentPath[1])
        : 0.0;

    emit(TripInProgressState(
      ride: inProgressRide,
      driver: _activeDriver!,
      carLocation: initialLocation,
      bearing: initialBearing,
      fullPolyline: _currentPath,
      remainingPolyline: _currentPath,
      etaMinutes: 8,
      progressPercent: 0.0,
    ));

    // Start animated waypoint ticks every 1.4s towards dropoff
    _startTripMovement();
  }

  void _startTripMovement() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (_currentIndex < _currentPath.length - 1) {
        _currentIndex++;
        final currentPoint = _currentPath[_currentIndex];
        final nextPoint = _currentIndex + 1 < _currentPath.length
            ? _currentPath[_currentIndex + 1]
            : _currentPath[_currentIndex];
        final bearing = GeoUtils.calculateBearing(currentPoint, nextPoint);

        add(TripProgressTickEvent(
          newLocation: currentPoint,
          bearing: bearing,
          remainingWaypointIndex: _currentIndex,
        ));
      } else {
        timer.cancel();
        add(const CompleteTripEvent());
      }
    });
  }

  void _onTripProgressTick(
    TripProgressTickEvent event,
    Emitter<TrackingState> emit,
  ) {
    if (state is TripInProgressState) {
      final current = state as TripInProgressState;
      final remaining = _currentPath.sublist(event.remainingWaypointIndex);
      final double progress = event.remainingWaypointIndex / (_currentPath.length - 1);
      final int totalEtaMinutes = 8;
      final int remainingEta = ((1.0 - progress) * totalEtaMinutes).ceil().clamp(1, 8);

      emit(TripInProgressState(
        ride: current.ride,
        driver: current.driver,
        carLocation: event.newLocation,
        bearing: event.bearing,
        fullPolyline: current.fullPolyline,
        remainingPolyline: remaining,
        etaMinutes: remainingEta,
        progressPercent: progress,
      ));
    }
  }

  Future<void> _onCompleteTrip(
    CompleteTripEvent event,
    Emitter<TrackingState> emit,
  ) async {
    _movementTimer?.cancel();
    if (_activeRide == null) return;

    final completedRide = _activeRide!.copyWith(
      status: RideStatus.completed,
      userRating: event.rating ?? 5.0,
    );

    // Save completed ride to history
    await _saveCompletedRideUseCase(completedRide);

    emit(TripCompletedState(completedRide));
  }

  void _onResetTracking(
    ResetTrackingEvent event,
    Emitter<TrackingState> emit,
  ) {
    _movementTimer?.cancel();
    _activeRide = null;
    _activeDriver = null;
    _currentPath = [];
    _currentIndex = 0;
    emit(TrackingInitial());
  }

  @override
  Future<void> close() {
    _movementTimer?.cancel();
    return super.close();
  }
}
