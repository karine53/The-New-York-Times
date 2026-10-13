import 'package:flutter/material.dart';

const _accent = Color(0xFFFF6538);

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.public_outlined, 'Mapa'),
    (Icons.search, 'Busca'),
    (Icons.bookmark_border, 'Favoritos'),
    (Icons.settings_outlined, 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF08192A) : Colors.white,
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: Row(
          children: List.generate(_items.length, (index) {
            final selected = selectedIndex == index;
            final (icon, label) = _items[index];
            final color = selected
                ? _accent
                : (isDark ? Colors.blueGrey.shade300 : Colors.blueGrey.shade600);
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: label,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color, size: 21),
                        const SizedBox(height: 3),
                        Text(label, style: TextStyle(color: color, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
