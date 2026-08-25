import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_paths.dart';
import '../../blocs/tracking/tracking_bloc.dart';
import '../../blocs/tracking/tracking_event.dart';
import '../../blocs/tracking/tracking_state.dart';
import '../../widgets/cards/driver_info_card.dart';
import '../../widgets/common/theme_toggle_button.dart';
import '../../widgets/map/custom_map_view.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<TrackingBloc, TrackingState>(
      listener: (context, state) {
        if (state is TripCompletedState) {
          context.go(RoutePaths.tripCompleted);
        }
      },
      builder: (context, state) {
        if (state is TrackingInitial || state is TrackingLoading) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        LatLng initialPos = const LatLng(12.9716, 77.5946);
        LatLng? pickup;
        LatLng? drop;
        LatLng? carPos;
        double bearing = 0.0;
        List<LatLng>? polyline;
        Color polylineColor = AppColors.primary;

        Widget bottomCard = const SizedBox.shrink();

        if (state is DriverApproachingState) {
          pickup = state.ride.pickup.latLng;
          carPos = state.driverLocation;
          bearing = state.bearing;
          polyline = state.remainingPolyline;
          polylineColor = AppColors.primary;

          bottomCard = DriverInfoCard(
            driver: state.driver,
            ride: state.ride,
            statusTitle: AppStrings.driverOnTheWay,
            statusSubtitle: 'Driver is reaching your pickup location',
            etaMinutes: state.etaMinutes,
            etaSeconds: state.etaSeconds,
          );
        } else if (state is DriverArrivedState) {
          pickup = state.pickupLocation;
          carPos = state.pickupLocation;
          polylineColor = AppColors.success;

          bottomCard = DriverInfoCard(
            driver: state.driver,
            ride: state.ride,
            statusTitle: AppStrings.driverArrived,
            statusSubtitle: 'Captain has arrived • Share PIN with Captain',
            etaMinutes: 0,
            isArrived: true,
            onStartTrip: () {
              context.read<TrackingBloc>().add(StartTripEvent());
            },
          );
        } else if (state is TripInProgressState) {
          pickup = state.ride.pickup.latLng;
          drop = state.ride.destination.latLng;
          carPos = state.carLocation;
          bearing = state.bearing;
          polyline = state.remainingPolyline;
          polylineColor = AppColors.primary;

          final isNearDrop = state.progressPercent >= 0.96;

          bottomCard = DriverInfoCard(
            driver: state.driver,
            ride: state.ride,
            statusTitle: isNearDrop ? 'Arriving at Destination' : AppStrings.tripInProgress,
            statusSubtitle: isNearDrop
                ? 'Preparing dropoff & receipt'
                : '${(state.progressPercent * 100).toInt()}% of route covered',
            etaMinutes: state.etaMinutes,
            etaSeconds: state.etaSeconds,
            isEnRoute: true,
            isTripFinished: isNearDrop,
          );
        }

        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Stack(
              children: [
                // Google Map with moving car marker & route polyline
                CustomMapView(
                  initialPosition: carPos ?? initialPos,
                  pickupLocation: pickup,
                  dropLocation: drop,
                  carLocation: carPos,
                  carBearing: bearing,
                  polylineCoordinates: polyline,
                  polylineColor: polylineColor,
                  padding: const EdgeInsets.only(top: 90, bottom: 280),
                ),

                // Top Floating Status Banner & Theme Switcher
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Status Card
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface.withValues(alpha: 0.94)
                                  : AppColors.lightSurface.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state is DriverArrivedState
                                        ? AppColors.success
                                        : (state is TripInProgressState
                                            ? AppColors.primary
                                            : AppColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state is DriverArrivedState
                                        ? 'Captain Arrived at Pickup'
                                        : (state is TripInProgressState
                                            ? 'En Route to Destination'
                                            : 'Captain Approaching'),
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCard : AppColors.lightChip,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.flash_on_rounded,
                                          size: 13, color: AppColors.primary),
                                      const SizedBox(width: 2),
                                      Text(
                                        'LIVE',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Theme Switcher Button
                        const ThemeToggleButton(isCompact: true),
                      ],
                    ),
                  ),
                ),

                // Driver & Ride Info Bottom Sheet
                Align(
                  alignment: Alignment.bottomCenter,
                  child: bottomCard,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
