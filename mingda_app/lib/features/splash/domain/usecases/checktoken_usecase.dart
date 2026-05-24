import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/splash/domain/repositories/splash_repository.dart';

class ChecktokenUsecase {
  final SplashRepository splashRepository;
  ChecktokenUsecase({required this.splashRepository});

  Future<Either<Failure, void>> call() async {
    final resultGetToken = await splashRepository.GetToken();

    return resultGetToken.fold((f) => Left(f), (r) async {
      return await splashRepository.CheckToken(r);
    });
  }
}
