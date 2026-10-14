import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/common.dart';
import '../widgets/product_cards.dart';

/// Home page from `home Page.png`.
///
/// Sections in design order: search header, "Find Your Outfit" hero,
/// "Scroll by Category" rail, "Trending" rail, "New Arrivals" rail and the
/// "More For You" grid.
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.repository,
    required this.onOpenSearch,
    required this.onOpenProduct,
    required this.onTryNow,
  });

  final ProductRepository repository;

  /// Switches to the Search tab.
  final VoidCallback onOpenSearch;

  /// Pushes Product Details.
  final ValueChanged<Product> onOpenProduct;

  /// The hero "Try Now" button, which leads to the out-of-scope try-on feature.
  final VoidCallback onTryNow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        key: const ValueKey<String>('home-scroll'),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _SearchHeader(onTap: onOpenSearch),
          ),
          SliverToBoxAdapter(
            child: _HeroBanner(onTryNow: onTryNow, onOpenSearch: onOpenSearch),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              'Scroll by Category',
              trailing: TextButton(
                onPressed: onOpenSearch,
                child: const Text('See all'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 232,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: repository.collections.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final collection = repository.collections[index];
                  final products = repository.byCollection(collection);

                  return _CategoryCard(
                    label: collection,
                    products: products,
                    onTap: onOpenSearch,
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SectionHeader('Trending')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 232,
              child: _ProductRail(
                products: repository.trending(),
                caption: true,
                onOpenProduct: onOpenProduct,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SectionHeader('New Arrivals')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 232,
              child: _ProductRail(
                products: repository.newArrivals(),
                caption: true,
                onOpenProduct: onOpenProduct,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SectionHeader('More For You')),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.66,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = repository.all[index % repository.all.length];
                  return ProductCard(
                    product: product,
                    onTap: () => onOpenProduct(product),
                  );
                },
                childCount: repository.all.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Semantics(
              button: true,
              label: 'Open search',
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(23),
                child: const _SearchFieldPreview(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.person_outline, color: AppColors.ink),
        ],
      ),
    );
  }
}

class _SearchFieldPreview extends StatelessWidget {
  const _SearchFieldPreview();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.fieldGrey,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Search',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.inkMuted,
                    ),
              ),
            ),
            const Icon(Icons.search, color: AppColors.inkMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onTryNow, required this.onOpenSearch});

  final VoidCallback onTryNow;
  final VoidCallback onOpenSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFEFE6D2), Color(0xFFDDD0B4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Find Your',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Outfit',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                PillButton(
                  label: 'Try Now',
                  onPressed: onTryNow,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 132,
            width: 110,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Color(0xFF6E7B8B), Color(0xFF39424F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.checkroom,
                      size: 52,
                      color: Colors.white24,
                    ),
                  ),
                  InkWell(
                    onTap: onOpenSearch,
                    child: const Center(child: SizedBox.shrink()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.label,
    required this.products,
    required this.onTap,
  });

  final String label;
  final List<Product> products;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = products.isEmpty
        ? const <Color>[AppColors.cardGrey, AppColors.divider]
        : products.first.placeholderColors;

    return SizedBox(
      width: 170,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  products.isEmpty
                      ? Icons.category_outlined
                      : products.first.placeholderIcon,
                  size: 44,
                  color: Colors.white24,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductRail extends StatelessWidget {
  const _ProductRail({
    required this.products,
    required this.onOpenProduct,
    required this.caption,
  });

  final List<Product> products;
  final ValueChanged<Product> onOpenProduct;
  final bool caption;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: EmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'Nothing here yet',
          message: 'Products will appear here once they are available.',
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductRailCard(
          product: product,
          caption: caption,
          onTap: () => onOpenProduct(product),
        );
      },
    );
  }
}