import 'package:mingda_app/features/auth/domain/entities/login_entity.dart';
import 'package:mingda_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Login berhasil
class AuthAuthenticated extends AuthState {
  final LoginEntity login;

  AuthAuthenticated(this.login);

  UserEntity get user => login.userModel;
}

// Belum login / token expired
class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
