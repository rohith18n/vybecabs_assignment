import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_paths.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_form_cubit.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/auth/auth_form_header.dart';
import '../../widgets/auth/auth_input_fields.dart';
import '../../widgets/auth/auth_mode_switcher.dart';
import '../../widgets/auth/auth_top_bar.dart';
import '../../widgets/common/custom_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _submit({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required bool isSignUp,
  }) {
    context.read<AuthFormCubit>().clearErrors();
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (isSignUp) {
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

  void _fillDemoCredentials({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController nameController,
    required bool isSignUp,
  }) {
    context.read<AuthFormCubit>().clearErrors();
    emailController.text = 'rider@vybecabs.com';
    passwordController.text = 'Password123!';
    nameController.text = 'Alex Rider';
    _submit(
      context: context,
      formKey: formKey,
      emailController: emailController,
      passwordController: passwordController,
      nameController: nameController,
      isSignUp: isSignUp,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              UiHelpers.showSnackBar(
                context,
                message:
                    'Welcome to Vybe, ${state.user.displayName ?? state.user.email}!',
              );
              context.go(RoutePaths.home);
            } else if (state is AuthFailureState) {
              final handled = context
                  .read<AuthFormCubit>()
                  .handleAuthError(state.errorMessage);
              if (!handled) {
                UiHelpers.showSnackBar(
                  context,
                  message: state.errorMessage,
                  isError: true,
                );
              }
            } else if (state is PasswordResetSent) {
              UiHelpers.showSnackBar(
                context,
                message: 'Password reset link sent to ${state.email}',
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              const AuthTopBar(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Form(
                            key: formKey,
                            child: BlocBuilder<AuthFormCubit, AuthFormState>(
                              builder: (context, formState) {
                                return BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, authState) {
                                    final isLoading =
                                        authState is AuthLoading;

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        AuthFormHeader(
                                          isSignUp: formState.isSignUp,
                                          isLoading: isLoading,
                                          onGuestLogin: () =>
                                              _fillDemoCredentials(
                                            context: context,
                                            formKey: formKey,
                                            emailController:
                                                emailController,
                                            passwordController:
                                                passwordController,
                                            nameController: nameController,
                                            isSignUp: formState.isSignUp,
                                          ),
                                        ),

                                        AuthInputFields(
                                          isSignUp: formState.isSignUp,
                                          nameController: nameController,
                                          emailController: emailController,
                                          passwordController:
                                              passwordController,
                                          nameError: formState.nameError,
                                          emailError: formState.emailError,
                                          passwordError:
                                              formState.passwordError,
                                          onNameChanged: (_) => context
                                              .read<AuthFormCubit>()
                                              .clearNameError(),
                                          onEmailChanged: (_) => context
                                              .read<AuthFormCubit>()
                                              .clearEmailError(),
                                          onPasswordChanged: (_) => context
                                              .read<AuthFormCubit>()
                                              .clearPasswordError(),
                                          onSubmit: () => _submit(
                                            context: context,
                                            formKey: formKey,
                                            emailController:
                                                emailController,
                                            passwordController:
                                                passwordController,
                                            nameController: nameController,
                                            isSignUp: formState.isSignUp,
                                          ),
                                        ),
                                        const SizedBox(height: 24),

                                        // Submit Button
                                        CustomButton(
                                          text: formState.isSignUp
                                              ? AppStrings.signUp
                                              : AppStrings.signIn,
                                          isLoading: isLoading,
                                          icon: formState.isSignUp
                                              ? Icons.person_add_rounded
                                              : Icons.login_rounded,
                                          onPressed: () => _submit(
                                            context: context,
                                            formKey: formKey,
                                            emailController:
                                                emailController,
                                            passwordController:
                                                passwordController,
                                            nameController: nameController,
                                            isSignUp: formState.isSignUp,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // Switch between Login and Sign Up
                                        AuthModeSwitcher(
                                          isSignUp: formState.isSignUp,
                                          onToggle: () {
                                            context
                                                .read<AuthFormCubit>()
                                                .toggleAuthMode();
                                            formKey.currentState?.reset();
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
