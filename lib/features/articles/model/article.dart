import 'package:hive_ce/hive_ce.dart';

part 'article.g.dart';


class NewsResponse {
  final int totalResults;
  final List<Article> articles;

  NewsResponse({required this.totalResults, required this.articles});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    final articleList = json['articles'] as List<dynamic>? ?? [];
    return NewsResponse(
      totalResults: json['totalResults'] ?? 0,
      articles: articleList
          .whereType<Map<String, dynamic>>()
          .map(Article.fromJson)
          .toList(),
    );
  }
}

@HiveType(typeId: 0)
class Article extends HiveObject{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final DateTime publishedAt;
  @HiveField(5)
  final Source source;
  @HiveField(6)
  final String url;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.publishedAt,
    required this.source,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final sourceJson = json['source'] as Map<String, dynamic>? ?? {};
    final publishedAtRaw = _toSafeString(json['publishedAt']);
    final parsedDate = DateTime.tryParse(publishedAtRaw);

    return Article(
      id: _toSafeString(json['id']).isNotEmpty
          ? _toSafeString(json['id'])
          : _toSafeString(json['url']),
      title: _toSafeString(json['title'], fallback: 'Untitled article'),
      description: _toSafeString(
        json['description'],
        fallback: _toSafeString(json['content'], fallback: 'No summary available'),
      ),
      image: _toSafeString(json['urlToImage'], fallback: _toSafeString(json['image'])),
      publishedAt: parsedDate?.toLocal() ?? DateTime.fromMillisecondsSinceEpoch(0),
      source: Source.fromJson(sourceJson),
      url: _toSafeString(json['url']),
    );
  }
}

class Source {
  final String id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: _toSafeString(json['id']),
      name: _toSafeString(json['name'], fallback: 'Unknown source'),
    );
  }
}

String _toSafeString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }

  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  return value.toString();
}
