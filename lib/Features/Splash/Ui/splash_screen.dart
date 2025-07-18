import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes/Core/App_Color/app_colors.dart';
import 'package:notes/Core/Routes/route_names.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_bloc.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_event.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthState? _authState;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckLogin());

    // Listen for AuthBloc state after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (_authState is Authenticated) {
        final user = (_authState as Authenticated).user;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.notes,
          (_) => false,
          arguments: {
            'uid': user.uid, // Replace with actual UID
          },
        );
      } else if (_authState is Unauthenticated) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.auth,
          (_) => false,
        );
      } else if (_authState is AuthError) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.error,
          (_) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          _authState = state;
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notes, size: 100.r, color: AppColors.primary),
              SizedBox(height: 20.h),
              Text(
                'Notes App',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Your notes, anywhere.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.text.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 40.h),
              CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
