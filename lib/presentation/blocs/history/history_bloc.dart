import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/ride/get_ride_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetRideHistoryUseCase _getRideHistoryUseCase;

  HistoryBloc({
    required GetRideHistoryUseCase getRideHistoryUseCase,
  })  : _getRideHistoryUseCase = getRideHistoryUseCase,
        super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<AddCompletedRideEvent>(_onAddCompletedRide);
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final rides = await _getRideHistoryUseCase();
      emit(HistoryLoaded(rides));
    } catch (e) {
      emit(HistoryError('Failed to load ride history: ${e.toString()}'));
    }
  }

  void _onAddCompletedRide(
    AddCompletedRideEvent event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final current = state as HistoryLoaded;
      final updated = [event.ride, ...current.rides];
      emit(HistoryLoaded(updated));
    }
  }
}
