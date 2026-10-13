import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../data/regions.dart';
import '../models/news.dart';
import '../models/region_feed.dart';
import '../widgets/news_card.dart';

const _accent = Color(0xFFFF6538);

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.controller,
    required this.onOpenArticle,
  });

  final AppController controller;
  final ValueChanged<News> onOpenArticle;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryController = TextEditingController();
  String _query = '';
  RegionFeed? _region;

  @override
  void initState() {
    super.initState();
    widget.controller.loadAllNews();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final articles = _region == null
              ? widget.controller.allNews
              : widget.controller.newsFor(_region!);
          final normalized = _query.trim().toLowerCase();
          final results = articles.where((article) {
            if (normalized.isEmpty) return true;
            return article.title.toLowerCase().contains(normalized) ||
                article.description.toLowerCase().contains(normalized);
          }).toList(growable: false);
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            children: [
              Text(
                'Pesquisar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _queryController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Buscar notícias pelo mundo',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Limpar busca',
                          onPressed: () {
                            _queryController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF193A5B) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _filterChip('Todas', _region == null, () {
                      setState(() => _region = null);
                    }),
                    for (final region in regions)
                      _filterChip(region.name, _region?.name == region.name, () {
                        setState(() => _region = region);
                        widget.controller.loadRegion(region);
                      }),
                  ],
                ),
              ),
              const SizedBox(height: 19),
              Text(
                _query.isEmpty ? 'Últimas notícias' : 'Resultados da busca',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 10),
              if (_region != null &&
                  widget.controller.isLoading(_region!) &&
                  articles.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(36),
                  child: Center(child: CircularProgressIndicator(color: _accent)),
                )
              else if (results.isEmpty)
                _emptyResults(context)
              else
                for (final article in results.take(30)) ...[
                  NewsCard(
                    article: article,
                    regionName: article.regionName,
                    isFavorite: widget.controller.isFavorite(article),
                    onFavorite: () => widget.controller.toggleFavorite(article),
                    onTap: () => widget.onOpenArticle(article),
                  ),
                  const SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: 7),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          selectedColor: _accent,
          labelStyle: TextStyle(
            color: selected ? Colors.white : null,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
          ),
          visualDensity: VisualDensity.compact,
          side: BorderSide.none,
          showCheckmark: false,
        ),
      );

  Widget _emptyResults(BuildContext context) {
    final loading = _region == null
        ? regions.any(widget.controller.isLoading)
        : widget.controller.isLoading(_region!);
    final error = _region == null
        ? regions.every((region) => widget.controller.errorFor(region) != null)
        : widget.controller.errorFor(_region!) != null;

    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(36),
        child: Center(child: CircularProgressIndicator(color: _accent)),
      );
    }
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(error ? Icons.wifi_off : Icons.search_off, color: _accent, size: 30),
          const SizedBox(height: 10),
          Text(
            error
                ? 'Não foi possível carregar as notícias.'
                : _query.isEmpty
                    ? 'Nenhuma notícia disponível nesta região.'
                    : 'Não encontramos notícias com esse termo.',
            textAlign: TextAlign.center,
          ),
          if (error) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _region == null
                  ? widget.controller.loadAllNews
                  : () => widget.controller.loadRegion(_region!, refresh: true),
              child: const Text('Tentar novamente'),
            ),
          ],
        ],
      ),
    );
  }
}
