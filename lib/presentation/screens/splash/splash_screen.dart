import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_paths.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/common/theme_toggle_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Trigger Auth verification
    context.read<AuthBloc>().add(AppStarted());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Wait 1.8 seconds for smooth splash experience
        Timer(const Duration(milliseconds: 1800), () {
          if (!mounted) return;
          if (state is Authenticated) {
            context.go(RoutePaths.home);
          } else if (state is Unauthenticated || state is AuthFailureState) {
            context.go(RoutePaths.auth);
          }
        });
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: isDark
                      ? [
                          const Color(0xFF1E202B),
                          AppColors.darkBackground,
                        ]
                      : [
                          const Color(0xFFFFFFFF),
                          const Color(0xFFF0F2F5),
                        ],
                ),
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Glowing Brand Flame Logo
                            Container(
                              width: 104,
                              height: 104,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.vybeFlameGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: isDark ? 0.5 : 0.35),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.electric_car_rounded,
                                  size: 54,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // App Name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Vybe',
                                  style: AppTextStyles.h1.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.white : AppColors.black,
                                  ),
                                ),
                                Text(
                                  'Cabs',
                                  style: AppTextStyles.h1.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Tagline
                            Text(
                              AppStrings.appTagline,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Loading spinner
                            const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Top Right Theme Switcher
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: const ThemeToggleButton(isCompact: true),
            ),
          ],
        ),
      ),
    );
  }
}
