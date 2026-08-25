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
  });

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
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

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
                    // Timeline dots
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 24,
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.error,
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
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            destination.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Change Destination button
                    IconButton(
                      icon: const Icon(Icons.edit_location_alt_rounded,
                          color: AppColors.primary, size: 20),
                      onPressed: onChangeDestination,
                      tooltip: 'Change destination',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Cabs',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${distanceKm.toStringAsFixed(1)} km • ~${(distanceKm * 2.5).ceil() + 3} min trip',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

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

              // Payment method row
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
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Vybe Pay / UPI on Drop',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'BEST FARE',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Book Ride CTA Button
              CustomButton(
                text: 'Book ${selectedVehicle.name}',
                icon: Icons.electric_bolt_rounded,
                onPressed: onBookRide,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
