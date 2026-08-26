import 'package:equatable/equatable.dart';
import '../../../domain/entities/location_entity.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationEntity currentPickup;
  final LocationEntity? selectedDestination;
  final List<LocationEntity> hotspots;
  final String selectedCategory;
  final String searchQuery;

  const LocationLoaded({
    required this.currentPickup,
    this.selectedDestination,
    required this.hotspots,
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  List<LocationEntity> get filteredHotspots {
    return hotspots.where((loc) {
      final matchesCategory =
          selectedCategory == 'All' || loc.category == selectedCategory;
      final matchesQuery = searchQuery.isEmpty ||
          loc.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          loc.subtitle.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  LocationLoaded copyWith({
    LocationEntity? currentPickup,
    LocationEntity? selectedDestination,
    List<LocationEntity>? hotspots,
    String? selectedCategory,
    String? searchQuery,
    bool clearDestination = false,
  }) {
    return LocationLoaded(
      currentPickup: currentPickup ?? this.currentPickup,
      selectedDestination: clearDestination
          ? null
          : (selectedDestination ?? this.selectedDestination),
      hotspots: hotspots ?? this.hotspots,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        currentPickup,
        selectedDestination,
        hotspots,
        selectedCategory,
        searchQuery,
      ];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
