import '../entities/user_entity.dart';

abstract class IAuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserEntity> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  });
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
}
