import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_paths.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/auth/auth_form_header.dart';
import '../../widgets/auth/auth_input_fields.dart';
import '../../widgets/auth/auth_mode_switcher.dart';
import '../../widgets/auth/auth_top_bar.dart';
import '../../widgets/common/custom_button.dart';

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
                const AuthTopBar(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthFormHeader(
                              isSignUp: _isSignUp,
                              isLoading: isLoading,
                              onGuestLogin: _fillDemoCredentials,
                            ),

                            AuthInputFields(
                              isSignUp: _isSignUp,
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              nameError: _nameError,
                              emailError: _emailError,
                              passwordError: _passwordError,
                              onNameChanged: (val) {
                                if (_nameError != null) {
                                  setState(() => _nameError = null);
                                }
                              },
                              onEmailChanged: (val) {
                                if (_emailError != null) {
                                  setState(() => _emailError = null);
                                }
                              },
                              onPasswordChanged: (val) {
                                if (_passwordError != null) {
                                  setState(() => _passwordError = null);
                                }
                              },
                              onSubmit: _submit,
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
                            AuthModeSwitcher(
                              isSignUp: _isSignUp,
                              onToggle: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                  _nameError = null;
                                  _emailError = null;
                                  _passwordError = null;
                                });
                                _formKey.currentState?.reset();
                              },
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
