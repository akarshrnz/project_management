import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management/features/auth/domain/entities/user_entity.dart';
import 'package:project_management/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_management/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:project_management/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:project_management/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_management/features/auth/domain/usecases/signup_usecase.dart';


import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final IsUserLoggedInUseCase isUserLoggedInUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.forgotPasswordUseCase,
    required this.isUserLoggedInUseCase,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit( AuthError("Login failed. Please try again."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signupUseCase(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit( AuthError("Signup failed. Please try again."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onForgotPasswordRequested(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase(event.email);
      emit(ForgotPasswordEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    try {
      final loggedIn = await isUserLoggedInUseCase();
      if (loggedIn) {
        final UserEntity? user = authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
          return;
        }
      }
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
