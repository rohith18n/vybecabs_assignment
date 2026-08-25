import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/utils/geo_utils.dart';
import '../models/driver_model.dart';
import '../models/location_model.dart';
import '../models/ride_model.dart';
import '../models/vehicle_type_model.dart';
import '../../domain/entities/ride.dart';

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
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      carModel: 'Tata Nexon EV Max • Cyber White',
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
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      carModel: 'Hyundai Ioniq 5 • Gravity Gold',
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
      photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      carModel: 'Skoda Slavia 1.5 • Carbon Steel',
      carNumber: 'KA 03 EX 9920',
      rating: 4.97,
      totalTrips: 4150,
      phone: '+91 97412 33490',
      latitude: 12.9750,
      longitude: 77.5920,
    ),
  ];

  // Dummy Past Ride History (5-6 rides)
  static List<RideModel> getInitialRideHistory() {
    return [
      RideModel(
        id: 'vybe_hist_01',
        pickup: const LocationModel(
          id: 'hloc_1',
          title: 'Indiranagar Metro Station',
          subtitle: 'CMH Road, Indiranagar',
          latitude: 12.9784,
          longitude: 77.6408,
          category: 'Station',
        ),
        destination: const LocationModel(
          id: 'hloc_2',
          title: 'Manyata Embassy Business Park',
          subtitle: 'Outer Ring Road, Hebbal',
          latitude: 13.0485,
          longitude: 77.6200,
          category: 'Tech Park',
        ),
        vehicleType: dummyVehicles[1], // Vybe EV Prime
        driver: dummyDrivers[0],
        fare: 345.0,
        distanceKm: 12.8,
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        status: RideStatus.completed,
        userRating: 5.0,
      ),
      RideModel(
        id: 'vybe_hist_02',
        pickup: const LocationModel(
          id: 'hloc_3',
          title: 'Koramangala Forum Mall',
          subtitle: 'Hosur Road, Koramangala',
          latitude: 12.9352,
          longitude: 77.6145,
          category: 'Mall',
        ),
        destination: const LocationModel(
          id: 'hloc_4',
          title: 'Kempegowda Intl Airport BLR',
          subtitle: 'Terminal 1 Departures',
          latitude: 13.1986,
          longitude: 77.7066,
          category: 'Airport',
        ),
        vehicleType: dummyVehicles[3], // Vybe XL
        driver: dummyDrivers[1],
        fare: 1180.0,
        distanceKm: 41.2,
        createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
        status: RideStatus.completed,
        userRating: 5.0,
      ),
      RideModel(
        id: 'vybe_hist_03',
        pickup: const LocationModel(
          id: 'hloc_5',
          title: 'UB City Mall',
          subtitle: 'Vittal Mallya Road',
          latitude: 12.9716,
          longitude: 77.5958,
          category: 'Mall',
        ),
        destination: const LocationModel(
          id: 'hloc_6',
          title: 'Indiranagar 100ft Road',
          subtitle: '12th Main Junction',
          latitude: 12.9784,
          longitude: 77.6408,
          category: 'Popular',
        ),
        vehicleType: dummyVehicles[0], // Vybe Go
        driver: dummyDrivers[2],
        fare: 165.0,
        distanceKm: 5.4,
        createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 1)),
        status: RideStatus.completed,
        userRating: 4.8,
      ),
      RideModel(
        id: 'vybe_hist_04',
        pickup: const LocationModel(
          id: 'hloc_7',
          title: 'MG Road Metro Station',
          subtitle: 'MG Road, Shivajinagar',
          latitude: 12.9756,
          longitude: 77.6066,
          category: 'Station',
        ),
        destination: const LocationModel(
          id: 'hloc_8',
          title: 'Koramangala 5th Block',
          subtitle: '80ft Road, Koramangala',
          latitude: 12.9352,
          longitude: 77.6245,
          category: 'Popular',
        ),
        vehicleType: dummyVehicles[2], // Vybe Sedan
        driver: dummyDrivers[0],
        fare: 210.0,
        distanceKm: 6.8,
        createdAt: DateTime.now().subtract(const Duration(days: 6, hours: 7)),
        status: RideStatus.completed,
        userRating: 5.0,
      ),
      RideModel(
        id: 'vybe_hist_05',
        pickup: const LocationModel(
          id: 'hloc_9',
          title: 'Church Street',
          subtitle: 'Brigade Road Junction',
          latitude: 12.9744,
          longitude: 77.6030,
          category: 'Popular',
        ),
        destination: const LocationModel(
          id: 'hloc_10',
          title: 'Majestic City Railway Station',
          subtitle: 'Platform 1 Entrance',
          latitude: 12.9774,
          longitude: 77.5729,
          category: 'Station',
        ),
        vehicleType: dummyVehicles[0], // Vybe Go
        driver: dummyDrivers[1],
        fare: 140.0,
        distanceKm: 4.2,
        createdAt: DateTime.now().subtract(const Duration(days: 8, hours: 3)),
        status: RideStatus.completed,
        userRating: 4.7,
      ),
      RideModel(
        id: 'vybe_hist_06',
        pickup: const LocationModel(
          id: 'hloc_11',
          title: 'Whitefield ITPL Main Gate',
          subtitle: 'Pattandur Agrahara',
          latitude: 12.9866,
          longitude: 77.7289,
          category: 'Tech Park',
        ),
        destination: const LocationModel(
          id: 'hloc_12',
          title: 'Indiranagar 100ft Road',
          subtitle: 'Near Metro Station',
          latitude: 12.9784,
          longitude: 77.6408,
          category: 'Popular',
        ),
        vehicleType: dummyVehicles[1], // Vybe EV Prime
        driver: dummyDrivers[2],
        fare: 395.0,
        distanceKm: 14.5,
        createdAt: DateTime.now().subtract(const Duration(days: 11, hours: 10)),
        status: RideStatus.completed,
        userRating: 5.0,
      ),
    ];
  }

  /// Generates a realistic curved / Manhattan-like waypoint path between start and end coordinates
  static List<LatLng> generateSimulatedPath(LatLng start, LatLng end, {int waypointCount = 12}) {
    final List<LatLng> path = [];
    path.add(start);

    // Create realistic road zigzag waypoints
    final double latDiff = end.latitude - start.latitude;
    final double lngDiff = end.longitude - start.longitude;

    for (int i = 1; i <= waypointCount; i++) {
      final double progress = i / (waypointCount + 1);

      // Add gentle sine curve offset to simulate city road turns
      final double curveOffset = math.sin(progress * math.pi) * 0.0025;
      final double jitter = math.sin(progress * math.pi * 3) * 0.0008;

      final double lat = start.latitude + (latDiff * progress) + curveOffset;
      final double lng = start.longitude + (lngDiff * progress) - (jitter * 0.5);

      path.add(LatLng(lat, lng));
    }

    path.add(end);

    // Subdivide path for ultra-smooth 60fps / step-wise marker animation
    return GeoUtils.subdividePath(path, stepsBetween: 3);
  }
}
