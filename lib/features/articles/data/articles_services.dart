import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:ruang_sehat/features/articles/data/articles_model.dart';

class ArticlesServices {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String articlesBaseUrl = '$baseUrl/article';

  static Future<dynamic> _getRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Silahkan Login terlebih dahulu');

    final url = Uri.parse('$articlesBaseUrl/$endpoint');
    final response = await http.get(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode != 200) {
      throw Exception('Server Error ${response.statusCode}');
    }

    dynamic decode;
    try {
      decode = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Format response invalid');
    }

    if (decode['success'] != true) {
      if (decode['errors'] != null &&
          decode['errors'] is List &&
          decode['errors'].isNotEmpty) {
        throw Exception(decode['errors'][0]['message']);
      } else {
        throw Exception(decode['errors'] ?? 'Terjadi Kesalahan');
      }
    }
    return decode['data'];
  }

  static Future<List<ArticlesModel>> getArticles() async {
    final data = await _getRequest('');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticlesModel.fromJson(e)).toList();
  }

  static Future<List<ArticlesModel>> getMyArticles() async {
    final data = await _getRequest('user');
    final List articles = data['articles'] ?? [];
    return articles.map((e) => ArticlesModel.fromJson(e)).toList();
  }

  static Future<ArticlesModel> getDetailArticle(String id) async {
    final data = await _getRequest(id);
    return ArticlesModel.fromJson(data);
  }
}
