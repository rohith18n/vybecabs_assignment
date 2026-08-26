import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_paths.dart';
import '../bottom_sheets/profile_menu_sheet.dart';
import '../common/theme_toggle_button.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Vybe Brand Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.92)
                    : AppColors.lightSurface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.asset(
                        AppAssets.appIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Vybe',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons (Theme Toggle, History & Profile)
            Row(
              children: [
                const ThemeToggleButton(isCompact: true),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'history_btn',
                  backgroundColor: isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.92)
                      : AppColors.lightSurface.withValues(alpha: 0.95),
                  foregroundColor: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  elevation: 2,
                  onPressed: () => context.push(RoutePaths.history),
                  child: const Icon(Icons.history_rounded, size: 20),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  heroTag: 'profile_btn',
                  backgroundColor: isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.92)
                      : AppColors.lightSurface.withValues(alpha: 0.95),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  elevation: 2,
                  onPressed: () => ProfileMenuSheet.show(context),
                  child: const Icon(Icons.person_rounded, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
