import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:ruang_sehat/features/articles/data/articles_model.dart';

class ArticlesServices {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String articleBaseUrl = '$baseUrl/article';

  // helper private
  static Future<dynamic> _getRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token tidak ditemukan');

    final url = Uri.parse('$articleBaseUrl$endpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Server error : ${response.statusCode}');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Format response tidak valid');
    }

    if (decoded['status'] != true) {
      if (decoded['message'] != null &&
          decoded['errors'] is List &&
          decoded['errors'].isNotEmpty) {
        throw Exception(decoded['errors'][0]['message']);
      } else {
        throw Exception(decoded['message'] ?? 'Terjadi kesalahan');
      }
    }
  }

  // get all articles
  static Future<List<ArticlesModel>> getArticles() async {
    final data = await _getRequest('');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticlesModel.fromJson(e)).toList();
  }

  static Future<List<ArticlesModel>> getMyArticles() async {
    final data = await _getRequest('/user');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticlesModel.fromJson(e)).toList();
  }

  static Future<ArticlesModel> getDetailArticle(String id) async {
    final data = await _getRequest('/$id');
    return ArticlesModel.fromJson(data);
  }
}
