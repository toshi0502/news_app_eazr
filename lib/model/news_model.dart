class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String fullContent;

  NewsArticle(
      {required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.fullContent});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      fullContent: json['fullContent'] ?? '',
    );
  }
}
