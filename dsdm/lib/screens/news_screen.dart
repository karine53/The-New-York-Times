import 'package:flutter/material.dart';

import '../models/news.dart';
import '../services/rss_service.dart';

class NewsScreen extends StatefulWidget {
  final String regionName;
  final String feedUrl;

  const NewsScreen({
    super.key,
    required this.regionName,
    required this.feedUrl,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final RssService rssService = RssService();

  List<News> news = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      final result = await rssService.getNews(widget.feedUrl);

      setState(() {
        news = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Não foi possível carregar as notícias.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.regionName),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!),
      );
    }

    if (news.isEmpty) {
      return const Center(
        child: Text('Nenhuma notícia encontrada.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final article = news[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(article.title),
            subtitle: Text(article.description),
          ),
        );
      },
    );
  }
}