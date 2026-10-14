import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../data/regions.dart';
import '../models/news.dart';
import '../models/region_feed.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/news_card.dart';
import '../widgets/region_card.dart';
import '../widgets/world_map_painter.dart';

const _accent = Color(0xFFFF6538);

class RegionScreen extends StatelessWidget {
  const RegionScreen({
    super.key,
    required this.controller,
    required this.region,
    required this.onTabSelected,
    required this.onOpenArticle,
    required this.onOpenRegion,
  });

  final AppController controller;
  final RegionFeed region;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<News> onOpenArticle;
  final ValueChanged<RegionFeed> onOpenRegion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNav(selectedIndex: 0, onSelected: onTabSelected),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final articles = controller.newsFor(region);
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Voltar ao mapa',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                    Expanded(
                      child: Text(
                        region.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Atualizar notícias',
                      onPressed: () => controller.loadRegion(region, refresh: true),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0A1E31), Color(0xFF173D69)],
                    ),
                  ),
                  child: WorldMapPainter(
                    regiaoSelecionada: region.name,
                    aoSelecionar: (name) {
                      final result = regions.where((item) => item.name == name);
                      if (result.isNotEmpty) onOpenRegion(result.first);
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'EM DESTAQUE · ${region.name.toUpperCase()}',
                  style: const TextStyle(
                    color: _accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 11),
                if (controller.isLoading(region) && articles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(34),
                    child: Center(
                      child: CircularProgressIndicator(color: _accent),
                    ),
                  )
                else if (controller.errorFor(region) != null && articles.isEmpty)
                  _errorCard(context)
                else if (articles.isEmpty)
                  _emptyCard(context)
                else
                  ...articles.take(12).map(
                    (article) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NewsCard(
                        article: article,
                        regionName: region.name,
                        isFavorite: controller.isFavorite(article),
                        onFavorite: () => controller.toggleFavorite(article),
                        onTap: () => onOpenArticle(article),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Outras regiões',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: regions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = regions[index];
                      return RegionCard(
                        region: item,
                        selected: item.name == region.name,
                        reduceMotion: controller.reduceMotion,
                        onTap: () => onOpenRegion(item),
                      );
                    },
                  ),
                ),
                if (!isDark) const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _errorCard(BuildContext context) => _stateCard(
        context,
        Icons.wifi_off,
        'Não foi possível carregar este feed.',
        TextButton(
          onPressed: () => controller.loadRegion(region, refresh: true),
          child: const Text('Tentar novamente'),
        ),
      );

  Widget _emptyCard(BuildContext context) => _stateCard(
        context,
        Icons.article_outlined,
        'Nenhuma notícia disponível nesta região.',
        const SizedBox.shrink(),
      );

  Widget _stateCard(
    BuildContext context,
    IconData icon,
    String text,
    Widget action,
  ) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: _accent),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
            action,
          ],
        ),
      );
}
