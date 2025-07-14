import 'package:flutter/material.dart';
import 'package:project_management/core/config/router/app_routes.dart';
import 'package:project_management/features/auth/presentation/pages/login_page.dart';
import 'package:project_management/features/auth/presentation/pages/signup_page.dart';
import 'package:project_management/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:project_management/features/form_submit/presentation/pages/form_page.dart';
import 'package:project_management/features/home/domain/entites/project_entity.dart';
import 'package:project_management/features/home/presentation/pages/home_screen.dart';
import 'package:project_management/features/home/presentation/pages/project_detail_screen.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      
      case AppRoutes.formSubmit:
        return MaterialPageRoute(builder: (_) => const FormPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.projectDetails:
        final project = settings.arguments as ProjectEntity;
        return MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(project: project),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
