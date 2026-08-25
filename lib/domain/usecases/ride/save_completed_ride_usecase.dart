import '../../entities/ride.dart';
import '../../repositories/ride_repository.dart';

class SaveCompletedRideUseCase {
  final IRideRepository repository;

  SaveCompletedRideUseCase(this.repository);

  Future<void> call(Ride ride) {
    return repository.saveCompletedRide(ride);
  }
}
