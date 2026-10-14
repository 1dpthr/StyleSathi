import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme/app_colors.dart';
import '../models/product.dart';
import '../state/cart_scope.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/product_placeholder_image.dart';

/// Product Details, pushed on top of the bottom navigation tab shell.
///
/// Follows `Product details.png`: large image with page dots, name, gold price,
/// colour swatch, size selector, Add Cart plus the out-of-scope Try Now button,
/// then description and reviews.
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductOption? _selectedSize;
  ProductColour? _selectedColour;
  int _imageIndex = 0;

  /// The designs show four carousel dots, but only one product image exists per
  /// product in this milestone, so a single frame is rendered rather than
  /// fabricating additional ones.
  static const int _imageCount = 1;

  @override
  void initState() {
    super.initState();
    // Pre-select when the design shows a single colour, matching the
    // "Color: Blue" row which offers no alternative to choose.
    _selectedColour =
        widget.product.colours.length == 1 ? widget.product.colours.first : null;
  }

  void _selectSize(ProductOption size) {
    if (!size.isInStock) {
      return;
    }
    setState(() => _selectedSize = size);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleAddToCart() {
    final size = _selectedSize;
    final colour = _selectedColour ?? widget.product.colours.first;

    if (size == null) {
      _showMessage('Please select a size first');
      return;
    }

    final added = CartScope.read(context).addItem(
      product: widget.product,
      size: size,
      colour: colour,
    );

    if (added == 0) {
      _showMessage('This option is out of stock');
      return;
    }

    // Confirms the action and updates the badge without navigating away.
    showAddedToCartConfirmation(context, quantity: added);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey<String>('details-scroll'),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: <Widget>[
            _ImageCarousel(
              product: product,
              index: _imageIndex,
              count: _imageCount,
              onChanged: (value) => setState(() => _imageIndex = value),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(product.name, style: textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    formatPkr(product.pricePkr),
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.goldDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ColourSelector(
                    colours: product.colours,
                    selected: _selectedColour,
                    onSelected: (colour) =>
                        setState(() => _selectedColour = colour),
                  ),
                  const SizedBox(height: 18),
                  _SizeSelector(
                    sizes: product.sizes,
                    selected: _selectedSize,
                    onSelected: _selectSize,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handleAddToCart,
                          child: const Text('Add Cart'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              _showMessage('Try-on is coming soon'),
                          icon:
                              const Icon(Icons.photo_camera_outlined, size: 18),
                          label: const Text('Try Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoBlock(title: 'Product details', body: product.description),
            const SizedBox(height: 16),
            _InfoBlock(
              title: 'Customer Reviews',
              body: product.reviewCount == 0
                  ? 'No reviews yet.'
                  : '${product.reviewCount} review'
                      '${product.reviewCount == 1 ? '' : 's'} for this product.',
              trailing: product.reviewCount == 0
                  ? null
                  : _StarRating(rating: product.rating),
            ),
          ],
        ),
      ),
    );
  }
}
class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({
    required this.product,
    required this.index,
    required this.count,
    required this.onChanged,
  });

  final Product product;
  final int index;
  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              itemCount: count,
              onPageChanged: onChanged,
              itemBuilder: (context, pageIndex) => ProductPlaceholderImage(
                colors: product.placeholderColors,
                icon: product.placeholderIcon,
                iconScale: 0.8,
              ),
            ),
          ),
        ),
        if (count > 1) ...<Widget>[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (var i = 0; i < count; i++)
                Container(
                  width: i == index ? 22 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.gold : AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ColourSelector extends StatelessWidget {
  const _ColourSelector({
    required this.colours,
    required this.selected,
    required this.onSelected,
  });

  final List<ProductColour> colours;
  final ProductColour? selected;
  final ValueChanged<ProductColour> onSelected;

  @override
  Widget build(BuildContext context) {
    if (colours.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Color: ${selected?.name ?? colours.first.name}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (selected != null) ...<Widget>[
              const SizedBox(width: 8),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: selected!.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        if (colours.length > 1) ...<Widget>[
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: <Widget>[
              for (final colour in colours)
                _SwatchButton(
                  colour: colour,
                  isSelected: selected?.name == colour.name,
                  onTap: () => onSelected(colour),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
class _SwatchButton extends StatelessWidget {
  const _SwatchButton({
    required this.colour,
    required this.isSelected,
    required this.onTap,
  });

  final ProductColour colour;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: colour.name,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: colour.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.ink : AppColors.divider,
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  final List<ProductOption> sizes;
  final ProductOption? selected;
  final ValueChanged<ProductOption> onSelected;

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Size', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            for (final size in sizes)
              _SizeButton(
                option: size,
                isSelected: selected?.label == size.label,
                onTap: () => onSelected(size),
              ),
          ],
        ),
      ],
    );
  }
}

class _SizeButton extends StatelessWidget {
  const _SizeButton({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ProductOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = option.isInStock;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: enabled,
      label: 'Size ${option.label}',
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.35,
          child: Container(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.gold : AppColors.outline,
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  option.label,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.ink),
                ),
                if (option.isLowStock)
                  Text(
                    '${option.stock} left',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 9),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.title,
    required this.body,
    this.trailing,
  });

  final String title;
  final String body;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(title, style: textTheme.titleMedium)),
              ?trailing,
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Rated ${rating.toStringAsFixed(1)} out of 5',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 1; i <= 5; i++)
            Icon(
              i <= rating.round() ? Icons.star : Icons.star_border,
              size: 18,
              color: AppColors.gold,
            ),
        ],
      ),
    );
  }
}