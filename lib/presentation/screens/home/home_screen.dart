import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/route_paths.dart';
import '../../../domain/entities/location_entity.dart';
import '../../blocs/booking/booking_bloc.dart';
import '../../blocs/booking/booking_event.dart';
import '../../blocs/booking/booking_state.dart';
import '../../blocs/location/location_bloc.dart';
import '../../blocs/location/location_event.dart';
import '../../blocs/location/location_state.dart';
import '../../widgets/bottom_sheets/location_picker_sheet.dart';
import '../../widgets/bottom_sheets/ride_fare_sheet.dart';
import '../../widgets/home/home_top_bar.dart';
import '../../widgets/home/home_where_to_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, bookingState) {
        if (bookingState is SearchingDriverState) {
          context.push(RoutePaths.findingDriver);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Full Screen Map
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locState) {
                LatLng initialCameraPos = const LatLng(12.9716, 77.5946);
                LocationEntity? pickup;
                LocationEntity? destination;

                if (locState is LocationLoaded) {
                  initialCameraPos = locState.currentPickup.latLng;
                  pickup = locState.currentPickup;
                  destination = locState.selectedDestination;
                }

                return BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, bookingState) {
                    List<LatLng>? routeCoordinates;
                    if (bookingState is BookingConfigured) {
                      routeCoordinates = [
                        bookingState.pickup.latLng,
                        bookingState.destination.latLng,
                      ];
                    }

                    return CustomMapView(
                      initialPosition: initialCameraPos,
                      pickupLocation: pickup?.latLng,
                      destinationLocation: destination?.latLng,
                      polylineCoordinates: routeCoordinates,
                      showNearbyDrivers: true,
                    );
                  },
                );
              },
            ),

            // Top App Bar
            const Align(
              alignment: Alignment.topCenter,
              child: HomeTopBar(),
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
                          onClose: () {
                            context.read<BookingBloc>().add(
                              ResetBookingEvent(),
                            );
                            context.read<LocationBloc>().add(
                              ClearDestinationEvent(),
                            );
                          },
                        );
                      }

                      return HomeWhereToCard(
                        currentPickup: locState.currentPickup,
                        hotspots: locState.hotspots,
                        onTapSearch: () =>
                            _showLocationPicker(locState.hotspots),
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
