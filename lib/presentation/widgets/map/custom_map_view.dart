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

class _CustomMapViewState extends State<CustomMapView> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _carIcon;
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
  }

  Future<void> _loadCustomMarkers() async {
    try {
      final car = await UiHelpers.createCarMarkerIcon(color: AppColors.primary, size: 90);
      final pickup = await UiHelpers.createPinMarkerIcon(
        color: AppColors.success,
        iconData: Icons.person_pin_circle_rounded,
      );
      final drop = await UiHelpers.createPinMarkerIcon(
        color: AppColors.error,
        iconData: Icons.location_on_rounded,
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
          zIndexInt: 10,
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
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),

        // My Location Button (floating on the right, above bottom sheet/card)
        if (widget.showMyLocationButton)
          Positioned(
            right: 16,
            bottom: widget.padding.bottom > 0 ? widget.padding.bottom + 12 : 80,
            child: FloatingActionButton.small(
              heroTag: 'my_loc_btn',
              backgroundColor: isDark ? AppColors.darkCardElevated : AppColors.lightCard,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              elevation: 4,
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
              child: const Icon(Icons.my_location_rounded, size: 20),
            ),
          ),
      ],
    );
  }
}
