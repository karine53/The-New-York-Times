import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/regions.dart';
import 'models/news.dart';
import 'models/region_feed.dart';
import 'services/rss_service.dart';

class AppController extends ChangeNotifier {
  AppController._(this._preferences);

  final SharedPreferencesAsync _preferences;
  final RssService _rssService = RssService();
  final Map<String, List<News>> _regionNews = {};
  final Map<String, String> _regionErrors = {};
  final Set<String> _loadingRegions = {};
  final Set<String> _favorites = {};
  final Map<String, News> _favoriteArticles = {};

  late RegionFeed selectedRegion = regions.firstWhere(
    (region) => region.name == 'Europa',
    orElse: () => regions.first,
  );
  bool darkMode = true;
  bool largeText = false;
  bool notificationsEnabled = true;
  bool reduceMotion = false;

  static Future<AppController> create() async {
    final controller = AppController._(SharedPreferencesAsync());
    await controller._restorePreferences();
    return controller;
  }

  List<News> newsFor(RegionFeed region) =>
      List.unmodifiable(_regionNews[region.name] ?? const []);

  List<News> get allNews {
    final seen = <String>{};
    return _regionNews.values
        .expand((articles) => articles)
        .where((article) => seen.add(article.guid.isEmpty ? article.url : article.guid))
        .toList(growable: false);
  }

  List<News> get favorites => _favoriteArticles.values.toList(growable: false);

  bool isLoading(RegionFeed region) => _loadingRegions.contains(region.name);

  String? errorFor(RegionFeed region) => _regionErrors[region.name];

  bool isFavorite(News article) =>
      _favorites.contains(article.guid.isEmpty ? article.url : article.guid);

  Future<void> loadRegion(RegionFeed region, {bool refresh = false}) async {
    if (_loadingRegions.contains(region.name)) return;
    if (!refresh && _regionNews.containsKey(region.name)) return;

    _loadingRegions.add(region.name);
    _regionErrors.remove(region.name);
    notifyListeners();

    try {
      _regionNews[region.name] = await _rssService.getNews(
        region.url,
        regionName: region.name,
      );
    } catch (_) {
      _regionErrors[region.name] =
          'Não foi possível carregar as notícias. Verifique sua conexão e tente novamente.';
    } finally {
      _loadingRegions.remove(region.name);
      notifyListeners();
    }
  }

  Future<void> loadAllNews() async {
    await Future.wait(regions.map((region) => loadRegion(region)));
  }

  void selectRegion(RegionFeed region) {
    if (selectedRegion.name == region.name) return;
    selectedRegion = region;
    notifyListeners();
    loadRegion(region);
  }

  Future<void> toggleFavorite(News article) async {
    final id = article.guid.isEmpty ? article.url : article.guid;
    if (id.isEmpty) return;

    if (_favorites.remove(id)) {
      _favoriteArticles.remove(id);
    } else {
      _favorites.add(id);
      _favoriteArticles[id] = article;
    }
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    await _preferences.setBool('darkMode', value);
  }

  Future<void> setLargeText(bool value) async {
    largeText = value;
    notifyListeners();
    await _preferences.setBool('largeText', value);
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    notifyListeners();
    await _preferences.setBool('notificationsEnabled', value);
  }

  Future<void> setReduceMotion(bool value) async {
    reduceMotion = value;
    notifyListeners();
    await _preferences.setBool('reduceMotion', value);
  }

  Future<void> clearCachedNews() async {
    _regionNews.clear();
    _regionErrors.clear();
    notifyListeners();
    await loadAllNews();
  }

  Future<void> _restorePreferences() async {
    darkMode = await _preferences.getBool('darkMode') ?? true;
    largeText = await _preferences.getBool('largeText') ?? false;
    notificationsEnabled =
        await _preferences.getBool('notificationsEnabled') ?? true;
    reduceMotion = await _preferences.getBool('reduceMotion') ?? false;

    final savedFavorites = await _preferences.getStringList('favorites') ?? [];
    for (final encodedArticle in savedFavorites) {
      try {
        final article = News.decode(encodedArticle);
        final id = article.guid.isEmpty ? article.url : article.guid;
        if (id.isNotEmpty) {
          _favorites.add(id);
          _favoriteArticles[id] = article;
        }
      } on FormatException {
        // Ignore old or malformed saved entries and keep the rest available.
      } on TypeError {
        // Ignore old or malformed saved entries and keep the rest available.
      }
    }
  }

  Future<void> _saveFavorites() async {
    final serialized = _favoriteArticles.values
        .map((article) => jsonEncode(article.toJson()))
        .toList(growable: false);
    await _preferences.setStringList('favorites', serialized);
  }
}
