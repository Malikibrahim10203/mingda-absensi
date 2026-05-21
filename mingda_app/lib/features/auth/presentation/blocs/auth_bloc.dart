import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SigninUsecase signinUsecase;

  AuthBloc({required this.signinUsecase}) : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());

      final result = await signinUsecase(
        LoginParams(email: event.email, password: event.password),
      );

      result.fold(
        // Login gagal
        (failure) => emit(AuthError(failure.message)),

        // Login berhasil
        (login) => emit(AuthAuthenticated(login)),
      );
    });
  }
}
