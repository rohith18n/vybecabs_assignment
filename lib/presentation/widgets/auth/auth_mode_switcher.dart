import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class AuthModeSwitcher extends StatelessWidget {
  final bool isSignUp;
  final VoidCallback onToggle;

  const AuthModeSwitcher({
    super.key,
    required this.isSignUp,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSignUp ? AppStrings.haveAccount : AppStrings.noAccount,
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Text(
            isSignUp ? AppStrings.signIn : AppStrings.signUp,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
