
class NewsResponse {
  final int totalResults;
  final List<Article> articles;

  NewsResponse({required this.totalResults, required this.articles});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      totalResults: json['totalResults'] ?? 0,
      articles: (json['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList(),
    );
  }
}

class Article {
  final String id;
  final String title;
  final String description;
  final String image;
  final DateTime publishedAt;
  final Source source;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.publishedAt,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      source: Source.fromJson(json['source'] ?? {}),
    );
  }
}

class Source {
  final String id;
  final String name;
  final String url;

  Source({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}