import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'theme_toggle_button.dart';

class VybeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showThemeToggle;

  const VybeAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.showThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final actionList = <Widget>[
      if (actions != null) ...actions!,
      if (showThemeToggle) ...[
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Center(
            child: ThemeToggleButton(isCompact: true),
          ),
        ),
      ],
    ];

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.92),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actionList,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
