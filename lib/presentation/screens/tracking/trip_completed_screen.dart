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
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_event.dart';
import '../../blocs/location/location_bloc.dart';
import '../../blocs/location/location_event.dart';
import '../../blocs/tracking/tracking_bloc.dart';
import '../../blocs/tracking/tracking_event.dart';
import '../../blocs/tracking/tracking_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/theme_toggle_button.dart';

class TripCompletedScreen extends StatefulWidget {
  const TripCompletedScreen({super.key});

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  int _selectedRating = 5;
  int? _selectedTip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        if (state is! TripCompletedState) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final ride = state.completedRide;
        final driver = ride.driver;

        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Top Bar with Theme Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vybe Receipt',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const ThemeToggleButton(isCompact: true),
                      ],
                    ),
                  ),

                  // Scrollable Receipt Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Success Glow Badge
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success.withValues(alpha: 0.15),
                              border: Border.all(color: AppColors.success, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 40,
                                color: AppColors.success,
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
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : AppColors.lightCard,
                              borderRadius: BorderRadius.circular(20),
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
                                Text('Total Fare Paid', style: theme.textTheme.bodyMedium),
                                const SizedBox(height: 4),
                                Text(
                                  UiHelpers.formatCurrency(ride.fare),
                                  style: AppTextStyles.priceLarge.copyWith(fontSize: 30),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Paid via Vybe Pay • Auto-Settled',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Divider(
                                  height: 1,
                                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                                ),
                                const SizedBox(height: 14),

                                // Route summary
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.circle, color: AppColors.success, size: 10),
                                        Container(
                                          width: 2,
                                          height: 26,
                                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                        ),
                                        const Icon(Icons.location_on_rounded,
                                            color: AppColors.error, size: 14),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ride.pickup.title,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            ride.destination.title,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Rating & Driver Card
                          if (driver != null) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                                borderRadius: BorderRadius.circular(20),
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
                                  Text(
                                    'How was your captain, ${driver.name}?',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 10),

                                  // Interactive Star Rating
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      final starValue = index + 1;
                                      return IconButton(
                                        icon: Icon(
                                          starValue <= _selectedRating
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: const Color(0xFFFFB800),
                                          size: 34,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedRating = starValue;
                                          });
                                        },
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 10),

                                  // Tip Selector Chips
                                  Text('Add a Captain Tip (Optional)', style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [20, 30, 50, 100].map((tip) {
                                      final isSelected = _selectedTip == tip;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: ChoiceChip(
                                          label: Text('₹$tip'),
                                          selected: isSelected,
                                          selectedColor: AppColors.primary,
                                          backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightChip,
                                          labelStyle: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          side: BorderSide(
                                            color: isSelected
                                                ? AppColors.primary
                                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                          ),
                                          onSelected: (selected) {
                                            setState(() {
                                              _selectedTip = selected ? tip : null;
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // Sticky Bottom Action Button within SafeArea
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: CustomButton(
                      text: AppStrings.done,
                      height: 50.0,
                      onPressed: () {
                        // Add completed ride to history bloc
                        context.read<HistoryBloc>().add(AddCompletedRideEvent(ride));

                        // Reset BLoCs
                        context.read<BookingBloc>().add(ResetBookingEvent());
                        context.read<TrackingBloc>().add(ResetTrackingEvent());
                        context.read<LocationBloc>().add(ClearDestinationEvent());

                        // Navigate home
                        context.go(RoutePaths.home);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
