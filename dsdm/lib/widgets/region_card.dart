import 'package:flutter/material.dart';

import '../data/region_style.dart';
import '../models/region_feed.dart';

class RegionCard extends StatelessWidget {
  const RegionCard({
    super.key,
    required this.region,
    required this.selected,
    required this.onTap,
    this.reduceMotion = false,
  });

  final RegionFeed region;
  final bool selected;
  final VoidCallback onTap;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final color = regionColor(region.name);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? color
              : (isDark ? const Color(0xFF193A5B) : Colors.white),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          region.name,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
