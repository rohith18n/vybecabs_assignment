import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_form_cubit.dart';

void main() {
  group('AuthFormCubit Tests', () {
    blocTest<AuthFormCubit, AuthFormState>(
      'toggleAuthMode flips isSignUp and clears errors',
      build: () => AuthFormCubit(),
      act: (cubit) {
        cubit.toggleAuthMode();
        cubit.toggleAuthMode();
      },
      expect: () => [
        const AuthFormState(isSignUp: true),
        const AuthFormState(isSignUp: false),
      ],
    );

    blocTest<AuthFormCubit, AuthFormState>(
      'togglePasswordVisibility flips obscurePassword',
      build: () => AuthFormCubit(),
      act: (cubit) => cubit.togglePasswordVisibility(),
      expect: () => [
        const AuthFormState(obscurePassword: false),
      ],
    );

    blocTest<AuthFormCubit, AuthFormState>(
      'handleAuthError correctly maps email errors',
      build: () => AuthFormCubit(),
      act: (cubit) =>
          cubit.handleAuthError('The email address is already in use'),
      expect: () => [
        const AuthFormState(
          emailError: 'The email address is already in use',
        ),
      ],
    );

    blocTest<AuthFormCubit, AuthFormState>(
      'handleAuthError correctly maps password errors',
      build: () => AuthFormCubit(),
      act: (cubit) =>
          cubit.handleAuthError('Password must be at least 6 characters'),
      expect: () => [
        const AuthFormState(
          passwordError: 'Password must be at least 6 characters',
        ),
      ],
    );
  });
}
