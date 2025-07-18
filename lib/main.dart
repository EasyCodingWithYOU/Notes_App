import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/Core/Routes/route_names.dart';
import 'package:notes/Core/Routes/routes.dart';

import 'package:notes/Core/Services_Locator/services_locator.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_bloc.dart';
import 'package:notes/Features/Notes/Presentation/bloc/notes_bloc.dart';

import 'package:notes/Hive/user_hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase first
  await Firebase.initializeApp();

  // ✅ Initialize Hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());

  // ✅ Set up service locator
  init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 15 Pro
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
          BlocProvider<NoteBloc>(create: (_) => sl<NoteBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes App',

          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: RouteNames.splash,
        ),
      ),
    );
  }
}
