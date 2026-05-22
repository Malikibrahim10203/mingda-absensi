import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/auth/domain/usecases/savetoken_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SigninUsecase signinUsecase;
  final SavetokenUsecase savetokenUsecase;

  AuthBloc({required this.signinUsecase, required this.savetokenUsecase})
    : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());

      final result = await signinUsecase(
        LoginParams(email: event.email, password: event.password),
      );

      result.fold(
        // Login
        (failure) => emit(AuthError(failure.message)),

        // Login
        (login) async {
          final saveTokenResult = await savetokenUsecase(login.token);
          saveTokenResult.fold(
            (cacheFailure) async => emit(AuthError(cacheFailure.message)),
            (_) {
              emit(AuthAuthenticated(login));
            },
          );
        },
      );
    });
  }
}
