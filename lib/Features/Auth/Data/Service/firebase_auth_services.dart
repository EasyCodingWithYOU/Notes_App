import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserEntity> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return UserEntity(
      uid: user.uid,
      email: user.email!,
      name: user.displayName ?? '',
    );
  }

  Future<void> signOut() => _auth.signOut();
}
