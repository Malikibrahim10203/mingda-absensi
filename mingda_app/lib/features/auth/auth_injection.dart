import 'package:get_it/get_it.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:mingda_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mingda_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';

void initAuthInjection(GetIt sl) {
  sl.registerFactory(
    () => AuthBloc(
      signinUsecase: sl(),
      savetokenUsecase: sl(),
      checktokenUsecase: sl(),
    ),
  );

  sl.registerLazySingleton(() => SigninUsecase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
