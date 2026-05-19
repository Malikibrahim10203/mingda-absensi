part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeAuthEvent extends AuthEvent {}
