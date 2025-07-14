import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_management/injection_container.dart';

import 'core/config/router/app_router.dart';
import 'core/config/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await setupLocator(); 

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(
                loginUseCase: sl(),
                signupUseCase: sl(),
                forgotPasswordUseCase: sl(),
                isUserLoggedInUseCase: sl(),
                authRepository: sl(),
              )..add(CheckAuthStatus()),
            ),
            BlocProvider<HomeBloc>(
              create: (_) => HomeBloc(
                getProjects: sl(),
                addProject: sl(),
                uploadImage: sl(),
                uploadVideo: sl(),
                deleteImage: sl(),
                deleteVideo: sl(),
              )..add(FetchProjectsEvent()),
            ),
          ],
          child: MaterialApp(
            title: 'Project Manager',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: '/',
          ),
        );
      },
    );
  }
}
