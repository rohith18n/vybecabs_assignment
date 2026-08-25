import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/location_entity.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categories = ['All', 'Popular', 'Airport', 'Tech Park', 'Mall', 'Station'];

    final filtered = widget.hotspots.where((loc) {
      final matchesCategory =
          _selectedCategory == 'All' || loc.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          loc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          loc.subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Drop Location',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                // Search field
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 15,
                  ),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Search hotspot, tech park, mall...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkCard : AppColors.lightChip,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightChip,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedCategory = cat);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),

          // Hotspots List
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filtered.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 68,
                endIndent: 20,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              itemBuilder: (context, index) {
                final loc = filtered[index];
                IconData iconData;
                Color iconColor;

                switch (loc.category) {
                  case 'Airport':
                    iconData = Icons.flight_takeoff_rounded;
                    iconColor = AppColors.info;
                    break;
                  case 'Tech Park':
                    iconData = Icons.business_rounded;
                    iconColor = AppColors.primary;
                    break;
                  case 'Mall':
                    iconData = Icons.shopping_bag_rounded;
                    iconColor = AppColors.primaryLight;
                    break;
                  case 'Station':
                    iconData = Icons.train_rounded;
                    iconColor = AppColors.warning;
                    break;
                  default:
                    iconData = Icons.location_on_rounded;
                    iconColor = AppColors.primary;
                }

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconData, color: iconColor, size: 22),
                  ),
                  title: Text(
                    loc.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    loc.subtitle,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    size: 14,
                  ),
                  onTap: () {
                    widget.onLocationSelected(loc);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
