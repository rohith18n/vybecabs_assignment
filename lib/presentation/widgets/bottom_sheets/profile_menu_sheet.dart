import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_paths.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../common/theme_toggle_button.dart';

class ProfileMenuSheet extends StatelessWidget {
  const ProfileMenuSheet({super.key});

  static Future<void> show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => const ProfileMenuSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = context.read<AuthBloc>().state;
    String userEmail = 'rider@vybecabs.com';
    String userName = 'Vybe Rider';

    if (authState is Authenticated) {
      userEmail = authState.user.email;
      userName = authState.user.displayName ?? userEmail.split('@').first;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'V',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(userName, style: theme.textTheme.titleLarge),
              subtitle: Text(userEmail, style: theme.textTheme.bodySmall),
              trailing: const ThemeToggleButton(isCompact: true),
            ),
            Divider(
              height: 24,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            ListTile(
              leading: const Icon(
                Icons.history_rounded,
                color: AppColors.primary,
              ),
              title: Text(
                AppStrings.rideHistory,
                style: theme.textTheme.titleMedium,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
              ),
              onTap: () {
                Navigator.pop(context);
                context.push(RoutePaths.history);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
              ),
              title: Text(
                AppStrings.logout,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(SignOutRequested());
                context.go(RoutePaths.auth);
              },
            ),
          ],
        ),
      ),
    );
  }
}
