import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_paths.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/booking/booking_event.dart';
import '../../blocs/booking/booking_state.dart';
import '../../blocs/tracking/tracking_bloc.dart';
import '../../blocs/tracking/tracking_event.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/pulse_radar.dart';
import '../../widgets/common/theme_toggle_button.dart';

class FindingDriverScreen extends StatelessWidget {
  const FindingDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is DriverMatchedState) {
          // Initialize live tracking bloc with the assigned ride
          context.read<TrackingBloc>().add(StartLiveTrackingEvent(state.ride));

          UiHelpers.showSnackBar(
            context,
            message: 'Matched with ${state.driver.name} (${state.driver.carModel})!',
          );

          // Route to Live Tracking Screen
          context.go(RoutePaths.liveTracking);
        } else if (state is BookingCancelledState) {
          context.pop();
        }
      },
      builder: (context, state) {
        String pickupTitle = 'Pickup Location';
        String destTitle = 'Destination';
        String vehicleName = 'Vybe Cab';
        double fare = 150.0;

        if (state is SearchingDriverState) {
          pickupTitle = state.pendingRide.pickup.title;
          destTitle = state.pendingRide.destination.title;
          vehicleName = state.pendingRide.vehicleType.name;
          fare = state.pendingRide.fare;
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              context.read<BookingBloc>().add(CancelBookingEvent());
            }
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Top Bar with Theme Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vybe Dispatcher',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'MATCHING',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const ThemeToggleButton(isCompact: true),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Pulse Radar Animation
                    const PulseRadar(size: 260, color: AppColors.primary),
                    const SizedBox(height: 32),

                    // Status Titles
                    Text(
                      AppStrings.findingDriver,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      AppStrings.contactingNearby,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Ride Summary Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vehicleName,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                UiHelpers.formatCurrency(fare),
                                style: AppTextStyles.priceMedium.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.circle, color: AppColors.success, size: 8),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pickupTitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.error, size: 10),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  destTitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Cancel Booking Button
                    CustomButton(
                      text: AppStrings.cancelSearch,
                      type: ButtonType.danger,
                      onPressed: () {
                        context.read<BookingBloc>().add(CancelBookingEvent());
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
