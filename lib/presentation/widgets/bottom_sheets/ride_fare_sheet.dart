import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../../domain/entities/vehicle_type.dart';
import '../cards/vehicle_option_card.dart';
import '../common/custom_button.dart';

class RideFareSheet extends StatelessWidget {
  final LocationEntity pickup;
  final LocationEntity destination;
  final List<VehicleType> availableVehicles;
  final VehicleType selectedVehicle;
  final double distanceKm;
  final double estimatedFare;
  final ValueChanged<VehicleType> onVehicleSelected;
  final VoidCallback onBookRide;
  final VoidCallback onChangeDestination;
  final VoidCallback? onClose;

  const RideFareSheet({
    super.key,
    required this.pickup,
    required this.destination,
    required this.availableVehicles,
    required this.selectedVehicle,
    required this.distanceKm,
    required this.estimatedFare,
    required this.onVehicleSelected,
    required this.onBookRide,
    required this.onChangeDestination,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating Zomato-style Close Button
        if (onClose != null)
          Center(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.darkCardElevated
                      : const Color(0xFF1E2024),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.white24,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        // Main Bottom Sheet Container
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Summary Card
                  Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightChip,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Sleek Route Indicator
                    Column(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1.5,
                          height: 24,
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Pickup / Drop texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pickup.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            destination.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Change Destination / Edit Route button
                    InkWell(
                      onTap: onChangeDestination,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardElevated : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Cabs',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${distanceKm.toStringAsFixed(1)} km • ~${(distanceKm * 2.5).ceil() + 3} min trip',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Vehicle Options
              ...availableVehicles.map((vehicle) {
                final isSelected = vehicle.id == selectedVehicle.id;
                return VehicleOptionCard(
                  vehicle: vehicle,
                  isSelected: isSelected,
                  distanceKm: distanceKm,
                  onSelect: () => onVehicleSelected(vehicle),
                );
              }),

              const SizedBox(height: 12),

              // Bottom Action Row: [Payment Option] [Book CTA Button]
              Row(
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
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);
  }
}
