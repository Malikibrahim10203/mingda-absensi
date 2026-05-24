import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/app/config/app_routes.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_local_data_source_impl.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source_impl.dart';
import 'package:mingda_app/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:mingda_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:mingda_app/features/splash/domain/usecases/checktoken_usecase.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SplashRemoteDataSource splashRemoteDataSource = SplashRemoteDataSourceImpl();
  SplashLocalDataSource splashLocalDataSource = SplashLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  final SplashRepository splashRepository = SplashRepositoryImpl(
    splashRemoteDataSource: splashRemoteDataSource,
    splashLocalDataSource: splashLocalDataSource,
  );

  ChecktokenUsecase checktokenUsecase = ChecktokenUsecase(
    splashRepository: splashRepository,
  );

  runApp(MyApp(checktokenUsecase: checktokenUsecase));
}

class MyApp extends StatelessWidget {
  final ChecktokenUsecase checktokenUsecase;
  const MyApp({super.key, required this.checktokenUsecase});

  @override
  Widget build(BuildContext context) {
    AppRoutes appRoutes = AppRoutes();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => SplashBloc(checktokenUsecase: checktokenUsecase),
          child: MaterialApp(
            onGenerateRoute: appRoutes.onRoute,
            initialRoute: '/',
          ),
        );
      },
    );
  }
}
