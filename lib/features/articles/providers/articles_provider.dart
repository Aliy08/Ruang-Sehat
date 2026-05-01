import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ruang_sehat/features/articles/data/articles_model.dart';
import 'package:ruang_sehat/features/articles/data/articles_services.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/my_articles_card.dart';


class ArticlesProvider with ChangeNotifier {
  List<ArticlesModel> _articles = [];
  List<ArticlesModel> _myArticles = [];
  ArticlesModel? _detailArticle;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  ArticlesModel? get detailArticle => _detailArticle;
  List<ArticlesModel> get articles => _articles;
  List<ArticlesModel> get myArticles => _myArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> getArticles() async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.getArticles();
      _articles = result;

      if (result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (e) {
      _errorMessage = _parseError(e);
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMyArticles() async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.getMyArticles();
      _myArticles = result;

      if (result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (e) {
      _errorMessage = _parseError(e);
      _myArticles = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getDetailArticle(String id) async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.getDetailArticle(id);
      _detailArticle = result;
    } catch (e) {
      _errorMessage = _parseError(e);
      _detailArticle = null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetMessage() {
    _successMessage = null;
    _errorMessage = null;
  }

  String _parseError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  // Create Artikel
  Future<void> createArticle(
    String title,
    String description,
    String category,
    String imagePath,
  ) async {
    _setLoading(true);
    _resetMessage();

    try {
      final StreamedResponse = await ArticlesServices.createArtikel(
        File(imagePath),
        title, 
        description, 
        category
      );

      final response = await http.Response.fromStream(StreamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel berhasil dibuat';

      } else if (response.statusCode == 400) {
        final firstError = data['errors'] [0];
        _errorMessage = firstError['message'] ?? "Terjadi kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
      }

    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Update Artikel
  Future<void> updateArticle(
    String id, {
    String? title,
    String? description,
    String? category,
    String? imagePath,
  }) async {
    _setLoading(true);
    _resetMessage();

    try {
      final streamedResponse = await ArticlesServices.updateArtikel(
        id,
        title: title,
        description: description,
        category: category,
        image: imagePath != null ? File(imagePath) : null,
      );

      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        await getDetailArticle(id);
        _successMessage = data['message'] ?? 'Artikel berhasil diperbarui';


      } else if (response.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError ['message'] ?? 'Terjadi kesalahan';

      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';

      }

    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';

    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
}
