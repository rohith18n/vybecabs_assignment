import '../../entities/location_entity.dart';
import '../../repositories/ride_repository.dart';

class GetDummyLocationsUseCase {
  final IRideRepository repository;

  GetDummyLocationsUseCase(this.repository);

  Future<List<LocationEntity>> call() {
    return repository.getDummyLocations();
  }
}
