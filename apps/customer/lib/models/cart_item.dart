import 'package:flutter/material.dart';

import 'product.dart';

/// A single line in the shopping cart.
///
/// Identity is `product + size + colour`, so the same product in a different
/// size becomes a separate line. This matches the behaviour expected by the
/// acceptance criteria in `docs/05_CUSTOMER_BROWSE_CART_FLOW.md`.
@immutable
class CartItem {
  const CartItem({
    required this.product,
    required this.size,
    required this.colour,
    required this.quantity,
  });

  final Product product;
  final ProductOption size;
  final ProductColour colour;
  final int quantity;

  /// Stable identifier for this line.
  String get lineId => CartItem.lineIdFor(
        productId: product.id,
        size: size.label,
        colour: colour.name,
      );

  /// `pricePkr * quantity`.
  int get lineTotalPkr => product.pricePkr * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        product: product,
        size: size,
        colour: colour,
        quantity: quantity ?? this.quantity,
      );

  /// Builds the composite key used to match cart lines.
  static String lineIdFor({
    required String productId,
    required String size,
    required String colour,
  }) =>
      '$productId|$size|$colour';
}