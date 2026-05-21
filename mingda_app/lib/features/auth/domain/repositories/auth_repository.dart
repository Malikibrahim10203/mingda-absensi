import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginEntity>> SignIn({
    required String email,
    required String password,
  });
  // Future<void> SignOut();
  //
  // Future<Either<Failure, String>> CheckToken();
  // Future<Either<Failure, String>> GetToken();
  // Future<Either<Failure, String>> SaveToken();
  // Future<Either<Failure, String>> DelateToken();
}
