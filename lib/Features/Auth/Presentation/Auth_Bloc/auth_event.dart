abstract class AuthEvent {}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;
  SignInWithEmail(this.email, this.password);
}

class SignInWithGoogle extends AuthEvent {}

class CheckLogin extends AuthEvent {}

class SignOut extends AuthEvent {}
