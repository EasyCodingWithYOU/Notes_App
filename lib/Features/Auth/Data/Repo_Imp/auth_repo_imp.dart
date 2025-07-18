import 'package:notes/Features/Auth/Data/Model/user_model.dart';
import 'package:notes/Features/Auth/Data/Service/firebase_auth_services.dart';
import 'package:notes/Features/Auth/Data/Service/google_signin_services.dart';
import 'package:notes/Features/Auth/Data/Service/hive_services.dart';
import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';
import 'package:notes/Features/Auth/Domain/Repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseService;
  final GoogleSignInService googleService;
  final HiveService hiveService;

  AuthRepositoryImpl(
    this.firebaseService,
    this.googleService,
    this.hiveService,
  );

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final user = await firebaseService.signInWithEmail(email, password);
    await hiveService.saveUser(UserModel.fromEntity(user));
    return user;
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final user = await googleService.signInWithGoogle();
    await hiveService.saveUser(UserModel.fromEntity(user));
    return user;
  }

  @override
  Future<void> signOut() async {
    await firebaseService.signOut();
    await hiveService.clearUser();
  }

  @override
  Future<UserEntity?> getLoggedInUser() async {
    final model = await hiveService.getUser();
    return model?.toEntity();
  }
}
