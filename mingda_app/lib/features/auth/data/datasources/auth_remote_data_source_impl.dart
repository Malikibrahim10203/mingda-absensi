import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/models/login_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const baseURL = "https://absensi.mingda.my.id/api";

  Future<LoginModel> SignInDataSource({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth/login'),
      body: {'email': email, 'password': password, 'token_name': 'mobile-app'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return LoginModel.fromJson(body);
    }

    if (response.statusCode == 401) {
      throw AuthFailure(body['message'] ?? 'Email atau password salah');
    }

    if (response.statusCode == 422) {
      throw ValidationFailure(body['message'] ?? 'Format email tidak valid');
    }

    throw ServerFailure(
      body['message'] ?? 'Server error: ${response.statusCode}',
    );
  }

  Future<void> SignOutDataSource(String token) async {
    final response = await http.post(
      Uri.parse('${baseURL}/auth/logout'),
      headers: {'X-Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == '401') {
      throw AuthFailure(body['message']);
    }

    throw ServerFailure(
      body['message'] ?? 'Server error: ${response.statusCode}',
    );
  }

  // Future<UserModel> checkToken({required String token}) async {
  //   final response = await http.post(Uri.parse('$baseURL/api/'));
  //
  //   final body = jsonDecode(response.body) as Map<String, dynamic>;
  //
  //   if (response.statusCode == 200) {
  //     return UserModel.fromJson(body);
  //   }
  //
  //   throw ServerFailure(
  //     body['message'] ?? 'Server error: ${response.statusCode}',
  //   );
  // }
}
