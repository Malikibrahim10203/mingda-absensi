import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> SignIn();
  Future<Either<Failure, String>> SignOut();

  Future<Either<Failure, String>> CheckToken();
  Future<Either<Failure, String>> GetToken();
  Future<Either<Failure, String>> SaveToken();
  Future<Either<Failure, String>> DelateToken();
}
