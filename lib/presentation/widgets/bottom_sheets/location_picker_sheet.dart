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

    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating Zomato-style Close Button outside the bottom sheet
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Drop Location',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                // Search field (compact & sleek)
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 13.5,
                  ),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Search hotspot, tech park, mall...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      size: 18,
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkCard : AppColors.lightChip,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Category chips (compact)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          visualDensity: VisualDensity.compact,
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightChip,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 11.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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

          // Hotspots List (Stable, non-jumping height)
          if (filtered.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 36,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hotspots found for "$_selectedCategory"',
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
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
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(iconData, color: iconColor, size: 17),
                    ),
                    title: Text(
                      loc.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      loc.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      size: 12,
                    ),
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
