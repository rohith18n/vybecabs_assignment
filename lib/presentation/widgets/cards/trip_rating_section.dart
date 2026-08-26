import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/driver.dart';

class TripRatingSection extends StatelessWidget {
  final Driver? driver;
  final int selectedRating;
  final int? selectedTip;
  final ValueChanged<int> onRatingChanged;
  final ValueChanged<int?> onTipChanged;

  const TripRatingSection({
    super.key,
    required this.driver,
    required this.selectedRating,
    required this.selectedTip,
    required this.onRatingChanged,
    required this.onTipChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          if (driver != null) ...[
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              backgroundImage: driver!.photoUrl.isNotEmpty
                  ? NetworkImage(driver!.photoUrl)
                  : null,
              child: driver!.photoUrl.isEmpty
                  ? Text(
                      driver!.name.isNotEmpty ? driver!.name[0] : 'D',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              'How was your ride with ${driver!.name}?',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
          ],

          // 5 Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () => onRatingChanged(starIndex),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    starIndex <= selectedRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: starIndex <= selectedRating
                        ? const Color(0xFFFFB800)
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    size: 38,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Add tip
          Text(
            'Add a tip for great service?',
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [30, 50, 100].map((tip) {
              final isSelected = selectedTip == tip;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text('₹$tip'),
                  selected: isSelected,
                  onSelected: (selected) {
                    onTipChanged(selected ? tip : null);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
