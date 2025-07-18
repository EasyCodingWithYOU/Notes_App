import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';
import 'package:notes/Features/Auth/Domain/Repository/auth_repository.dart';

class GetLoggedInUserUseCase {
  final AuthRepository repository;

  GetLoggedInUserUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getLoggedInUser();
  }
}
