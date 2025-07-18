import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes/Core/App_Color/app_colors.dart';
import 'package:notes/Core/Routes/route_names.dart';

import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_bloc.dart';
import 'package:notes/Features/Auth/Presentation/Auth_Bloc/auth_event.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 100.sp,
                  color: AppColors.primary,
                ),
                SizedBox(height: 24.h),
                Text(
                  "Something went wrong",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  "We’re having trouble loading this screen. Please try again or check your connection.",
                  style: TextStyle(fontSize: 16.sp, color: AppColors.text),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Back",
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOut());
                      Navigator.pushReplacementNamed(
                        context,
                        RouteNames.splash,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
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
