import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/map_styles.dart';
import '../../../../core/utils/ui_helpers.dart';
import 'map_overlay_builder.dart';

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
  BitmapDescriptor? _carIcon;
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropIcon;

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

    _auraController.addListener(() {
      if (mounted && widget.carLocation != null) {
        setState(() {});
      }
    });

    _loadCustomMarkers();
  }

  @override
  void dispose() {
    _auraController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadCustomMarkers() async {
    try {
      final car =
          await UiHelpers.createCarMarkerIcon(color: AppColors.primary, size: 56);
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

      if (mounted) {
        setState(() {
          _carIcon = car;
          _pickupIcon = pickup;
          _dropIcon = drop;
        });
      }
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
      pickupIcon: _pickupIcon,
      dropIcon: _dropIcon,
      carIcon: _carIcon,
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
  }
}
