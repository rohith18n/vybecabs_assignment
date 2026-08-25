import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/driver.dart';
import '../../../../domain/entities/ride.dart';

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
              // Handle
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
                                color: isArrived ? AppColors.success : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
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

                  // ETA / Status Badge (Timer formatted like mm:ss)
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
              Row(
                children: [
                  // Driver Avatar
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkCardElevated : AppColors.lightChip,
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_rounded,
                            size: 30,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(Icons.shield_rounded, size: 11, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Driver Name & Rating (Non-truncating compact layout)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 15),
                            const SizedBox(width: 3),
                            Text(
                              '${driver.rating}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${driver.totalTrips}+ trips)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Car Registration Number Plate Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightChip,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          driver.carNumber,
                          style: TextStyle(
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          driver.carModel,
                          style: TextStyle(
                            fontSize: 9.5,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

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
                    Row(
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
                      ],
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

              // Action Buttons: Start Trip, En-Route Safety/Share, Call/Message, or Destination Arrival Info
              if (isArrived && onStartTrip != null) ...[
                ElevatedButton(
                  onPressed: onStartTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Boarded Cab • Start Trip',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (isTripFinished) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Center(
                    child: Text(
                      'Reached Destination • Concluding Trip',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ] else if (isEnRoute) ...[
                // En Route to destination: No Call/Message buttons (Passenger is inside the cab)
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.share_location_rounded,
                        label: 'Share Trip',
                        color: AppColors.primary,
                        onTap: () {
                          UiHelpers.showSnackBar(
                            context,
                            message: 'Live tracking link shared via WhatsApp / SMS',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.shield_rounded,
                        label: 'Safety Shield',
                        color: AppColors.success,
                        onTap: () {
                          UiHelpers.showSnackBar(
                            context,
                            message: 'Vybe Ride Shield: 24/7 GPS Tracking & Audio Monitored',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.emergency_rounded,
                        label: 'SOS Alert',
                        color: AppColors.error,
                        onTap: () {
                          UiHelpers.showSnackBar(
                            context,
                            message: 'SOS triggered: Emergency contacts & helpline alerted',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.call_rounded,
                        label: 'Call Driver',
                        color: AppColors.primary,
                        onTap: () {
                          UiHelpers.showSnackBar(
                            context,
                            message: 'Calling ${driver.name} at ${driver.phone}...',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.chat_bubble_rounded,
                        label: 'Message',
                        color: AppColors.whatsapp,
                        onTap: () {
                          UiHelpers.showSnackBar(
                            context,
                            message: 'Opening chat with ${driver.name}',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionButton(
                        icon: Icons.shield_outlined,
                        label: 'Safety',
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        onTap: () {
                          UiHelpers.showSnackBar(
                            context,
                            message: 'Vybe Safety Active • 24/7 Monitored Commute',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkCard : AppColors.lightChip,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
