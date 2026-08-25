import 'package:equatable/equatable.dart';
import '../../../domain/entities/ride.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class AddCompletedRideEvent extends HistoryEvent {
  final Ride ride;
  const AddCompletedRideEvent(this.ride);

  @override
  List<Object?> get props => [ride];
}
