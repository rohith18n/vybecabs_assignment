import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/map_styles.dart';
import '../../../../core/utils/ui_helpers.dart';

class CustomMapView extends StatefulWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final LatLng? pickupLocation;
  final LatLng? dropLocation;
  final LatLng? carLocation;
  final double carBearing;
  final List<LatLng>? polylineCoordinates;
  final Color polylineColor;
  final EdgeInsets padding;
  final bool showMyLocationButton;
  final VoidCallback? onMyLocationPressed;

  const CustomMapView({
    super.key,
    required this.initialPosition,
    this.initialZoom = 14.5,
    this.pickupLocation,
    this.dropLocation,
    this.carLocation,
    this.carBearing = 0.0,
    this.polylineCoordinates,
    this.polylineColor = AppColors.primary,
    this.padding = EdgeInsets.zero,
    this.showMyLocationButton = true,
    this.onMyLocationPressed,
  });

  @override
  State<CustomMapView> createState() => _CustomMapViewState();
}

class _CustomMapViewState extends State<CustomMapView> with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  Future<void> _loadCustomMarkers() async {
    try {
      final car = await UiHelpers.createCarMarkerIcon(color: AppColors.primary, size: 56);
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
    final Set<Marker> markers = {};
    final Set<Polyline> polylines = {};
    final Set<Circle> circles = {};

    // Bouncing animated car aura
    if (widget.carLocation != null) {
      circles.add(
        Circle(
          circleId: const CircleId('car_bouncing_aura'),
          center: widget.carLocation!,
          radius: _auraRadiusAnimation.value,
          fillColor: AppColors.primary.withValues(alpha: _auraOpacityAnimation.value),
          strokeColor: AppColors.primary.withValues(alpha: _auraOpacityAnimation.value * 1.5),
          strokeWidth: 1,
          zIndex: 4,
        ),
      );
    }

    // Pickup aura
    if (widget.pickupLocation != null) {
      circles.add(
        Circle(
          circleId: const CircleId('pickup_aura'),
          center: widget.pickupLocation!,
          radius: 18.0,
          fillColor: AppColors.success.withValues(alpha: 0.12),
          strokeColor: AppColors.success.withValues(alpha: 0.3),
          strokeWidth: 1,
          zIndex: 3,
        ),
      );
    }

    // Pickup Marker
    if (widget.pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup_marker'),
          position: widget.pickupLocation!,
          icon: _pickupIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    // Drop Marker
    if (widget.dropLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('drop_marker'),
          position: widget.dropLocation!,
          icon: _dropIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    // Animated Car Marker
    if (widget.carLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_car_marker'),
          position: widget.carLocation!,
          rotation: widget.carBearing,
          icon: _carIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: const InfoWindow(title: 'Vybe Captain'),
          anchor: const Offset(0.5, 0.5),
          flat: true,
          zIndex: 10,
        ),
      );
    }

    // Route Polyline
    if (widget.polylineCoordinates != null && widget.polylineCoordinates!.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route_polyline'),
          points: widget.polylineCoordinates!,
          color: widget.polylineColor,
          width: 5,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.carLocation ?? widget.pickupLocation ?? widget.initialPosition,
            zoom: widget.initialZoom,
          ),
          style: isDark ? MapStyles.darkMapStyle : MapStyles.lightMapStyle,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          padding: widget.padding,
          markers: markers,
          polylines: polylines,
          circles: circles,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),

        // My Location Button (floating on the top-right, directly below the profile button)
        if (widget.showMyLocationButton)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 62,
            child: FloatingActionButton.small(
              heroTag: 'my_loc_btn',
              backgroundColor: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.92)
                  : AppColors.lightSurface.withValues(alpha: 0.95),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              elevation: 2,
              onPressed: () {
                if (widget.onMyLocationPressed != null) {
                  widget.onMyLocationPressed!();
                } else if (_mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: widget.pickupLocation ?? widget.initialPosition,
                        zoom: 15.0,
                      ),
                    ),
                  );
                }
              },
              child: const Icon(Icons.near_me_rounded, size: 20),
            ),
          ),
      ],
    );
  }
}
