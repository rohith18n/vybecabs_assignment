import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/driver.dart';
import '../../../../domain/entities/ride.dart';
import 'driver_action_buttons.dart';
import 'driver_details_row.dart';

class DriverInfoCard extends StatelessWidget {
  final Driver driver;
  final Ride ride;
  final String statusTitle;
  final String statusSubtitle;
  final int etaMinutes;
  final int? etaSeconds;
  final bool isArrived;
  final bool isEnRoute;
  final bool isTripFinished;
  final VoidCallback? onStartTrip;

  const DriverInfoCard({
    super.key,
    required this.driver,
    required this.ride,
    required this.statusTitle,
    required this.statusSubtitle,
    required this.etaMinutes,
    this.etaSeconds,
    this.isArrived = false,
    this.isEnRoute = false,
    this.isTripFinished = false,
    this.onStartTrip,
  });

  String _formatEta() {
    if (isArrived) return 'HERE';
    if (etaSeconds != null) {
      final mins = etaSeconds! ~/ 60;
      final secs = etaSeconds! % 60;
      return '$mins:${secs.toString().padLeft(2, '0')}';
    }
    return '$etaMinutes MIN';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Status Header & ETA Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isArrived ? AppColors.success : AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusTitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: isArrived
                                    ? AppColors.success
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          statusSubtitle,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // ETA / Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isArrived
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isArrived ? AppColors.success : AppColors.primary,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatEta(),
                          style: TextStyle(
                            color: isArrived ? AppColors.success : AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          isArrived ? 'Waiting' : 'ETA',
                          style: TextStyle(
                            color: isArrived ? AppColors.success : AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Divider(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                height: 1,
              ),
              const SizedBox(height: 14),

              // Driver & Car Details Row
              DriverDetailsRow(driver: driver),

              const SizedBox(height: 14),

              // OTP and Fare Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightChip,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'START PIN: ${ride.otp ?? '4829'}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Text(
                      UiHelpers.formatCurrency(ride.fare),
                      style: AppTextStyles.priceMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Action Buttons
              DriverActionButtons(
                driver: driver,
                isArrived: isArrived,
                isEnRoute: isEnRoute,
                isTripFinished: isTripFinished,
                onStartTrip: onStartTrip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
