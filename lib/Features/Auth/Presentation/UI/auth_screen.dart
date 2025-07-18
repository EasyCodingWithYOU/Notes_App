import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/Core/App_Color/app_colors.dart';

import 'package:notes/Core/Images/svg_names.dart';
import 'package:notes/Core/Routes/route_names.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_bloc.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_event.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_state.dart';

import 'package:notes/Features/Auth/Presentation/Widgets/login_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          print('worked');

          final user = state.user;
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.notes,
            (_) => false,
            arguments: {
              'uid': user.uid, // Replace with actual UID
            },
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.text.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 32.h),
                LoginForm(),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignInWithGoogle());
                    },
                    icon: SvgPicture.asset(SvgNames.google, height: 24.h),
                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
