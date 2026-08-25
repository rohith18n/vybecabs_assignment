import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/theme/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  final bool isCompact;
  final VoidCallback? onToggled;

  const ThemeToggleButton({
    super.key,
    this.isCompact = true,
    this.onToggled,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        if (isCompact) {
          return Tooltip(
            message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                  onToggled?.call();
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCardElevated.withValues(alpha: 0.8)
                        : AppColors.lightChip,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      key: ValueKey<bool>(isDark),
                      size: 20,
                      color: isDark ? const Color(0xFFFFB800) : AppColors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // Pill variant with label
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.read<ThemeCubit>().toggleTheme();
              onToggled?.call();
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCardElevated.withValues(alpha: 0.8)
                    : AppColors.lightChip,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size: 16,
                    color: isDark ? const Color(0xFFFFB800) : AppColors.black,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isDark ? 'Light' : 'Dark',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
