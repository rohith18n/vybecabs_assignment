import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../blocs/location/location_bloc.dart';
import '../../blocs/location/location_event.dart';
import '../../blocs/location/location_state.dart';
import 'hotspot_list_tile.dart';
import 'location_search_header.dart';

class LocationPickerSheet extends StatelessWidget {
  final List<LocationEntity> hotspots;
  final ValueChanged<LocationEntity> onLocationSelected;

  const LocationPickerSheet({
    super.key,
    required this.hotspots,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = ['All', 'Popular', 'Airport', 'Tech Park', 'Mall', 'Station'];
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating Close Button
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
          height: screenHeight * 0.56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SafeArea(
            top: false,
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                String selectedCategory = 'All';
                List<LocationEntity> displayHotspots = hotspots;

                if (state is LocationLoaded) {
                  selectedCategory = state.selectedCategory;
                  displayHotspots = state.filteredHotspots;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationSearchHeader(
                      selectedCategory: selectedCategory,
                      categories: categories,
                      onSearchChanged: (val) {
                        context
                            .read<LocationBloc>()
                            .add(FilterHotspotsEvent(query: val));
                      },
                      onCategorySelected: (cat) {
                        context
                            .read<LocationBloc>()
                            .add(FilterHotspotsEvent(category: cat));
                      },
                    ),
                    Divider(
                      height: 1,
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider,
                    ),

                    // Hotspots List
                    if (displayHotspots.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 36,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No hotspots found for "$selectedCategory"',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: displayHotspots.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            indent: 58,
                            endIndent: 16,
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                          ),
                          itemBuilder: (context, index) {
                            final loc = displayHotspots[index];
                            return HotspotListTile(
                              location: loc,
                              onTap: () {
                                onLocationSelected(loc);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
