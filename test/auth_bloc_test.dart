import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vybecabs_assignment/domain/entities/user_entity.dart';
import 'package:vybecabs_assignment/domain/repositories/auth_repository.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/auth_state_stream_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/sign_in_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/sign_out_usecase.dart';
import 'package:vybecabs_assignment/domain/usecases/auth/sign_up_usecase.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_bloc.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_event.dart';
import 'package:vybecabs_assignment/presentation/blocs/auth/auth_state.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('AuthBloc Tests', () {
    late MockAuthRepository mockAuthRepository;
    late StreamController<UserEntity?> authStreamController;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authStreamController = StreamController<UserEntity?>.broadcast();
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => authStreamController.stream);
    });

    tearDown(() {
      authStreamController.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [Authenticated] when AppStarted is dispatched and user exists',
      build: () {
        const user = UserEntity(uid: 'u1', email: 'test@vybe.com');
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => user);

        return AuthBloc(
          signInUseCase: SignInUseCase(mockAuthRepository),
          signUpUseCase: SignUpUseCase(mockAuthRepository),
          signOutUseCase: SignOutUseCase(mockAuthRepository),
          getCurrentUserUseCase: GetCurrentUserUseCase(mockAuthRepository),
          authStateStreamUseCase: AuthStateStreamUseCase(mockAuthRepository),
          authRepository: mockAuthRepository,
        );
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [
        const Authenticated(UserEntity(uid: 'u1', email: 'test@vybe.com')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful SignInRequested',
      build: () {
        const user = UserEntity(uid: 'u1', email: 'test@vybe.com');
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => null);
        when(() => mockAuthRepository.signInWithEmailPassword(
              email: 'test@vybe.com',
              password: 'Password123!',
            )).thenAnswer((_) async => user);

        return AuthBloc(
          signInUseCase: SignInUseCase(mockAuthRepository),
          signUpUseCase: SignUpUseCase(mockAuthRepository),
          signOutUseCase: SignOutUseCase(mockAuthRepository),
          getCurrentUserUseCase: GetCurrentUserUseCase(mockAuthRepository),
          authStateStreamUseCase: AuthStateStreamUseCase(mockAuthRepository),
          authRepository: mockAuthRepository,
        );
      },
      act: (bloc) => bloc.add(const SignInRequested(
        email: 'test@vybe.com',
        password: 'Password123!',
      )),
      expect: () => [
        AuthLoading(),
        const Authenticated(UserEntity(uid: 'u1', email: 'test@vybe.com')),
      ],
    );
  });
}
