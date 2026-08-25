import '../../entities/vehicle_type.dart';
import '../../repositories/ride_repository.dart';

class GetVehicleTypesUseCase {
  final IRideRepository repository;

  GetVehicleTypesUseCase(this.repository);

  Future<List<VehicleType>> call() {
    return repository.getVehicleTypes();
  }
}
