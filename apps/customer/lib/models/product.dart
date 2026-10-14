import 'package:flutter/material.dart';

/// A selectable product option, such as a size.
///
/// [stock] doubles as the per-line availability limit. A product whose sizes all
/// have a stock of `0` cannot be added to the cart.
class ProductOption {
  const ProductOption({required this.label, this.stock = 0});

  /// Display label, for example `M` or `8`.
  final String label;

  /// Number of units available for this option.
  final int stock;

  bool get isInStock => stock > 0;

  /// Highlights options that are nearly sold out.
  bool get isLowStock => isInStock && stock <= 3;
}

/// A selectable product colour.
class ProductColour {
  const ProductColour({required this.name, required this.value});

  /// Display label, for example `Blue`.
  final String name;

  /// ARGB value of the swatch shown in the designs.
  final int value;

  Color get color => Color(value);
}

/// A product shown in the customer app.
///
/// Product imagery is intentionally not modelled as real photography: the
/// supplied Figma files are flattened screen exports, not usable product
/// assets. [placeholderColors] and [placeholderIcon] drive a generated
/// placeholder instead (see `ProductPlaceholderImage`).
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.collection,
    required this.pricePkr,
    required this.sizes,
    required this.colours,
    required this.placeholderColors,
    this.placeholderIcon = Icons.checkroom_outlined,
    this.rating = 0,
    this.reviewCount = 0,
    this.isTrending = false,
    this.isNewArrival = false,
  });

  final String id;
  final String name;

  /// Secondary line shown under [name] (brand line in the designs).
  final String subtitle;

  final String description;

  /// Drives the Search screen filter chips (Shoes, Watch, Pants, ...).
  final String category;

  /// Drives the Home screen "Scroll by Category" rail
  /// (Casual, Formals, Traditional).
  final String collection;

  /// Unit price in Pakistani Rupees.
  final int pricePkr;

  final List<ProductOption> sizes;
  final List<ProductColour> colours;

  /// Colours used to build the generated placeholder image.
  final List<Color> placeholderColors;
  final IconData placeholderIcon;

  final double rating;
  final int reviewCount;
  final bool isTrending;
  final bool isNewArrival;

  /// `true` when this product can be added to the cart in any size.
  bool get isPurchasable => sizes.any((size) => size.isInStock);

  bool matchesQuery(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return true;
    }
    return name.toLowerCase().contains(needle) ||
        subtitle.toLowerCase().contains(needle) ||
        category.toLowerCase().contains(needle) ||
        collection.toLowerCase().contains(needle);
  }

  bool matchesCategory(String value) =>
      category.toLowerCase() == value.toLowerCase();
}