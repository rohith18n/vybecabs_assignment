import '../../entities/driver.dart';
import '../../entities/ride.dart';
import '../../repositories/ride_repository.dart';

class FindDriverUseCase {
  final IRideRepository repository;

  FindDriverUseCase(this.repository);

  Future<Driver> call(Ride ride) {
    return repository.findDriverForRide(ride);
  }
}
