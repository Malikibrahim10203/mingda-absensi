import 'package:mingda_app/features/auth/data/models/login_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({required String email, required String password});
  // Future<UserModel> checkToken({required String token});
}
