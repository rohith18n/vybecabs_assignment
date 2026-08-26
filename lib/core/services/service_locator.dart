import 'package:get_it/get_it.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/local_dummy_datasource.dart';
import '../../data/datasources/ride_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/ride_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/ride_repository.dart';
import '../../domain/usecases/auth/auth_state_stream_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
import '../../domain/usecases/ride/find_driver_usecase.dart';
import '../../domain/usecases/ride/get_dummy_locations_usecase.dart';
import '../../domain/usecases/ride/get_ride_history_usecase.dart';
import '../../domain/usecases/ride/get_routes_usecase.dart';
import '../../domain/usecases/ride/get_vehicle_types_usecase.dart';
import '../../domain/usecases/ride/save_completed_ride_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/auth/auth_form_cubit.dart';
import '../../presentation/blocs/booking/booking_bloc.dart';
import '../../presentation/blocs/history/history_bloc.dart';
import '../../presentation/blocs/location/location_bloc.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import '../../presentation/blocs/tracking/tracking_bloc.dart';
import 'location_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Services
  sl.registerLazySingleton<LocationService>(() => LocationService());

  // DataSources
  sl.registerLazySingleton<IAuthRemoteDataSource>(() => FirebaseAuthRemoteDataSource());
  sl.registerLazySingleton<LocalDummyDataSource>(() => LocalDummyDataSource());
  sl.registerLazySingleton<IRideLocalDataSource>(() => RideLocalDataSource());

  // Repositories
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<IAuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<IRideRepository>(
    () => RideRepositoryImpl(localDataSource: sl<IRideLocalDataSource>()),
  );

  // UseCases - Auth
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl<IAuthRepository>()));
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl<IAuthRepository>()));
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl<IAuthRepository>()));
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<IAuthRepository>()),
  );
  sl.registerLazySingleton<AuthStateStreamUseCase>(
    () => AuthStateStreamUseCase(sl<IAuthRepository>()),
  );

  // UseCases - Ride
  sl.registerLazySingleton<GetDummyLocationsUseCase>(
    () => GetDummyLocationsUseCase(sl<IRideRepository>()),
  );
  sl.registerLazySingleton<GetVehicleTypesUseCase>(
    () => GetVehicleTypesUseCase(sl<IRideRepository>()),
  );
  sl.registerLazySingleton<FindDriverUseCase>(
    () => FindDriverUseCase(sl<IRideRepository>()),
  );
  sl.registerLazySingleton<GetPickupRouteUseCase>(
    () => GetPickupRouteUseCase(sl<IRideRepository>()),
  );
  sl.registerLazySingleton<GetTripRouteUseCase>(
    () => GetTripRouteUseCase(sl<IRideRepository>()),
  );
  sl.registerLazySingleton<GetRideHistoryUseCase>(
    () => GetRideHistoryUseCase(sl<IRideRepository>()),
  );
  sl.registerLazySingleton<SaveCompletedRideUseCase>(
    () => SaveCompletedRideUseCase(sl<IRideRepository>()),
  );

  // BLoCs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signInUseCase: sl<SignInUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      authStateStreamUseCase: sl<AuthStateStreamUseCase>(),
      authRepository: sl<IAuthRepository>(),
    ),
  );

  sl.registerFactory<AuthFormCubit>(() => AuthFormCubit());

  sl.registerFactory<LocationBloc>(
    () => LocationBloc(
      locationService: sl<LocationService>(),
      getDummyLocationsUseCase: sl<GetDummyLocationsUseCase>(),
    ),
  );

  sl.registerFactory<BookingBloc>(
    () => BookingBloc(
      getVehicleTypesUseCase: sl<GetVehicleTypesUseCase>(),
      findDriverUseCase: sl<FindDriverUseCase>(),
    ),
  );

  sl.registerFactory<TrackingBloc>(
    () => TrackingBloc(
      getPickupRouteUseCase: sl<GetPickupRouteUseCase>(),
      getTripRouteUseCase: sl<GetTripRouteUseCase>(),
      saveCompletedRideUseCase: sl<SaveCompletedRideUseCase>(),
    ),
  );

  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  sl.registerFactory<HistoryBloc>(
    () => HistoryBloc(
      getRideHistoryUseCase: sl<GetRideHistoryUseCase>(),
    ),
  );
}
