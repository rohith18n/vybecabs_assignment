import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../common/custom_text_field.dart';

class AuthInputFields extends StatelessWidget {
  final bool isSignUp;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;

  const AuthInputFields({
    super.key,
    required this.isSignUp,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.nameError,
    required this.emailError,
    required this.passwordError,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isSignUp) ...[
          CustomTextField(
            label: 'Full Name',
            hint: 'Alex Rider',
            controller: nameController,
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            errorText: nameError,
            onChanged: onNameChanged,
            validator: (value) {
              if (isSignUp && (value == null || value.trim().isEmpty)) {
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
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          textInputAction: TextInputAction.next,
          errorText: emailError,
          onChanged: onEmailChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
          controller: passwordController,
          isPassword: true,
          prefixIcon: Icons.lock_outline_rounded,
          textInputAction: TextInputAction.done,
          onEditingComplete: onSubmit,
          errorText: passwordError,
          onChanged: onPasswordChanged,
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
      ],
    );
  }
}
