import 'package:flutter/material.dart';

import '../data/region_style.dart';
import '../models/news.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    required this.regionName,
    required this.onTap,
    required this.isFavorite,
    required this.onFavorite,
    this.featured = false,
  });

  final News article;
  final String regionName;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF193A5B) : Colors.white;
    final accent = regionColor(regionName);

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featured) _heroImage(context, height: 154),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!featured) ...[
                    _thumbnail(context),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                regionName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints.tightFor(
                                width: 34,
                                height: 30,
                              ),
                              padding: EdgeInsets.zero,
                              tooltip: isFavorite
                                  ? 'Remover dos favoritos'
                                  : 'Salvar nos favoritos',
                              onPressed: onFavorite,
                              icon: Icon(
                                isFavorite
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 19,
                                color: isFavorite ? accent : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          article.title,
                          maxLines: featured ? 3 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: featured ? 18 : 14,
                            height: 1.28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (article.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            article.description,
                            maxLines: featured ? 3 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFFB9C9D9)
                                  : Colors.blueGrey.shade700,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                        if (article.publishedDate != null) ...[
                          const SizedBox(height: 7),
                          Text(
                            _formatDate(article.publishedDate!),
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black45,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnail(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 82,
          height: 88,
          child: _imageOrPlaceholder(context),
        ),
      );

  Widget _heroImage(BuildContext context, {required double height}) =>
      SizedBox(
        width: double.infinity,
        height: height,
        child: _imageOrPlaceholder(context),
      );

  Widget _imageOrPlaceholder(BuildContext context) {
    final imageUrl = article.imageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(context),
      );
    }
    return _placeholder(context);
  }

  Widget _placeholder(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B5E88), Color(0xFF102B46)],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.public,
            color: regionColor(regionName).withValues(alpha: 0.8),
            size: 34,
          ),
        ),
      );

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }
}
