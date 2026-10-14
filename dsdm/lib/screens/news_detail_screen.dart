import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_controller.dart';
import '../data/regions.dart';
import '../data/region_style.dart';
import '../models/news.dart';
import '../models/region_feed.dart';
import '../widgets/news_card.dart';

const _accent = Color(0xFFFF6538);

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({
    super.key,
    required this.controller,
    required this.article,
  });

  final AppController controller;
  final News article;

  @override
  Widget build(BuildContext context) {
    final regionName = article.regionName;
    final related = controller
        .newsFor(controller.selectedRegion.name == regionName
            ? controller.selectedRegion
            : _regionForName(regionName))
        .where((item) => item.guid != article.guid)
        .take(3)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 290,
                    width: double.infinity,
                    child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                        ? Image.network(
                            article.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _heroPlaceholder(),
                          )
                        : _heroPlaceholder(),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withValues(alpha: 0.25), Colors.transparent],
                          stops: const [0, 0.45],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _roundButton(
                      context,
                      icon: Icons.arrow_back_ios_new,
                      tooltip: 'Voltar',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Row(
                      children: [
                        _roundButton(
                          context,
                          icon: Icons.ios_share,
                          tooltip: 'Copiar link',
                          onPressed: () => _copyLink(context),
                        ),
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) => _roundButton(
                            context,
                            icon: controller.isFavorite(article)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            tooltip: controller.isFavorite(article)
                                ? 'Remover dos favoritos'
                                : 'Salvar nos favoritos',
                            onPressed: () => controller.toggleFavorite(article),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              sliver: SliverList.list(
                children: [
                  Text(
                    '${regionName.toUpperCase()} · INTERNACIONAL',
                    style: TextStyle(
                      color: regionColor(regionName),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          height: 1.16,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  if (article.publishedDate != null) ...[
                    const SizedBox(height: 11),
                    Text(
                      _formatDate(article.publishedDate!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    article.description.isEmpty
                        ? 'Leia a reportagem completa no site do The New York Times.'
                        : article.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.65,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.82),
                        ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: () => _openArticle(context),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Abrir reportagem no NYT'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (related.isNotEmpty) ...[
                    Text(
                      'MAIS DE ${regionName.toUpperCase()}',
                      style: const TextStyle(
                        color: _accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final item in related) ...[
                      NewsCard(
                        article: item,
                        regionName: regionName,
                        isFavorite: controller.isFavorite(item),
                        onFavorite: () => controller.toggleFavorite(item),
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => NewsDetailScreen(
                              controller: controller,
                              article: item,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  RegionFeed _regionForName(String name) => regions.firstWhere(
        (region) => region.name == name,
        orElse: () => regions.last,
      );

  Widget _heroPlaceholder() => const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF285C86), Color(0xFF071B2D)],
          ),
        ),
        child: Center(
          child: Icon(Icons.public, size: 56, color: Colors.white54),
        ),
      );

  Widget _roundButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) =>
      Material(
        color: Colors.black.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          color: Colors.white,
          icon: Icon(icon, size: 19),
        ),
      );

  Future<void> _openArticle(BuildContext context) async {
    final uri = Uri.tryParse(article.url);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      _showMessage(context, 'O link desta reportagem não está disponível.');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showMessage(context, 'Não foi possível abrir a reportagem.');
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    if (article.url.isEmpty) {
      _showMessage(context, 'O link desta reportagem não está disponível.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: article.url));
    if (context.mounted) _showMessage(context, 'Link copiado.');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return 'Publicado em $day/$month/${local.year}';
  }
}
