import 'package:flutter/material.dart';
import 'package:news_app_eazr/model/news_model.dart';
import 'package:news_app_eazr/services/new_service.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String _currentCategory = 'general';
  int _currentPage = 1;
  bool _hasMoreArticles = true;
  String _errorMessage = '';

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get hasMoreArticles => _hasMoreArticles;
  String get errorMessage => _errorMessage;

  Future<void> fetchArticles(String category, {bool isRefresh = false}) async {
    if (isRefresh) {
      _articles = [];
      _currentPage = 1;
      _hasMoreArticles = true;
      _errorMessage = '';
    } else {
      _currentPage++;
    }

    _currentCategory = category;
    _isLoading = true;
    notifyListeners();

    try {
      final newArticles =
          await NewsService().fetchNewsArticles(category, _currentPage);
      if (newArticles.isEmpty) {
        _hasMoreArticles = false;
      } else {
        _articles.addAll(newArticles);
      }
    } catch (error) {
      _hasMoreArticles = false;
      _errorMessage = 'Error fetching articles: $error';
    }

    _isLoading = false;
    notifyListeners();
  }
}
