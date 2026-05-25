import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// Login berhasil
class AuthAuthenticated extends AuthState {}

// Belum login / token expired
class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
