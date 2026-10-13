import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../data/regions.dart';
import '../models/news.dart';
import '../models/region_feed.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/news_card.dart';
import '../widgets/region_card.dart';
import 'favorites_screen.dart';
import 'news_detail_screen.dart';
import 'region_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import '../widgets/world_map_painter.dart';

const _accent = Color(0xFFFF6538);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.loadRegion(widget.controller.selectedRegion);
  }

  void _selectTab(int index) {
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _MapHomePage(
        controller: widget.controller,
        onOpenArticle: _openArticle,
        onOpenRegion: _openRegion,
        onSearch: () => _selectTab(1),
      ),
      SearchScreen(controller: widget.controller, onOpenArticle: _openArticle),
      FavoritesScreen(
        controller: widget.controller,
        onOpenArticle: _openArticle,
      ),
      SettingsScreen(controller: widget.controller),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedTab, children: pages),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedTab,
        onSelected: _selectTab,
      ),
    );
  }

  void _openArticle(News article) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailScreen(
          controller: widget.controller,
          article: article,
        ),
      ),
    );
  }

  void _openRegion(RegionFeed region) {
    widget.controller.selectRegion(region);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RegionScreen(
          controller: widget.controller,
          region: region,
          onTabSelected: (index) {
            Navigator.of(context).pop();
            _selectTab(index);
          },
          onOpenArticle: _openArticle,
          onOpenRegion: _openRegion,
        ),
      ),
    );
  }
}

class _MapHomePage extends StatelessWidget {
  const _MapHomePage({
    required this.controller,
    required this.onOpenArticle,
    required this.onOpenRegion,
    required this.onSearch,
  });

  final AppController controller;
  final ValueChanged<News> onOpenArticle;
  final ValueChanged<RegionFeed> onOpenRegion;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final region = controller.selectedRegion;
        final articles = controller.newsFor(region);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return SafeArea(
          child: RefreshIndicator(
            color: _accent,
            onRefresh: () => controller.loadRegion(region, refresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
              children: [
                _header(context, isDark),
                const SizedBox(height: 15),
                _map(context, region),
                const SizedBox(height: 12),
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
                        onTap: () => controller.selectRegion(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${region.name.toUpperCase()} · EM DESTAQUE',
                        style: const TextStyle(
                          color: _accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => onOpenRegion(region),
                      child: const Text('Ver região'),
                    ),
                  ],
                ),
                _articleContent(context, region, articles, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, bool isDark) => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'EXPLORE AO VIVO',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'World News Map',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF10243A),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                Text(
                  'Explore notícias pelo mundo',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF9FB5CC) : Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Buscar notícias',
              onPressed: onSearch,
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      );

  Widget _map(BuildContext context, RegionFeed selectedRegion) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 212,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF0A1E31), Color(0xFF102F53), Color(0xFF173D69)]
              : const [Color(0xFFE1EDF7), Color(0xFFCADDF0), Color(0xFFB8D1E8)],
        ),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black12,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: GradeMapaPainter())),
          Positioned.fill(
            child: WorldMapPainter(
              regiaoSelecionada: selectedRegion.name,
              aoSelecionar: (name) {
                final matches = regions.where((region) => region.name == name);
                if (matches.isNotEmpty) controller.selectRegion(matches.first);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _articleContent(
    BuildContext context,
    RegionFeed region,
    List<News> articles,
    bool isDark,
  ) {
    if (controller.isLoading(region) && articles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 44),
        child: Center(child: CircularProgressIndicator(color: _accent)),
      );
    }

    final error = controller.errorFor(region);
    if (error != null && articles.isEmpty) {
      return _messageCard(
        context,
        icon: Icons.wifi_off,
        title: 'Não foi possível carregar as notícias',
        message: 'Verifique sua conexão e tente novamente.',
        action: FilledButton(
          onPressed: () => controller.loadRegion(region, refresh: true),
          child: const Text('Tentar novamente'),
        ),
      );
    }

    if (articles.isEmpty) {
      return _messageCard(
        context,
        icon: Icons.article_outlined,
        title: 'Nenhuma notícia encontrada',
        message: 'Tente atualizar o feed em alguns instantes.',
        action: TextButton(
          onPressed: () => controller.loadRegion(region, refresh: true),
          child: const Text('Atualizar'),
        ),
      );
    }

    final featured = articles.first;
    return Column(
      children: [
        NewsCard(
          article: featured,
          regionName: region.name,
          featured: true,
          isFavorite: controller.isFavorite(featured),
          onFavorite: () => controller.toggleFavorite(featured),
          onTap: () => onOpenArticle(featured),
        ),
        const SizedBox(height: 10),
        for (final article in articles.skip(1).take(8)) ...[
          NewsCard(
            article: article,
            regionName: region.name,
            isFavorite: controller.isFavorite(article),
            onFavorite: () => controller.toggleFavorite(article),
            onTap: () => onOpenArticle(article),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _messageCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required Widget action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF193A5B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: _accent, size: 28),
          const SizedBox(height: 9),
          Text(title, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          action,
        ],
      ),
    );
  }
}
