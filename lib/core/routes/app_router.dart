import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/auth_screen.dart';
import '../../presentation/screens/booking/finding_driver_screen.dart';
import '../../presentation/screens/history/ride_history_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/tracking/live_tracking_screen.dart';
import '../../presentation/screens/tracking/trip_completed_screen.dart';
import 'route_paths.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.findingDriver,
        name: 'findingDriver',
        builder: (context, state) => const FindingDriverScreen(),
      ),
      GoRoute(
        path: RoutePaths.liveTracking,
        name: 'liveTracking',
        builder: (context, state) => const LiveTrackingScreen(),
      ),
      GoRoute(
        path: RoutePaths.tripCompleted,
        name: 'tripCompleted',
        builder: (context, state) => const TripCompletedScreen(),
      ),
      GoRoute(
        path: RoutePaths.history,
        name: 'history',
        builder: (context, state) => const RideHistoryScreen(),
      ),
    ],
  );
}
