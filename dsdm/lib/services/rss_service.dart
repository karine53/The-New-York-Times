import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../models/news.dart';

class RssService {
  static const _requestTimeout = Duration(seconds: 15);

  Future<List<News>> getNews(String url, {String regionName = 'Mundo'}) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw const FormatException('Endereço de feed RSS inválido.');
    }

    final response = await http
        .get(
          uri,
          headers: const {
            'Accept': 'application/rss+xml, application/xml, text/xml',
          },
        )
        .timeout(_requestTimeout);

    if (response.statusCode != 200) {
      throw RssFeedException(
        'O feed do New York Times respondeu com status ${response.statusCode}.',
      );
    }

    final document = XmlDocument.parse(utf8.decode(response.bodyBytes));
    final items = document.findAllElements('item');

    return items
        .map((item) => _parseItem(item, regionName))
        .where((news) => news.title.isNotEmpty)
        .toList(growable: false);
  }

  News _parseItem(XmlElement item, String regionName) {
    final title = _text(item, 'title');
    final rawDescription = _text(item, 'description');
    final description = _plainText(rawDescription);
    final link = _text(item, 'link');
    final guid = _text(item, 'guid');
    final pubDate = _text(item, 'pubDate');

    return News(
      title: title,
      description: description,
      url: link,
      guid: guid.isEmpty ? link : guid,
      publishedDate: _parseDate(pubDate),
      imageUrl: _imageUrl(item, rawDescription),
      regionName: regionName,
    );
  }

  String _text(XmlElement item, String name) =>
      item.getElement(name)?.innerText.trim() ?? '';

  String _plainText(String value) => value
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&#160;', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;

    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate.toUtc();

    // RSS pubDate uses RFC 822, for example "Mon, 23 Jun 2025 16:12:00 +0000".
    final match = RegExp(
      r'^(?:\w{3},?\s+)?(\d{1,2})\s+(\w{3})\s+(\d{2,4})\s+'
      r'(\d{1,2}):(\d{2})(?::(\d{2}))?\s*'
      r'(?:([+-]\d{4})|([A-Za-z]{1,5}))?$',
      caseSensitive: false,
    ).firstMatch(value.trim());
    if (match == null) return null;

    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final month = months[match.group(2)!.toLowerCase()];
    if (month == null) return null;

    var year = int.parse(match.group(3)!);
    if (year < 100) year += year < 50 ? 2000 : 1900;

    final zone = match.group(7)?.toUpperCase() ?? match.group(8)?.toUpperCase();
    var offset = Duration.zero;
    if (zone != null && zone != 'GMT' && zone != 'UTC' && zone != 'UT') {
      final numericZone = RegExp(r'^([+-])(\d{2})(\d{2})$').firstMatch(zone);
      if (numericZone != null) {
        final minutes = int.parse(numericZone.group(2)!) * 60 +
            int.parse(numericZone.group(3)!);
        offset = Duration(
          minutes: numericZone.group(1) == '+' ? minutes : -minutes,
        );
      } else {
        const namedZones = {
          'EST': -300,
          'EDT': -240,
          'CST': -360,
          'CDT': -300,
          'MST': -420,
          'MDT': -360,
          'PST': -480,
          'PDT': -420,
        };
        final minutes = namedZones[zone];
        if (minutes == null) return null;
        offset = Duration(minutes: minutes);
      }
    }

    final localDate = DateTime.utc(
      year,
      month,
      int.parse(match.group(1)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.tryParse(match.group(6) ?? '') ?? 0,
    );
    return localDate.subtract(offset);
  }

  String? _imageUrl(XmlElement item, String description) {
    for (final element in item.descendants.whereType<XmlElement>()) {
      if (element.name.local == 'content' ||
          element.name.local == 'thumbnail' ||
          element.name.local == 'enclosure') {
        String? url;
        for (final attribute in element.attributes) {
          if (attribute.name.local == 'url') {
            url = attribute.value;
            break;
          }
        }
        if (url != null && url.isNotEmpty) return url;
      }
    }

    final imageTag = RegExp(
      r"""<img[^>]+src=["']([^"']+)["']""",
      caseSensitive: false,
    ).firstMatch(description);
    return imageTag?.group(1);
  }
}

class RssFeedException implements Exception {
  final String message;

  const RssFeedException(this.message);

  @override
  String toString() => message;
}
