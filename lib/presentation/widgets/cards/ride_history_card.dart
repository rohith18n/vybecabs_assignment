import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/ride.dart';

class RideHistoryCard extends StatelessWidget {
  final Ride ride;
  final VoidCallback? onTap;

  const RideHistoryCard({
    super.key,
    required this.ride,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Vehicle Name & Date & Fare
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.electric_car_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ride.vehicleType.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              UiHelpers.formatDate(ride.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      UiHelpers.formatCurrency(ride.fare),
                      style: AppTextStyles.priceMedium.copyWith(
                        fontSize: 15.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  height: 1,
                ),
                const SizedBox(height: 8),

                // Pickup & Drop Route Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        children: [
                          const Icon(Icons.circle, color: AppColors.success, size: 7),
                          Container(
                            width: 1.5,
                            height: 14,
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                          const Icon(Icons.location_on_rounded, color: AppColors.error, size: 10),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride.pickup.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ride.destination.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (ride.driver != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Captain: ${ride.driver!.name}',
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (ride.userRating != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 13),
                            const SizedBox(width: 3),
                            Text(
                              '${ride.userRating!.toStringAsFixed(1)} ★ Rated',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
