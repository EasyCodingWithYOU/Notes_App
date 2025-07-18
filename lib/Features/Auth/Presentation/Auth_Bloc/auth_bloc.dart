import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Features/Auth/Domain/Usecase/get_logged_in_user_usecase.dart';
import 'package:notes/Features/Auth/Domain/Usecase/sign_in_with_email_usecase.dart';
import 'package:notes/Features/Auth/Domain/Usecase/sign_in_with_google_usecase.dart';
import 'package:notes/Features/Auth/Domain/Usecase/sign_out_usecase.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_event.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailUseCase signInWithEmail;
  final SignInWithGoogleUseCase signInWithGoogle;
  final GetLoggedInUserUseCase getLoggedInUser;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.signInWithEmail,
    required this.signInWithGoogle,
    required this.getLoggedInUser,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<CheckLogin>((event, emit) async {
      final user = await getLoggedInUser();
      if (user != null)
        emit(Authenticated(user));
      else
        emit(Unauthenticated());
    });

    on<SignInWithEmail>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithEmail(event.email, event.password);
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignInWithGoogle>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithGoogle();
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOut>((event, emit) async {
      await signOutUseCase();
      emit(Unauthenticated());
    });
  }
}
