import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

/// Row of gold filter chips from the Search design.
///
/// Chips toggle on and off. Selecting several chips matches any of them; the
/// clearing behaviour is owned by the caller.
class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.categories,
    required this.isSelected,
    required this.onToggle,
  });

  final List<String> categories;
  final bool Function(String category) isSelected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = isSelected(category);

          return Center(
            child: Material(
              color: selected ? AppColors.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onToggle(category),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        category,
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontFamilyFallback: AppTheme.fontFamilyFallback,
                          fontSize: 13,
                          color: AppColors.ink,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                      if (selected) ...<Widget>[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.close,
                          size: 14,
                          color: AppColors.ink,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}