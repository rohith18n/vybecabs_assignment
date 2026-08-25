import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_paths.dart';
import '../../../domain/entities/location_entity.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/booking/booking_event.dart';
import '../../blocs/booking/booking_state.dart';
import '../../blocs/location/location_bloc.dart';
import '../../blocs/location/location_event.dart';
import '../../blocs/location/location_state.dart';
import '../../widgets/bottom_sheets/location_picker_sheet.dart';
import '../../widgets/bottom_sheets/ride_fare_sheet.dart';
import '../../widgets/common/theme_toggle_button.dart';
import '../../widgets/map/custom_map_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load current position and destination hotspots
    context.read<LocationBloc>().add(LoadLocationAndHotspots());
  }

  void _showLocationPicker(List<LocationEntity> hotspots) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return LocationPickerSheet(
          hotspots: hotspots,
          onLocationSelected: (selectedLocation) {
            context.read<LocationBloc>().add(
              SelectDestinationEvent(selectedLocation),
            );

            final locState = context.read<LocationBloc>().state;
            if (locState is LocationLoaded) {
              context.read<BookingBloc>().add(
                ConfigureBookingEvent(
                  pickup: locState.currentPickup,
                  destination: selectedLocation,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showProfileMenu() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        final authState = context.read<AuthBloc>().state;
        String userEmail = 'rider@vybecabs.com';
        String userName = 'Vybe Rider';

        if (authState is Authenticated) {
          userEmail = authState.user.email;
          userName = authState.user.displayName ?? userEmail.split('@').first;
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'V',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(userName, style: theme.textTheme.titleLarge),
                  subtitle: Text(userEmail, style: theme.textTheme.bodySmall),
                  trailing: const ThemeToggleButton(isCompact: true),
                ),
                Divider(
                  height: 24,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.history_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    AppStrings.rideHistory,
                    style: theme.textTheme.titleMedium,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                  ),
                  onTap: () {
                    Navigator.pop(modalContext);
                    context.push(RoutePaths.history);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                  ),
                  title: Text(
                    AppStrings.logout,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(modalContext);
                    context.read<AuthBloc>().add(SignOutRequested());
                    context.go(RoutePaths.auth);
                  },
                ),
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

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, bookingState) {
        if (bookingState is SearchingDriverState) {
          context.push(RoutePaths.findingDriver);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Map Area
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locState) {
                LatLng? pickup;
                LatLng? drop;

                if (locState is LocationLoaded) {
                  pickup = LatLng(
                    locState.currentPickup.latitude,
                    locState.currentPickup.longitude,
                  );
                  if (locState.selectedDestination != null) {
                    drop = LatLng(
                      locState.selectedDestination!.latitude,
                      locState.selectedDestination!.longitude,
                    );
                  }
                }

                return CustomMapView(
                  initialPosition: pickup ?? const LatLng(12.9716, 77.5946),
                  pickupLocation: pickup,
                  dropLocation: drop,
                  polylineColor: AppColors.primary,
                  showMyLocationButton: true,
                  padding: const EdgeInsets.only(top: 100, bottom: 260),
                );
              },
            ),

            // Top Floating Header: Logo & Action Buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface.withValues(alpha: 0.92)
                            : AppColors.lightSurface.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.3 : 0.08,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.asset(
                                AppAssets.appIcon,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Vybe',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions (Theme Toggle, History & Profile)
                    Row(
                      children: [
                        // Theme Toggle Button
                        const ThemeToggleButton(isCompact: true),
                        const SizedBox(width: 8),

                        // Ride History Button
                        FloatingActionButton.small(
                          heroTag: 'history_btn',
                          backgroundColor: isDark
                              ? AppColors.darkSurface.withValues(alpha: 0.92)
                              : AppColors.lightSurface.withValues(alpha: 0.95),
                          foregroundColor: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          elevation: 2,
                          onPressed: () => context.push(RoutePaths.history),
                          child: const Icon(Icons.history_rounded, size: 20),
                        ),
                        const SizedBox(width: 8),

                        // Profile / Logout Button
                        FloatingActionButton.small(
                          heroTag: 'profile_btn',
                          backgroundColor: isDark
                              ? AppColors.darkSurface.withValues(alpha: 0.92)
                              : AppColors.lightSurface.withValues(alpha: 0.95),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          elevation: 2,
                          onPressed: _showProfileMenu,
                          child: const Icon(Icons.person_rounded, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Area: "Where to?" Search Bar OR Ride Fare Sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, locState) {
                  if (locState is! LocationLoaded) {
                    return SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }

                  return BlocBuilder<BookingBloc, BookingState>(
                    builder: (context, bookingState) {
                      // If a drop destination is selected and booking configured, show RideFareSheet
                      if (bookingState is BookingConfigured) {
                        return RideFareSheet(
                          pickup: bookingState.pickup,
                          destination: bookingState.destination,
                          availableVehicles: bookingState.availableVehicles,
                          selectedVehicle: bookingState.selectedVehicle,
                          distanceKm: bookingState.distanceKm,
                          estimatedFare: bookingState.estimatedFare,
                          onVehicleSelected: (v) {
                            context.read<BookingBloc>().add(
                              SelectVehicleTypeEvent(v),
                            );
                          },
                          onBookRide: () {
                            context.read<BookingBloc>().add(
                              RequestBookRideEvent(),
                            );
                          },
                          onChangeDestination: () {
                            _showLocationPicker(locState.hotspots);
                          },
                        );
                      }

                      // Default: "Where to?" Search Card
                      return SafeArea(
                        top: false,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.35 : 0.08,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Where to today?',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Interactive search bar trigger
                              GestureDetector(
                                onTap: () =>
                                    _showLocationPicker(locState.hotspots),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkCard
                                        : AppColors.lightChip,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.lightBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.search_rounded,
                                        color: AppColors.primary,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        AppStrings.searchDestination,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: isDark
                                                  ? AppColors.darkTextMuted
                                                  : AppColors.lightTextMuted,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Quick Hotspot Chips
                              Text(
                                AppStrings.popularDestinations,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: locState.hotspots.map((hotspot) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: ActionChip(
                                        avatar: const Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                        label: Text(
                                          hotspot.title,
                                          style: TextStyle(
                                            color: isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        backgroundColor: isDark
                                            ? AppColors.darkCard
                                            : AppColors.lightChip,
                                        side: BorderSide(
                                          color: isDark
                                              ? AppColors.darkBorder
                                              : AppColors.lightBorder,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        onPressed: () {
                                          context.read<LocationBloc>().add(
                                            SelectDestinationEvent(hotspot),
                                          );
                                          context.read<BookingBloc>().add(
                                            ConfigureBookingEvent(
                                              pickup: locState.currentPickup,
                                              destination: hotspot,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
