import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
}
