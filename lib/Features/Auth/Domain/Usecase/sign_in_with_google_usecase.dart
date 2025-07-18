import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';
import 'package:notes/Features/Auth/Domain/Repository/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repo;

  SignInWithGoogleUseCase(this.repo);

  Future<UserEntity> call() => repo.signInWithGoogle();
}
