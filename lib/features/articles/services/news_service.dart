import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/model/article.dart';



class NewsService {
  Dio dio = Dio();

  Future<NewsResponse> getTopHeadlines() async {
    var apiKey = dotenv.env['API_KEY'];
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {'country': 'us', 'apiKey': apiKey},
      );

      if (response.statusCode == 200) {
        log(response.statusMessage.toString());
        return NewsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load news');
      }
    } on DioException catch (e) {
      log(e.message!);
      throw Exception(e.message);
    }
  }

  Future<NewsResponse> getTopHeadlinesByCategory(String category) async {
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines',
      queryParameters: {
        'country': 'us',
        'category': category,
        'apiKey': dotenv.env['API_KEY'],
      },
    );

    if (response.statusCode == 200) {
      log(response.statusMessage.toString());
      return NewsResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load news for category: $category');
    }
  }

  Future<NewsResponse> searchArticles(String query) async {
    final apiKey = dotenv.env['API_KEY'];
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'apiKey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        log(response.data.toString());
        return NewsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search articles');
      }
    } on DioException catch (e) {
      log(e.message!);
      throw Exception(e.message);
    }
  }
}

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService();
});