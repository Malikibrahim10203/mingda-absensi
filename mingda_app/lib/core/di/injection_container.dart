import 'package:get_it/get_it.dart';
import 'package:mingda_app/features/splash/splash_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  initSplashInjection(sl);
  // initAuthInjection(sl);
}
