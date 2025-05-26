import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project_management/features/auth/presentation/bloc/auth_event.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(CheckAuthStatus());

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 50.w,
          height: 50.w,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
