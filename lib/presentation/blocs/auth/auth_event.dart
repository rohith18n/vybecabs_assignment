import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class AuthStateChangedEvent extends AuthEvent {
  final UserEntity? user;
  const AuthStateChangedEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const SignUpRequested({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class SignOutRequested extends AuthEvent {}

class SendPasswordResetRequested extends AuthEvent {
  final String email;

  const SendPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}
