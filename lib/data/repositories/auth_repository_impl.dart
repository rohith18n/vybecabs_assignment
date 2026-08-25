import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await remoteDataSource.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await remoteDataSource.sendPasswordResetEmail(email);
  }
}
