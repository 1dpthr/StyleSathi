import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/product.dart';
import 'product_placeholder_image.dart';

/// Full-width product card used by the Home "More For You" grid and the Search
/// results grid.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.showDetailsPill = true,
  });

  final Product product;
  final VoidCallback onTap;

  /// Shows the gold "Details" pill seen on the Home page grid.
  final bool showDetailsPill;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ProductPlaceholderImage(
                    colors: product.placeholderColors,
                    icon: product.placeholderIcon,
                  ),
                  if (showDetailsPill)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Details',
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontFamilyFallback: AppTheme.fontFamilyFallback,
                              color: AppColors.ink,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall,
          ),
          const SizedBox(height: 2),
          Text(
            formatPkr(product.pricePkr),
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.goldDark,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact product card used by the horizontal Home rails such as
/// "Scroll by Category" and "Trending".
class ProductRailCard extends StatelessWidget {
  const ProductRailCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width = 150,
    this.caption = false,
  });

  final Product product;
  final VoidCallback onTap;
  final double width;

  /// Draws the product name over the image instead of underneath it.
  final bool caption;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ProductPlaceholderImage(
        colors: product.placeholderColors,
        icon: product.placeholderIcon,
        label: caption ? product.name : null,
      ),
    );

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: image),
            if (!caption) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                formatPkr(product.pricePkr),
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.goldDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}