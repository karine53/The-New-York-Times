import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../models/news.dart';

class RssService {
  Future<List<News>> getNews(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar notícias');
    }

    final document = XmlDocument.parse(response.body);

    final items = document.findAllElements('item');

    return items.map((item) {
      final title = item.getElement('title')?.innerText ?? '';
      final description =
          item.getElement('description')?.innerText ?? '';
      final link = item.getElement('link')?.innerText ?? '';
      final guid = item.getElement('guid')?.innerText ?? '';
      final pubDate = item.getElement('pubDate')?.innerText;

      DateTime? publishedDate;

      if (pubDate != null && pubDate.isNotEmpty) {
        publishedDate = DateTime.tryParse(pubDate);
      }

      return News(
        title: title,
        description: description,
        url: link,
        guid: guid,
        publishedDate: publishedDate,
      );
    }).toList();
  }
}