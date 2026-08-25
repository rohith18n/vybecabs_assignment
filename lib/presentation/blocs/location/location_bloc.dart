import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/location_service.dart';
import '../../../domain/entities/location_entity.dart';
import '../../../domain/usecases/ride/get_dummy_locations_usecase.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService;
  final GetDummyLocationsUseCase _getDummyLocationsUseCase;

  LocationBloc({
    required LocationService locationService,
    required GetDummyLocationsUseCase getDummyLocationsUseCase,
  })  : _locationService = locationService,
        _getDummyLocationsUseCase = getDummyLocationsUseCase,
        super(LocationInitial()) {
    on<LoadLocationAndHotspots>(_onLoadLocationAndHotspots);
    on<SelectDestinationEvent>(_onSelectDestination);
    on<SelectPickupEvent>(_onSelectPickup);
    on<ClearDestinationEvent>(_onClearDestination);
  }

  Future<void> _onLoadLocationAndHotspots(
    LoadLocationAndHotspots event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final latLng = await _locationService.getCurrentPosition();
      final hotspots = await _getDummyLocationsUseCase();

      final currentPickup = LocationEntity(
        id: 'current_pickup_loc',
        title: 'Current Location',
        subtitle: 'Church St, Bangalore Central',
        latitude: latLng.latitude,
        longitude: latLng.longitude,
        category: 'Current',
      );

      emit(LocationLoaded(
        currentPickup: currentPickup,
        hotspots: hotspots,
      ));
    } catch (e) {
      emit(LocationError('Failed to retrieve location: ${e.toString()}'));
    }
  }

  void _onSelectDestination(
    SelectDestinationEvent event,
    Emitter<LocationState> emit,
  ) {
    if (state is LocationLoaded) {
      final current = state as LocationLoaded;
      emit(current.copyWith(selectedDestination: event.destination));
    }
  }

  void _onSelectPickup(
    SelectPickupEvent event,
    Emitter<LocationState> emit,
  ) {
    if (state is LocationLoaded) {
      final current = state as LocationLoaded;
      emit(current.copyWith(currentPickup: event.pickup));
    }
  }

  void _onClearDestination(
    ClearDestinationEvent event,
    Emitter<LocationState> emit,
  ) {
    if (state is LocationLoaded) {
      final current = state as LocationLoaded;
      emit(current.copyWith(clearDestination: true));
    }
  }
}
