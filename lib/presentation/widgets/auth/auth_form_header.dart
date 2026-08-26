import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class AuthFormHeader extends StatelessWidget {
  final bool isSignUp;
  final bool isLoading;
  final VoidCallback onGuestLogin;

  const AuthFormHeader({
    super.key,
    required this.isSignUp,
    required this.isLoading,
    required this.onGuestLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Product Label Tag
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardElevated : AppColors.lightChip,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isSignUp ? 'JOIN VYBE' : 'RIDER PORTAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Text(
          isSignUp ? AppStrings.createAccount : AppStrings.welcomeBack,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),

        Text(
          isSignUp ? AppStrings.signupSubtitle : AppStrings.loginSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // Guest Login Chip (Login Screen only)
        if (!isSignUp) ...[
          Center(
            child: ActionChip(
              label: Text(
                AppStrings.guestLogin,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              side: const BorderSide(color: AppColors.primary, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: isLoading ? null : onGuestLogin,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
