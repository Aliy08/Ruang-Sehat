import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/articles_model.dart';
import 'package:ruang_sehat/features/articles/data/articles_services.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/my_articles_card.dart';

class ArticlesProvider with ChangeNotifier {
  List<ArticlesModel> _articles = [];
  List<ArticlesModel> __myArticles = [];
  ArticlesModel? _detailArticle;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getter
  List<ArticlesModel> get articles => _articles;
  List<ArticlesModel> get myArticles => __myArticles;
  ArticlesModel? get detailArticle => _detailArticle;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // get all articles
  Future<void> getArticles() async {
    _setLoading(true);
    _resetMessages();

    try {
      final result = await ArticlesServices.getArticles();
      _articles = result;

      if (result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  // get my articles
  Future<void> getMyArticles() async {
    _setLoading(true);
    _resetMessages();

    try {
      final result = await ArticlesServices.getMyArticles();
      __myArticles = result;

      if (result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      __myArticles = [];
    } finally {
      _setLoading(false);
    }
  }

  // get detail article
  Future<void> getDetailArticle(String id) async {
    _setLoading(true);
    _resetMessages();

    try {
      final result = await ArticlesServices.getDetailArticle(id);
    } catch (e) {
      _errorMessage = _parseError(e);
      _detailArticle = null;
    } finally {
      _setLoading(false);
    }
  }

  // Helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  String _parseError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }
}
