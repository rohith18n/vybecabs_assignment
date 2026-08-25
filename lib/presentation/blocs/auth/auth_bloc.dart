import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/auth_state_stream_usecase.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../domain/usecases/auth/sign_in_usecase.dart';
import '../../../domain/usecases/auth/sign_out_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthStateStreamUseCase _authStateStreamUseCase;
  final IAuthRepository _authRepository;

  StreamSubscription? _authStateSubscription;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthStateStreamUseCase authStateStreamUseCase,
    required IAuthRepository authRepository,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authStateStreamUseCase = authStateStreamUseCase,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AuthStateChangedEvent>(_onAuthStateChanged);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<SendPasswordResetRequested>(_onSendPasswordResetRequested);

    // Listen to Firebase auth state stream to automatically handle session changes
    _authStateSubscription = _authStateStreamUseCase().listen((user) {
      add(AuthStateChangedEvent(user));
    });
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  void _onAuthStateChanged(AuthStateChangedEvent event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _signInUseCase(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _signUpUseCase(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _signOutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  Future<void> _onSendPasswordResetRequested(
    SendPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(PasswordResetSent(event.email));
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
