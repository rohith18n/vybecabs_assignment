import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class SignInUseCase {
  final IAuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }
}
