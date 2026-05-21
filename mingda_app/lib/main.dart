import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/app/config/app_routes.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:mingda_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mingda_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';

void main() {
  AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSourceImpl();
  final AuthRepository authRepository = AuthRepositoryImpl(
    authRemoteDataSource: authRemoteDataSource,
  );

  SigninUsecase signinUsecase = SigninUsecase(authRepository);

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(signinUsecase: signinUsecase),
      child: const MyApp(),
    ),
  );

  // return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppRoutes appRoutes = AppRoutes();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          onGenerateRoute: appRoutes.onRoute,
          initialRoute: '/',
        );
      },
    );
  }
}
