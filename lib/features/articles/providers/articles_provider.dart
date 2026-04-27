import 'package:flutter/material.dart';
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
}
