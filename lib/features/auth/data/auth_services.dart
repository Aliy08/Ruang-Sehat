import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruang_sehat/features/auth/data/user_model.dart';

class AuthServices {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String authBaseUrl = '$baseUrl/auth';

  // Fungsi Service Register
  static Future<http.Response> register(
    String name,
    String username,
    String password,
  ) async {
    final url = Uri.parse("$authBaseUrl/register");

    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "username": username,
        "password": password,
        "appSource": "kesehatan"
      }),
    );
  }

  // Fungsi Service Login
  static Future<http.Response> login(String username, String password) async {
    final url = Uri.parse('$authBaseUrl/login');

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        "appSource": "kesehatan",
      }),
    );
  }

  // Fungsi Service Logout
  static Future<http.Response> logout() async {
    final url = Uri.parse('$authBaseUrl/logout');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  // Fungsi service get profile
  static Future<UserModel> getProfile() async {
    final url = Uri.parse('$baseUrl/auth/profile');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    final decode = jsonDecode(response.body);

    if (response.statusCode == 200 && decode['success'] == true) {
      final data = decode['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception(decode['message'] ?? 'Gagal mengambil profile');
    }
  }

  // Fungsi Update Profile
  static Future<UserModel> updateProfile({
    required String name,
    required String username,
    String? password,
  }) async {
    final url = Uri.parse('$authBaseUrl/profile');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak ditemukan');
    }

    final body = <String, String>{
      'name': name,
      'username': username,
    };

    // password opsional
    if (password != null && password.trim().isNotEmpty) {
      body['password'] = password.trim();
    }

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    final decode = jsonDecode(response.body);

    if (response.statusCode == 200 && decode['success'] == true) {
      final data = decode['data'];
      return UserModel.fromJson(data);
    } else {
      // ambil error message jika ada
      if (decode['errors'] is List && decode['errors'].isNotEmpty) {
        throw Exception(
            decode['errors'][0]['message'] ?? 'Gagal update profile');
      }
      throw Exception(decode['message'] ?? 'Gagal update profile');
    }
  }
}
