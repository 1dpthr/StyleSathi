import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../state/search_controller.dart';
import '../widgets/common.dart';
import '../widgets/filter_chip_row.dart';
import '../widgets/product_cards.dart';

/// Search screen from `search.png`: a search field, gold filter chips and a
/// product grid.
///
/// Filter chips toggle on and off; selecting several chips matches any of them.
class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    required this.repository,
    required this.controller,
    required this.onOpenProduct,
  });

  final ProductRepository repository;
  final ProductSearchController controller;
  final ValueChanged<Product> onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: _SearchField(controller: controller),
          ),
          FilterChipRow(
            categories: repository.categories,
            isSelected: controller.isSelected,
            onToggle: controller.toggleCategory,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final results = repository.searchWithFilters(
                  controller.query,
                  controller.selectedCategories,
                );

                if (results.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off_outlined,
                    title: 'No products found',
                    message: controller.isFiltered
                        ? 'Try a different search or clear your filters.'
                        : 'No products are available right now.',
                    action: controller.isFiltered
                        ? PillButton(
                            label: 'Clear filters',
                            filled: false,
                            onPressed: controller.reset,
                          )
                        : null,
                  );
                }

                return GridView.builder(
                  key: const ValueKey<String>('search-grid'),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return ProductCard(
                      product: product,
                      showDetailsPill: false,
                      onTap: () => onOpenProduct(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final ProductSearchController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const ValueKey<String>('search-field'),
      textInputAction: TextInputAction.search,
      onChanged: controller.updateQuery,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search, color: AppColors.inkMuted),
        suffixIcon: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => controller.query.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close),
                  onPressed: controller.clearQuery,
                ),
        ),
      ),
    );
  }
}