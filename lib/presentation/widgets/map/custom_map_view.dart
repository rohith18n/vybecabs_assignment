import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/map_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'map_overlay_builder.dart';

class MapMarkerIcons {
  final BitmapDescriptor? car;
  final BitmapDescriptor? pickup;
  final BitmapDescriptor? drop;

  const MapMarkerIcons({this.car, this.pickup, this.drop});
}

class CustomMapView extends StatefulWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final LatLng? pickupLocation;
  final LatLng? dropLocation;
  final LatLng? destinationLocation;
  final LatLng? carLocation;
  final double carBearing;
  final List<LatLng>? polylineCoordinates;
  final Color polylineColor;
  final EdgeInsets padding;
  final bool showMyLocationButton;
  final bool showNearbyDrivers;
  final VoidCallback? onMyLocationPressed;

  const CustomMapView({
    super.key,
    required this.initialPosition,
    this.initialZoom = 14.5,
    this.pickupLocation,
    this.dropLocation,
    this.destinationLocation,
    this.carLocation,
    this.carBearing = 0.0,
    this.polylineCoordinates,
    this.polylineColor = AppColors.primary,
    this.padding = EdgeInsets.zero,
    this.showMyLocationButton = true,
    this.showNearbyDrivers = false,
    this.onMyLocationPressed,
  });

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  final ValueNotifier<MapMarkerIcons> _iconsNotifier =
      ValueNotifier(const MapMarkerIcons());

  late AnimationController _auraController;
  late Animation<double> _auraRadiusAnimation;
  late Animation<double> _auraOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _auraRadiusAnimation = Tween<double>(begin: 20.0, end: 48.0).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    _auraOpacityAnimation = Tween<double>(begin: 0.28, end: 0.08).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    _loadCustomMarkers();
  }

  @override
  void dispose() {
    _auraController.dispose();
    _iconsNotifier.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadCustomMarkers() async {
    try {
      final car = await UiHelpers.createCarMarkerIcon(
        color: AppColors.primary,
        size: 56,
      );
      final pickup = await UiHelpers.createPinMarkerIcon(
        color: AppColors.success,
        iconData: Icons.my_location_rounded,
        size: 46,
      );
      final drop = await UiHelpers.createPinMarkerIcon(
        color: AppColors.primary,
        iconData: Icons.place_rounded,
        size: 46,
      );

      _iconsNotifier.value = MapMarkerIcons(
        car: car,
        pickup: pickup,
        drop: drop,
      );
    } catch (_) {
      // Fallback to default markers
    }
  }

  @override
  void didUpdateWidget(covariant CustomMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.carLocation != null &&
        (widget.carLocation != oldWidget.carLocation) &&
        _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(widget.carLocation!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveDrop = widget.dropLocation ?? widget.destinationLocation;

    return AnimatedBuilder(
      animation: _auraController,
      builder: (context, _) {
        return ValueListenableBuilder<MapMarkerIcons>(
          valueListenable: _iconsNotifier,
          builder: (context, icons, _) {
            final circles = MapOverlayBuilder.buildCircles(
              carLocation: widget.carLocation,
              pickupLocation: widget.pickupLocation,
              auraRadius: _auraRadiusAnimation.value,
              auraOpacity: _auraOpacityAnimation.value,
            );

            final markers = MapOverlayBuilder.buildMarkers(
              pickupLocation: widget.pickupLocation,
              dropLocation: effectiveDrop,
              carLocation: widget.carLocation,
              carBearing: widget.carBearing,
              pickupIcon: icons.pickup,
              dropIcon: icons.drop,
              carIcon: icons.car,
            );

            final polylines = MapOverlayBuilder.buildPolylines(
              polylineCoordinates: widget.polylineCoordinates,
              polylineColor: widget.polylineColor,
            );

            return GoogleMap(
              style: isDark ? MapStyles.darkMapStyle : MapStyles.lightMapStyle,
              initialCameraPosition: CameraPosition(
                target: widget.initialPosition,
                zoom: widget.initialZoom,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: markers,
              polylines: polylines,
              circles: circles,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              padding: widget.padding,
            );
          },
        );
      },
    );
  }
}
