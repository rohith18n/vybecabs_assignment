import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/vehicle_type.dart';
import '../common/custom_button.dart';

class FarePaymentActionRow extends StatelessWidget {
  final VehicleType selectedVehicle;
  final VoidCallback onBookRide;

  const FarePaymentActionRow({
    super.key,
    required this.selectedVehicle,
    required this.onBookRide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Payment Method Option (Left of Book button)
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightChip,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vybe Pay',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'UPI on Drop',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Book Ride CTA Button (Expanded)
        Expanded(
          child: CustomButton(
            text: 'Book ${selectedVehicle.name}',
            height: 50.0,
            onPressed: onBookRide,
          ),
        ),
      ],
    );
  }
}
