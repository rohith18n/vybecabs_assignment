import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

enum ButtonType { primary, secondary, outline, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color textColor;
    BorderSide? borderSide;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        break;
      case ButtonType.secondary:
        backgroundColor = isDark ? AppColors.darkCardElevated : AppColors.black;
        textColor = isDark ? AppColors.darkTextPrimary : Colors.white;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        borderSide = BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.5,
        );
        break;
      case ButtonType.danger:
        backgroundColor = AppColors.error.withValues(alpha: 0.12);
        textColor = AppColors.error;
        borderSide = const BorderSide(color: AppColors.error, width: 1.0);
        break;
    }

    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.4),
          disabledForegroundColor: textColor.withValues(alpha: 0.4),
          elevation: type == ButtonType.primary ? (isDark ? 4 : 2) : 0,
          shadowColor: type == ButtonType.primary
              ? AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.25)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: borderSide ?? BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: textColor),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
