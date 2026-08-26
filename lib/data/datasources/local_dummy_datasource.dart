import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/utils/path_generator.dart';
import '../models/driver_model.dart';
import '../models/location_model.dart';
import '../models/ride_model.dart';
import '../models/vehicle_type_model.dart';
import 'dummy_seed_history.dart';

class LocalDummyDataSource {
  // Hardcoded Hotspots / Locations
  static const List<LocationModel> dummyLocations = [
    LocationModel(
      id: 'loc_1',
      title: 'Indiranagar 100ft Road',
      subtitle: 'Near Toit Pub & Metro Station, Indiranagar',
      latitude: 12.9784,
      longitude: 77.6408,
      category: 'Popular',
    ),
    LocationModel(
      id: 'loc_2',
      title: 'Koramangala 5th Block',
      subtitle: 'Koramangala Club Road, 80ft Road Junction',
      latitude: 12.9352,
      longitude: 77.6245,
      category: 'Popular',
    ),
    LocationModel(
      id: 'loc_3',
      title: 'Kempegowda International Airport (BLR)',
      subtitle: 'Terminal 1 & 2 Arrivals / Departures, Devanahalli',
      latitude: 13.1986,
      longitude: 77.7066,
      category: 'Airport',
    ),
    LocationModel(
      id: 'loc_4',
      title: 'Manyata Embassy Business Park',
      subtitle: 'Outer Ring Road, Nagawara, Hebbal',
      latitude: 13.0485,
      longitude: 77.6200,
      category: 'Tech Park',
    ),
    LocationModel(
      id: 'loc_5',
      title: 'UB City Luxury Collection',
      subtitle: '24 Vittal Mallya Road, Ashok Nagar',
      latitude: 12.9716,
      longitude: 77.5958,
      category: 'Mall',
    ),
    LocationModel(
      id: 'loc_6',
      title: 'Majestic Central Railway Station',
      subtitle: 'Kempegowda Bus Station & KSR Bengaluru',
      latitude: 12.9774,
      longitude: 77.5729,
      category: 'Station',
    ),
  ];

  // Vehicle Types
  static const List<VehicleTypeModel> dummyVehicles = [
    VehicleTypeModel(
      id: 'vybe_go',
      name: 'Vybe Go',
      description: 'Affordable, compact hatchbacks for quick city rides',
      baseFare: 45.0,
      ratePerKm: 14.0,
      etaMinutes: 3,
      capacity: 4,
      iconName: 'hatchback',
    ),
    VehicleTypeModel(
      id: 'vybe_ev',
      name: 'Vybe EV Prime',
      description: 'Zero emission electric sedans with silent cabin vibes',
      baseFare: 75.0,
      ratePerKm: 19.0,
      etaMinutes: 2,
      capacity: 4,
      iconName: 'ev',
    ),
    VehicleTypeModel(
      id: 'vybe_prime',
      name: 'Vybe Sedan',
      description: 'Comfortable executive sedans with top-rated captains',
      baseFare: 65.0,
      ratePerKm: 17.0,
      etaMinutes: 4,
      capacity: 4,
      iconName: 'sedan',
    ),
    VehicleTypeModel(
      id: 'vybe_xl',
      name: 'Vybe XL (6-Seater)',
      description: 'Spacious SUVs for group travel and airport luggage',
      baseFare: 110.0,
      ratePerKm: 25.0,
      etaMinutes: 5,
      capacity: 6,
      iconName: 'suv',
    ),
  ];

  // Dummy Drivers
  static const List<DriverModel> dummyDrivers = [
    DriverModel(
      id: 'drv_01',
      name: 'Rajesh Verma',
      photoUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=80',
      carModel: 'Tata Nexon EV • White',
      carNumber: 'KA 01 MJ 4829',
      rating: 4.94,
      totalTrips: 3420,
      phone: '+91 98450 12345',
      latitude: 12.9730,
      longitude: 77.5990,
    ),
    DriverModel(
      id: 'drv_02',
      name: 'Vikramaditya Rao',
      photoUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
      carModel: 'Hyundai Ioniq 5 • Gold',
      carNumber: 'KA 05 AA 7711',
      rating: 4.91,
      totalTrips: 2890,
      phone: '+91 99801 88220',
      latitude: 12.9690,
      longitude: 77.5910,
    ),
    DriverModel(
      id: 'drv_03',
      name: 'Anita Sharma',
      photoUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
      carModel: 'Skoda Slavia • Grey',
      carNumber: 'KA 03 EX 9920',
      rating: 4.97,
      totalTrips: 4150,
      phone: '+91 97412 33490',
      latitude: 12.9750,
      longitude: 77.5920,
    ),
  ];

  // Dummy Past Ride History (5-6 rides)
  static List<RideModel> getInitialRideHistory() => getInitialRideHistorySeed();

  // Route Polyline Generator (Simulation for smooth animation)
  static List<LatLng> generateSimulatedPath(
    LatLng start,
    LatLng end, {
    int waypointCount = 18,
  }) {
    return PathGenerator.generateSimulatedPath(
      start,
      end,
      waypointCount: waypointCount,
    );
  }
}
