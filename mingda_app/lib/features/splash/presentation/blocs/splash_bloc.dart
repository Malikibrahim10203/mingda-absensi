import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/splash/domain/usecases/checktoken_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ChecktokenUsecase checktokenUsecase;

  SplashBloc({required this.checktokenUsecase}) : super(InitialSplashState()) {
    on<AppStarted>((event, emit) async {
      // TODO: implement event handler
      emit(LoadingSplashState());
      final result = await checktokenUsecase();
      result.fold(
        (l) => emit(FailureSplashState()),
        (r) => emit(SuccessSplashState()),
      );
    });
  }
}
