import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../../domain/entities/vehicle_type.dart';
import '../cards/vehicle_option_card.dart';
import 'fare_payment_action_row.dart';
import 'fare_route_summary_card.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating Close Button
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
                  FareRouteSummaryCard(
                    pickup: pickup,
                    destination: destination,
                    onChangeDestination: onChangeDestination,
                  ),
                  const SizedBox(height: 10),

                  // Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Cabs',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
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

                  // Bottom Action Row: Payment Option & Book Button
                  FarePaymentActionRow(
                    selectedVehicle: selectedVehicle,
                    onBookRide: onBookRide,
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
