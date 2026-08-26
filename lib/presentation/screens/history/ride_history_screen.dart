import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/ride.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_event.dart';
import '../../blocs/history/history_state.dart';
import '../../widgets/bottom_sheets/ride_receipt_bottom_sheet.dart';
import '../../widgets/cards/ride_history_card.dart';
import '../../widgets/common/vybe_app_bar.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  void _showRideReceipt(BuildContext context, Ride ride) {
    RideReceiptBottomSheet.show(context, ride);
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<HistoryBloc>().state is HistoryInitial) {
      context.read<HistoryBloc>().add(LoadHistoryEvent());
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const VybeAppBar(
        title: AppStrings.rideHistory,
        showThemeToggle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is HistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HistoryBloc>().add(LoadHistoryEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is HistoryLoaded) {
              if (state.rides.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 64,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.noRidesYet,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your past completed rides will show up here',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<HistoryBloc>().add(LoadHistoryEvent());
                },
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: state.rides.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final ride = state.rides[index];
                    return RideHistoryCard(
                      ride: ride,
                      onTap: () => _showRideReceipt(context, ride),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
