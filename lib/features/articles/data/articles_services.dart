import 'dart:convert';
import 'dart:io';

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

  // Create Artikel
  static Future<http.StreamedResponse> createArtikel(
    File image,
    String title,
    String description,
    String category,
  ) async {
    final uri = Uri.parse('$articlesBaseUrl/create');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = DateTime.now().toIso8601String();
    request.fields['category'] = category;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    return await request.send();
  }

  //  Update Artikel
  static Future<http.StreamedResponse> updateArtikel(
    String id, {
    File? image,
    String? title,
    String? description,
    String? category,
  }) async {
    final uri = Uri.parse('$articlesBaseUrl/update/$id');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (title != null && title.isEmpty) request.fields['title'] = title;
    if (description != null && description.isEmpty) {
      request.fields['description'] = description;
    }
    if (category != null && category.isEmpty) {
      request.fields['category'] = category;
    }
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }


    return await request.send();
  }

  static Future<http.Response> deleteArtikel(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var url = Uri.parse('$articlesBaseUrl/delete/$id');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return response;
  }

  //
}
