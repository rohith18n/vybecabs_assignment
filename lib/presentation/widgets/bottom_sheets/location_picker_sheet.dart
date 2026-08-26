import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/location_entity.dart';
import 'hotspot_list_tile.dart';
import 'location_search_header.dart';

class LocationPickerSheet extends StatefulWidget {
  final List<LocationEntity> hotspots;
  final ValueChanged<LocationEntity> onLocationSelected;

  const LocationPickerSheet({
    super.key,
    required this.hotspots,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = ['All', 'Popular', 'Airport', 'Tech Park', 'Mall', 'Station'];

    final filtered = widget.hotspots.where((loc) {
      final matchesCategory =
          _selectedCategory == 'All' || loc.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          loc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          loc.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationSearchHeader(
                  selectedCategory: _selectedCategory,
                  categories: categories,
                  onSearchChanged: (val) => setState(() => _searchQuery = val),
                  onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),

                // Hotspots List
                if (filtered.isEmpty)
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
                            'No hotspots found for "$_selectedCategory"',
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
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 58,
                        endIndent: 16,
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                      ),
                      itemBuilder: (context, index) {
                        final loc = filtered[index];
                        return HotspotListTile(
                          location: loc,
                          onTap: () {
                            widget.onLocationSelected(loc);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
