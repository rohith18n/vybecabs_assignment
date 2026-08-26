import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/location_entity.dart';

class HotspotListTile extends StatelessWidget {
  final LocationEntity location;
  final VoidCallback onTap;

  const HotspotListTile({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    IconData iconData;
    Color iconColor;

    switch (location.category) {
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
        location.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
      subtitle: Text(
        location.subtitle,
        style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        size: 12,
      ),
      onTap: onTap,
    );
  }
}
