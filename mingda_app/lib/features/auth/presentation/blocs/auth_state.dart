part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  AuthState(this.name);

  String name;

  @override
  // TODO: implement props
  List<Object?> get props => [this.name];
}

class InitialState extends AuthState {
  InitialState(super.name);
}

class LoadingState extends AuthState {
  LoadingState(super.name);
}

class FinishState extends AuthState {
  FinishState(super.name);
}

class ErrorState extends AuthState {
  ErrorState(super.name);
}
