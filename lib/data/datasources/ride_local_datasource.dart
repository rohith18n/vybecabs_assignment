import '../models/ride_model.dart';
import 'local_dummy_datasource.dart';

abstract class IRideLocalDataSource {
  Future<List<RideModel>> getRideHistory();
  Future<void> saveCompletedRide(RideModel ride);
}

class RideLocalDataSource implements IRideLocalDataSource {
  final List<RideModel> _rides = [];

  RideLocalDataSource() {
    _rides.addAll(LocalDummyDataSource.getInitialRideHistory());
  }

  @override
  Future<List<RideModel>> getRideHistory() async {
    // Return a copy sorted by most recent first
    final sorted = List<RideModel>.from(_rides)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> saveCompletedRide(RideModel ride) async {
    _rides.insert(0, ride);
  }
}
