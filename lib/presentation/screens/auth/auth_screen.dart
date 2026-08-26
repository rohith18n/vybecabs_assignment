import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/route_paths.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/theme_toggle_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false;
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    if (_nameError != null || _emailError != null || _passwordError != null) {
      setState(() {
        _nameError = null;
        _emailError = null;
        _passwordError = null;
      });
    }
  }

  void _handleAuthError(String errorMessage) {
    final lower = errorMessage.toLowerCase();

    setState(() {
      if (lower.contains('already registered') ||
          lower.contains('already in use') ||
          lower.contains('user registered') ||
          lower.contains('user-not-found') ||
          lower.contains('valid email') ||
          (lower.contains('email') && !lower.contains('password'))) {
        _emailError = errorMessage;
        _passwordError = null;
        _nameError = null;
      } else if (lower.contains('password') ||
          lower.contains('credential') ||
          lower.contains('weak')) {
        _passwordError = errorMessage;
        _emailError = null;
        _nameError = null;
      } else if (lower.contains('name')) {
        _nameError = errorMessage;
        _emailError = null;
        _passwordError = null;
      } else {
        _emailError = null;
        _passwordError = null;
        _nameError = null;
        UiHelpers.showSnackBar(
          context,
          message: errorMessage,
          isError: true,
        );
      }
    });
  }

  void _submit() {
    _clearErrors();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (_isSignUp) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              email: email,
              password: password,
              displayName: name.isNotEmpty ? name : null,
            ),
          );
    } else {
      context.read<AuthBloc>().add(
            SignInRequested(
              email: email,
              password: password,
            ),
          );
    }
  }

  void _fillDemoCredentials() {
    _clearErrors();
    _emailController.text = 'rider@vybecabs.com';
    _passwordController.text = 'Password123!';
    _nameController.text = 'Alex Rider';
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          UiHelpers.showSnackBar(
            context,
            message: 'Welcome to Vybe, ${state.user.displayName ?? state.user.email}!',
          );
          context.go(RoutePaths.home);
        } else if (state is AuthFailureState) {
          _handleAuthError(state.errorMessage);
        } else if (state is PasswordResetSent) {
          UiHelpers.showSnackBar(
            context,
            message: 'Password reset link sent to ${state.email}',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Top App Bar with Vybe Logo & Theme Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.asset(
                                AppAssets.appIcon,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Vybe',
                            style: AppTextStyles.h2.copyWith(
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      // Theme Switcher Button
                      const ThemeToggleButton(isCompact: true),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Product Label Tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkCardElevated
                                        : AppColors.lightChip,
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
                                        _isSignUp ? 'JOIN VYBE' : 'RIDER PORTAL',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.0,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Text(
                              _isSignUp ? AppStrings.createAccount : AppStrings.welcomeBack,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              _isSignUp ? AppStrings.signupSubtitle : AppStrings.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),

                            // Guest Login Chip (Login Screen only)
                            if (!_isSignUp) ...[
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
                                  onPressed: isLoading ? null : _fillDemoCredentials,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Sign Up - Display Name Field
                            if (_isSignUp) ...[
                              CustomTextField(
                                label: 'Full Name',
                                hint: 'Alex Rider',
                                controller: _nameController,
                                prefixIcon: Icons.person_outline_rounded,
                                textInputAction: TextInputAction.next,
                                errorText: _nameError,
                                onChanged: (value) {
                                  if (_nameError != null) {
                                    setState(() => _nameError = null);
                                  }
                                },
                                validator: (value) {
                                  if (_isSignUp && (value == null || value.trim().isEmpty)) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Email Field
                            CustomTextField(
                              label: AppStrings.emailLabel,
                              hint: AppStrings.emailHint,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              textInputAction: TextInputAction.next,
                              errorText: _emailError,
                              onChanged: (value) {
                                if (_emailError != null) {
                                  setState(() => _emailError = null);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                final emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            CustomTextField(
                              label: AppStrings.passwordLabel,
                              hint: AppStrings.passwordHint,
                              controller: _passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline_rounded,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _submit,
                              errorText: _passwordError,
                              onChanged: (value) {
                                if (_passwordError != null) {
                                  setState(() => _passwordError = null);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            CustomButton(
                              text: _isSignUp ? AppStrings.signUp : AppStrings.signIn,
                              isLoading: isLoading,
                              icon: _isSignUp
                                  ? Icons.person_add_rounded
                                  : Icons.login_rounded,
                              onPressed: _submit,
                            ),
                            const SizedBox(height: 24),

                            // Switch between Login and Sign Up
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isSignUp
                                      ? AppStrings.haveAccount
                                      : AppStrings.noAccount,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSignUp = !_isSignUp;
                                      _nameError = null;
                                      _emailError = null;
                                      _passwordError = null;
                                    });
                                    _formKey.currentState?.reset();
                                  },
                                  child: Text(
                                    _isSignUp ? AppStrings.signIn : AppStrings.signUp,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
