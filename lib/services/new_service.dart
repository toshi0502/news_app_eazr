import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_eazr/model/news_model.dart';

class NewsService {
  static const _apiKey = '34dd4b17c4394775b532ccc29f3a9e5e';
  static const _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchNewsArticles(String category, int page) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/top-headlines?country=us&category=$category&page=$page&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> articlesJson = json.decode(response.body)['articles'];
      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
