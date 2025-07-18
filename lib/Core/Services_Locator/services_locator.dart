import 'package:get_it/get_it.dart';

// Auth Feature
import 'package:notes/Features/Auth/Data/Repo_Imp/auth_repo_imp.dart';
import 'package:notes/Features/Auth/Data/Service/firebase_auth_services.dart';
import 'package:notes/Features/Auth/Data/Service/google_signin_services.dart';
import 'package:notes/Features/Auth/Data/Service/hive_services.dart';
import 'package:notes/Features/Auth/Domain/Repository/auth_repository.dart';
import 'package:notes/Features/Auth/Domain/Usecase/get_logged_in_user_usecase.dart';
import 'package:notes/Features/Auth/Domain/Usecase/sign_in_with_email_usecase.dart';
import 'package:notes/Features/Auth/Domain/Usecase/sign_in_with_google_usecase.dart';
import 'package:notes/Features/Auth/Domain/Usecase/sign_out_usecase.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_bloc.dart';
import 'package:notes/Features/Notes/Data/Repository_Imp/notes_repo_imp.dart';
import 'package:notes/Features/Notes/Data/Sources/notes_firebase_data_source.dart';
import 'package:notes/Features/Notes/Domain/Repository/notes_repository.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/add_note_usecase.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/delete_note.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/get_notes.dart';
import 'package:notes/Features/Notes/Domain/Use_Cases/update_note.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_bloc.dart';

// Notes Feature

final sl = GetIt.instance;

void init() {
  // ===================== 🔐 Auth =====================
  sl.registerLazySingleton(() => FirebaseAuthService());
  sl.registerLazySingleton(() => GoogleSignInService());
  sl.registerLazySingleton(() => HiveService());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );

  sl.registerLazySingleton(() => SignInWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetLoggedInUserUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signInWithGoogle: sl(),
      signOutUseCase: sl(),
      getLoggedInUser: sl(),
    ),
  );

  // ===================== 📝 Notes =====================
  sl.registerLazySingleton(() => NotesFirebaseDatasource());

  sl.registerLazySingleton<NoteRepository>(() => NoteRepositoryImpl(sl()));

  sl.registerLazySingleton(() => AddNote(sl()));
  sl.registerLazySingleton(() => DeleteNoteUseCase(sl()));
  sl.registerLazySingleton(() => GetNotesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNoteUseCase(sl()));

  sl.registerFactory(
    () => NoteBloc(
      addNoteUseCase: sl(),
      deleteNoteUseCase: sl(),
      getNotesUseCase: sl(),
      updateNoteUseCase: sl(),
    ),
  );
}
