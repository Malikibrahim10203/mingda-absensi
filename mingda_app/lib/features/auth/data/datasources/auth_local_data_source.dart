import 'package:mingda_app/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();

  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
}
