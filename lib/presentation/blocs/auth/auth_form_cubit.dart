import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthFormState extends Equatable {
  final bool isSignUp;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final bool obscurePassword;

  const AuthFormState({
    this.isSignUp = false,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.obscurePassword = true,
  });

  AuthFormState copyWith({
    bool? isSignUp,
    String? Function()? nameError,
    String? Function()? emailError,
    String? Function()? passwordError,
    bool? obscurePassword,
  }) {
    return AuthFormState(
      isSignUp: isSignUp ?? this.isSignUp,
      nameError: nameError != null ? nameError() : this.nameError,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError:
          passwordError != null ? passwordError() : this.passwordError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [
        isSignUp,
        nameError,
        emailError,
        passwordError,
        obscurePassword,
      ];
}

class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit() : super(const AuthFormState());

  void toggleAuthMode() {
    emit(state.copyWith(
      isSignUp: !state.isSignUp,
      nameError: () => null,
      emailError: () => null,
      passwordError: () => null,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void clearNameError() {
    if (state.nameError != null) {
      emit(state.copyWith(nameError: () => null));
    }
  }

  void clearEmailError() {
    if (state.emailError != null) {
      emit(state.copyWith(emailError: () => null));
    }
  }

  void clearPasswordError() {
    if (state.passwordError != null) {
      emit(state.copyWith(passwordError: () => null));
    }
  }

  void clearErrors() {
    if (state.nameError != null ||
        state.emailError != null ||
        state.passwordError != null) {
      emit(state.copyWith(
        nameError: () => null,
        emailError: () => null,
        passwordError: () => null,
      ));
    }
  }

  bool handleAuthError(String errorMessage) {
    final lower = errorMessage.toLowerCase();

    if (lower.contains('already registered') ||
        lower.contains('already in use') ||
        lower.contains('user registered') ||
        lower.contains('user-not-found') ||
        lower.contains('valid email') ||
        (lower.contains('email') && !lower.contains('password'))) {
      emit(state.copyWith(
        emailError: () => errorMessage,
        passwordError: () => null,
        nameError: () => null,
      ));
      return true;
    } else if (lower.contains('password') ||
        lower.contains('credential') ||
        lower.contains('weak')) {
      emit(state.copyWith(
        passwordError: () => errorMessage,
        emailError: () => null,
        nameError: () => null,
      ));
      return true;
    } else if (lower.contains('name')) {
      emit(state.copyWith(
        nameError: () => errorMessage,
        emailError: () => null,
        passwordError: () => null,
      ));
      return true;
    } else {
      emit(state.copyWith(
        nameError: () => null,
        emailError: () => null,
        passwordError: () => null,
      ));
      return false;
    }
  }
}
