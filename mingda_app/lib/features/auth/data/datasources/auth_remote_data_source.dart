import 'package:mingda_app/features/auth/data/models/login_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> SignInDataSource({
    required String email,
    required String password,
  });
  Future<void> SignOutDataSource(String token);
  // Future<UserModel> checkToken({required String token});
}
