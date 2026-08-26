import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_paths.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/ride.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/booking/booking_event.dart';
import '../../blocs/location/location_bloc.dart';
import '../../blocs/location/location_event.dart';
import '../../blocs/tracking/tracking_bloc.dart';
import '../../blocs/tracking/tracking_event.dart';
import '../../blocs/tracking/tracking_state.dart';
import '../../widgets/cards/trip_completed_fare_card.dart';
import '../../widgets/cards/trip_rating_section.dart';
import '../../widgets/common/custom_button.dart';

class TripCompletedScreen extends StatelessWidget {
  const TripCompletedScreen({super.key});

  void _doneAndGoHome(BuildContext context) {
    context.read<TrackingBloc>().add(ResetTrackingEvent());
    context.read<BookingBloc>().add(ResetBookingEvent());
    context.read<LocationBloc>().add(ClearDestinationEvent());
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _doneAndGoHome(context);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<TrackingBloc, TrackingState>(
            builder: (context, state) {
              Ride? ride;
              int selectedRating = 5;
              int? selectedTip;

              if (state is TripCompletedState) {
                ride = state.completedRide;
                selectedRating = state.selectedRating;
                selectedTip = state.selectedTip;
              } else if (state is DriverApproachingState) {
                ride = state.ride;
              } else if (state is TripInProgressState) {
                ride = state.ride;
              }

              if (ride == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Trip details not available'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _doneAndGoHome(context),
                        child: const Text('Back to Home'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // Success Icon
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success.withValues(alpha: 0.12),
                          border:
                              Border.all(color: AppColors.success, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 42,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      AppStrings.tripCompleted,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hope you enjoyed your electric ride with Vybe!',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Fare Card
                    TripCompletedFareCard(ride: ride),
                    const SizedBox(height: 16),

                    // Driver Rating Section (100% BLoC driven)
                    TripRatingSection(
                      driver: ride.driver,
                      selectedRating: selectedRating,
                      selectedTip: selectedTip,
                      onRatingChanged: (rating) {
                        context
                            .read<TrackingBloc>()
                            .add(UpdateTripRatingEvent(rating));
                      },
                      onTipChanged: (tip) {
                        context
                            .read<TrackingBloc>()
                            .add(UpdateTripTipEvent(tip));
                      },
                    ),
                    const SizedBox(height: 24),

                    // Done / Back to Home Button
                    CustomButton(
                      text: 'Done • Back to Home',
                      icon: Icons.home_rounded,
                      onPressed: () {
                        if (selectedTip != null) {
                          UiHelpers.showSnackBar(
                            context,
                            message:
                                'Tip of ₹$selectedTip added! Thank you.',
                          );
                        }
                        _doneAndGoHome(context);
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
