import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../models/news.dart';
import '../widgets/news_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.controller,
    required this.onOpenArticle,
  });

  final AppController controller;
  final ValueChanged<News> onOpenArticle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final articles = controller.favorites;
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            children: [
              Text(
                'Favoritos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                'Reportagens que você salvou para ler depois.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              if (articles.isEmpty)
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.bookmark_border, size: 34, color: Color(0xFFFF6538)),
                      const SizedBox(height: 10),
                      const Text(
                        'Sua lista está vazia',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Toque no marcador de uma notícia para salvá-la aqui.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              else
                for (final article in articles) ...[
                  NewsCard(
                    article: article,
                    regionName: article.regionName,
                    isFavorite: true,
                    onFavorite: () => controller.toggleFavorite(article),
                    onTap: () => onOpenArticle(article),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );
  }
}
