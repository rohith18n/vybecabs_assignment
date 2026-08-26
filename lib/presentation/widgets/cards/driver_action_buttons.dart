import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/driver.dart';

class DriverActionButtons extends StatelessWidget {
  final Driver driver;
  final bool isArrived;
  final bool isEnRoute;
  final bool isTripFinished;
  final VoidCallback? onStartTrip;

  const DriverActionButtons({
    super.key,
    required this.driver,
    required this.isArrived,
    required this.isEnRoute,
    required this.isTripFinished,
    this.onStartTrip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isArrived && onStartTrip != null) {
      return ElevatedButton(
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
      );
    }

    if (isTripFinished) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: const Center(
          child: Text(
            'Reached Destination • Concluding Trip',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    if (isEnRoute) {
      return Row(
        children: [
          Expanded(
            child: ActionTile(
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
            child: ActionTile(
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
            child: ActionTile(
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
      );
    }

    return Row(
      children: [
        Expanded(
          child: ActionTile(
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
          child: ActionTile(
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
          child: ActionTile(
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
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
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
