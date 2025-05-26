import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;

  SignupRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
