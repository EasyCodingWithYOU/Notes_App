import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';
import 'package:notes/Features/Auth/Domain/Repository/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.signInWithEmail(email, password);
  }
}
