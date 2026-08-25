import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class SignUpUseCase {
  final IAuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    String? displayName,
  }) {
    return repository.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
