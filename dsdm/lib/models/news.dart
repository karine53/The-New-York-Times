import 'dart:convert';

class News {
  final String title;
  final String description;
  final String url;
  final String guid;
  final DateTime? publishedDate;
  final String? imageUrl;
  final String regionName;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.guid,
    this.publishedDate,
    this.imageUrl,
    this.regionName = 'Mundo',
  });

  Map<String, Object?> toJson() => {
        'title': title,
        'description': description,
        'url': url,
        'guid': guid,
        'publishedDate': publishedDate?.toIso8601String(),
        'imageUrl': imageUrl,
        'regionName': regionName,
      };

  factory News.fromJson(Map<String, dynamic> json) => News(
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        url: json['url'] as String? ?? '',
        guid: json['guid'] as String? ?? '',
        publishedDate: DateTime.tryParse(json['publishedDate'] as String? ?? ''),
        imageUrl: json['imageUrl'] as String?,
        regionName: json['regionName'] as String? ?? 'Mundo',
      );

  String encode() => jsonEncode(toJson());

  factory News.decode(String value) =>
      News.fromJson(jsonDecode(value) as Map<String, dynamic>);
}
