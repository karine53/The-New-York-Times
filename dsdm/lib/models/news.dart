class News {
  final String title;
  final String description;
  final String url;
  final String guid;
  final DateTime? publishedDate;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.guid,
    this.publishedDate,
  });
}