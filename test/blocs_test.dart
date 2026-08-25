import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vybecabs_assignment/core/services/location_service.dart';
import 'package:vybecabs_assignment/data/datasources/local_dummy_datasource.dart';
import 'package:vybecabs_assignment/domain/entities/ride.dart';
import 'package:vybecabs_assignment/domain/entities/user_entity.dart';
import 'package:vybecabs_assignment/domain/repositories/auth_repository.dart';
import 'package:vybecabs_assignment/domain/repositories/ride_repository.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/auth_state_stream_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/sign_in_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/sign_out_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/sign_up_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/ride/find_driver_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/ride/get_dummy_locations_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/ride/get_ride_history_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/ride/get_routes_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/ride/get_vehicle_types_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/ride/save_completed_ride_usecase.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_bloc.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_event.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_state.dart';
import 'package:vybecabs_assignment/presentation/blocs/booking/booking_bloc.dart';
import 'package:vybecabs_assignment/presentation/blocs/booking/booking_event.dart';
import 'package:vybecabs_assignment/presentation/blocs/booking/booking_state.dart';
import 'package:vybecabs_assignment/presentation/blocs/history/history_bloc.dart';
import 'package:vybecabs_assignment/presentation/blocs/history/history_event.dart';
import 'package:vybecabs_assignment/presentation/blocs/history/history_state.dart';
import 'package:vybecabs_assignment/presentation/blocs/location/location_bloc.dart';
import 'package:vybecabs_assignment/presentation/blocs/location/location_event.dart';
import 'package:vybecabs_assignment/presentation/blocs/location/location_state.dart';
import 'package:flutter/material.dart';
import 'package:vybecabs_assignment/presentation/blocs/theme/theme_cubit.dart';
import 'package:vybecabs_assignment/presentation/blocs/tracking/tracking_bloc.dart';
import 'package:vybecabs_assignment/presentation/blocs/tracking/tracking_event.dart';
import 'package:vybecabs_assignment/presentation/blocs/tracking/tracking_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}
class MockRideRepository extends Mock implements IRideRepository {}
class MockLocationService extends Mock implements LocationService {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
    registerFallbackValue(
      Ride(
        id: 'fallback',
        pickup: LocalDummyDataSource.dummyLocations[0],
        destination: LocalDummyDataSource.dummyLocations[1],
        vehicleType: LocalDummyDataSource.dummyVehicles[0],
        fare: 100,
        distanceKm: 5,
        createdAt: DateTime(2026, 1, 1),
      ),
    );
  });

  group('AuthBloc Tests', () {
    late MockAuthRepository mockAuthRepository;
    late StreamController<UserEntity?> authStreamController;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authStreamController = StreamController<UserEntity?>.broadcast();
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => authStreamController.stream);
    });

    tearDown(() {
      authStreamController.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [Authenticated] when AppStarted is dispatched and user exists',
      build: () {
        const user = UserEntity(uid: 'u1', email: 'test@vybe.com');
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => user);

        return AuthBloc(
          signInUseCase: SignInUseCase(mockAuthRepository),
          signUpUseCase: SignUpUseCase(mockAuthRepository),
          signOutUseCase: SignOutUseCase(mockAuthRepository),
          getCurrentUserUseCase: GetCurrentUserUseCase(mockAuthRepository),
          authStateStreamUseCase: AuthStateStreamUseCase(mockAuthRepository),
          authRepository: mockAuthRepository,
        );
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [
        const Authenticated(UserEntity(uid: 'u1', email: 'test@vybe.com')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful SignInRequested',
      build: () {
        const user = UserEntity(uid: 'u1', email: 'test@vybe.com');
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => null);
        when(() => mockAuthRepository.signInWithEmailPassword(
              email: 'test@vybe.com',
              password: 'Password123!',
            )).thenAnswer((_) async => user);

        return AuthBloc(
          signInUseCase: SignInUseCase(mockAuthRepository),
          signUpUseCase: SignUpUseCase(mockAuthRepository),
          signOutUseCase: SignOutUseCase(mockAuthRepository),
          getCurrentUserUseCase: GetCurrentUserUseCase(mockAuthRepository),
          authStateStreamUseCase: AuthStateStreamUseCase(mockAuthRepository),
          authRepository: mockAuthRepository,
        );
      },
      act: (bloc) => bloc.add(const SignInRequested(
        email: 'test@vybe.com',
        password: 'Password123!',
      )),
      expect: () => [
        AuthLoading(),
        const Authenticated(UserEntity(uid: 'u1', email: 'test@vybe.com')),
      ],
    );
  });

  group('LocationBloc Tests', () {
    late MockLocationService mockLocationService;
    late MockRideRepository mockRideRepository;

    setUp(() {
      mockLocationService = MockLocationService();
      mockRideRepository = MockRideRepository();
    });

    blocTest<LocationBloc, LocationState>(
      'emits [LocationLoading, LocationLoaded] on LoadLocationAndHotspots',
      build: () {
        when(() => mockLocationService.getCurrentPosition())
            .thenAnswer((_) async => const LatLng(12.9716, 77.5946));
        when(() => mockRideRepository.getDummyLocations())
            .thenAnswer((_) async => LocalDummyDataSource.dummyLocations);

        return LocationBloc(
          locationService: mockLocationService,
          getDummyLocationsUseCase: GetDummyLocationsUseCase(mockRideRepository),
        );
      },
      act: (bloc) => bloc.add(LoadLocationAndHotspots()),
      expect: () => [
        LocationLoading(),
        isA<LocationLoaded>()
            .having((s) => s.hotspots.length, 'hotspots count', 6)
            .having((s) => s.currentPickup.latitude, 'latitude', 12.9716),
      ],
    );
  });

  group('BookingBloc Tests', () {
    late MockRideRepository mockRideRepository;

    setUp(() {
      mockRideRepository = MockRideRepository();
    });

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingConfigured] on ConfigureBookingEvent',
      build: () {
        when(() => mockRideRepository.getVehicleTypes())
            .thenAnswer((_) async => LocalDummyDataSource.dummyVehicles);

        return BookingBloc(
          getVehicleTypesUseCase: GetVehicleTypesUseCase(mockRideRepository),
          findDriverUseCase: FindDriverUseCase(mockRideRepository),
        );
      },
      act: (bloc) => bloc.add(ConfigureBookingEvent(
        pickup: LocalDummyDataSource.dummyLocations[0],
        destination: LocalDummyDataSource.dummyLocations[1],
      )),
      expect: () => [
        BookingLoading(),
        isA<BookingConfigured>()
            .having((s) => s.availableVehicles.length, 'vehicles count', 4)
            .having((s) => s.estimatedFare, 'estimated fare', greaterThan(0)),
      ],
    );
  });

  group('TrackingBloc Tests', () {
    late MockRideRepository mockRideRepository;

    setUp(() {
      mockRideRepository = MockRideRepository();
    });

    blocTest<TrackingBloc, TrackingState>(
      'emits [TrackingLoading, DriverApproachingState] on StartLiveTrackingEvent',
      build: () {
        when(() => mockRideRepository.getPickupRoutePolyline(any(), any()))
            .thenAnswer((_) async => [
                  const LatLng(12.973, 77.599),
                  const LatLng(12.975, 77.610),
                  const LatLng(12.978, 77.640),
                ]);

        return TrackingBloc(
          getPickupRouteUseCase: GetPickupRouteUseCase(mockRideRepository),
          getTripRouteUseCase: GetTripRouteUseCase(mockRideRepository),
          saveCompletedRideUseCase: SaveCompletedRideUseCase(mockRideRepository),
        );
      },
      act: (bloc) {
        final ride = Ride(
          id: 'test_ride_1',
          pickup: LocalDummyDataSource.dummyLocations[0],
          destination: LocalDummyDataSource.dummyLocations[1],
          vehicleType: LocalDummyDataSource.dummyVehicles[0],
          driver: LocalDummyDataSource.dummyDrivers[0],
          fare: 250.0,
          distanceKm: 6.5,
          createdAt: DateTime(2026, 8, 25, 14, 0),
          status: RideStatus.driverAssigned,
        );
        bloc.add(StartLiveTrackingEvent(ride));
      },
      expect: () => [
        TrackingLoading(),
        isA<DriverApproachingState>()
            .having((s) => s.driver.name, 'driver name', 'Rajesh Verma')
            .having((s) => s.etaMinutes, 'eta', greaterThan(0)),
      ],
    );
  });

  group('HistoryBloc Tests', () {
    late MockRideRepository mockRideRepository;

    setUp(() {
      mockRideRepository = MockRideRepository();
    });

    blocTest<HistoryBloc, HistoryState>(
      'emits [HistoryLoading, HistoryLoaded] on LoadHistoryEvent',
      build: () {
        when(() => mockRideRepository.getRideHistory())
            .thenAnswer((_) async => LocalDummyDataSource.getInitialRideHistory());

        return HistoryBloc(
          getRideHistoryUseCase: GetRideHistoryUseCase(mockRideRepository),
        );
      },
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        HistoryLoading(),
        isA<HistoryLoaded>()
            .having((s) => s.rides.length, 'history count', 6),
      ],
    );
  });

  group('ThemeCubit Tests', () {
    blocTest<ThemeCubit, ThemeMode>(
      'initial state is ThemeMode.dark and toggleTheme switches to ThemeMode.light and back',
      build: () => ThemeCubit(),
      act: (cubit) {
        expect(cubit.state, ThemeMode.dark);
        expect(cubit.isDark, true);
        cubit.toggleTheme();
        expect(cubit.state, ThemeMode.light);
        expect(cubit.isDark, false);
        cubit.toggleTheme();
        expect(cubit.state, ThemeMode.dark);
        expect(cubit.isDark, true);
      },
      expect: () => [
        ThemeMode.light,
        ThemeMode.dark,
      ],
    );
  });
}
