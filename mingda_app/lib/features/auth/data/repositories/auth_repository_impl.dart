import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/domain/entities/login_entity.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl({required this.authRemoteDataSource});

  Future<Either<Failure, LoginEntity>> SignIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authRemoteDataSource.login(
        email: email,
        password: password,
      );

      return right(result);

      // Jika error Failure dari data source
    } on Failure catch (f) {
      return left(f);

      // Jika status code blm terbentuk
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
