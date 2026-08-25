import '../../entities/ride.dart';
import '../../repositories/ride_repository.dart';

class GetRideHistoryUseCase {
  final IRideRepository repository;

  GetRideHistoryUseCase(this.repository);

  Future<List<Ride>> call() {
    return repository.getRideHistory();
  }
}
