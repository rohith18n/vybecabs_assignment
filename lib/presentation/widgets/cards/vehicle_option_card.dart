import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../domain/entities/vehicle_type.dart';

class VehicleOptionCard extends StatelessWidget {
  final VehicleType vehicle;
  final bool isSelected;
  final double distanceKm;
  final VoidCallback onSelect;

  const VehicleOptionCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.distanceKm,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fare = vehicle.calculateFare(distanceKm);

    IconData vehicleIcon;
    Color iconAccent;
    switch (vehicle.iconName) {
      case 'ev':
        vehicleIcon = Icons.electric_car_rounded;
        iconAccent = AppColors.primary;
        break;
      case 'suv':
        vehicleIcon = Icons.airport_shuttle_rounded;
        iconAccent = isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5);
        break;
      case 'sedan':
        vehicleIcon = Icons.directions_car_filled_rounded;
        iconAccent = AppColors.primary;
        break;
      default:
        vehicleIcon = Icons.directions_car_rounded;
        iconAccent = AppColors.primaryLight;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppColors.darkCardElevated : const Color(0xFFFFF7ED))
            : (isDark ? AppColors.darkCard : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                // Vehicle icon avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(vehicleIcon, color: iconAccent, size: 22),
                ),
                const SizedBox(width: 12),

                // Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            vehicle.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : AppColors.lightChip,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_rounded,
                                    size: 10,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                const SizedBox(width: 2),
                                Text(
                                  '${vehicle.capacity}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${vehicle.etaMinutes} min away • ${vehicle.description}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Fare
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      UiHelpers.formatCurrency(fare),
                      style: AppTextStyles.priceMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        fontSize: 15.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'UPI / Cash',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 9.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
