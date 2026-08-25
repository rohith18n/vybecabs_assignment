import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/ride.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_event.dart';
import '../../blocs/history/history_state.dart';
import '../../widgets/cards/ride_history_card.dart';
import '../../widgets/common/vybe_app_bar.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistoryEvent());
  }

  void _showRideReceipt(BuildContext context, Ride ride) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ride Receipt',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'COMPLETED',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Trip ID: ${ride.id}',
                  style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
                const SizedBox(height: 16),
                Divider(color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
                const SizedBox(height: 12),
                _ReceiptRow(label: 'Cab Type', value: ride.vehicleType.name),
                _ReceiptRow(
                    label: 'Captain', value: ride.driver?.name ?? 'Vybe Captain'),
                _ReceiptRow(
                    label: 'Car Reg', value: ride.driver?.carNumber ?? 'KA-01-MJ-4829'),
                _ReceiptRow(
                    label: 'Distance', value: '${ride.distanceKm.toStringAsFixed(1)} km'),
                _ReceiptRow(label: 'Date & Time', value: UiHelpers.formatDate(ride.createdAt)),
                _ReceiptRow(label: 'Payment Method', value: 'Vybe Pay / UPI'),
                Divider(color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Fare Paid',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    Text(
                      UiHelpers.formatCurrency(ride.fare),
                      style: AppTextStyles.priceLarge.copyWith(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const VybeAppBar(
        title: AppStrings.rideHistory,
        showThemeToggle: true,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HistoryError) {
            return Center(
              child: Text(
                state.message,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
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
                      Icons.history_toggle_off_rounded,
                      size: 64,
                      color: isDark
                          ? AppColors.darkTextMuted.withValues(alpha: 0.5)
                          : AppColors.lightTextMuted.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noRidesYet,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              onRefresh: () async {
                context.read<HistoryBloc>().add(LoadHistoryEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: state.rides.length,
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
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
