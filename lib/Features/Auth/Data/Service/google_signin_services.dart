import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/Features/Auth/Domain/Entity/user_entity.dart';

class GoogleSignInService {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  Future<UserEntity> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    final googleAuth = await account!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _auth.signInWithCredential(credential);
    final user = result.user!;
    return UserEntity(
      uid: user.uid,
      email: user.email!,
      name: user.displayName ?? '',
    );
  }
}
