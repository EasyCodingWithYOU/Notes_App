// lib/Core/Routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:notes/Core/Routes/route_names.dart';
import 'package:notes/Features/Auth/Presentation/UI/auth_screen.dart';
import 'package:notes/Features/Error/Presentation/UI/error_screen.dart';

import 'package:notes/Features/Notes/Presentation/UI/notes_screen.dart';
import 'package:notes/Features/Splash/Ui/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.notes:
        final args = settings.arguments as Map<String, dynamic>;
        final uid = args['uid'];

        return MaterialPageRoute(builder: (_) => NotesScreen(uid: uid));

      case RouteNames.auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());

      case RouteNames.error:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(), // fallback
        );
    }
  }
}
