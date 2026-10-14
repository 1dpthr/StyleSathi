import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// Flat shipping fee shown in the cart summary, taken from the Figma design
/// (`your cart.png`: Sub Total 4000 pkr / Shipping 250 pkr).
const int kFlatShippingPkr = 250;

/// Shipping is not charged on an empty cart.
int shippingFor(int subtotalPkr, bool isEmpty) => isEmpty ? 0 : kFlatShippingPkr;

/// In-memory shopping cart.
///
/// Cart state is intentionally not persisted: the milestone decision is to keep
/// cart data in memory only, and persistence is an open question recorded in
/// `docs/05_CUSTOMER_BROWSE_CART_FLOW.md`.
///
/// **Tax is intentionally not modelled.** The designs show a `Tax +` row, but no
/// tax rule has been agreed, so no rate is invented here and the order total is
/// sub total plus shipping only.
class CartController extends ChangeNotifier {
  final List<CartItem> _items = <CartItem>[];

  /// Cart lines, in insertion order.
  List<CartItem> get items => List<CartItem>.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  /// Total number of units across all lines. Drives the cart badge.
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Number of distinct lines.
  int get lineCount => _items.length;

  /// Sum of `price * quantity` for every line.
  int get subtotalPkr =>
      _items.fold(0, (sum, item) => sum + item.lineTotalPkr);

  int get shippingPkr => shippingFor(subtotalPkr, isEmpty);

  /// Always `0` until a tax rule is agreed. See the class documentation.
  int get taxPkr => 0;

  /// Sub total plus shipping. Tax is deliberately excluded.
  int get orderTotalPkr => subtotalPkr + shippingPkr + taxPkr;

  /// Current quantity of a line, or `0` when the line is not in the cart.
  int quantityOf(String lineId) {
    final index = _indexOf(lineId);
    return index == -1 ? 0 : _items[index].quantity;
  }

  bool contains(String lineId) => _indexOf(lineId) != -1;

  /// `true` when any line with [productId] is in the cart, in any size or colour.
  bool containsProduct(String productId) =>
      _items.any((item) => item.product.id == productId);

  /// Adds [quantity] units of a product variant, or merges into the existing
  /// line when the same product, size and colour are already present.
  ///
  /// The quantity is capped by the available stock of [size]. Returns the number
  /// of units actually added, which is `0` when the line is already at the
  /// stock limit or the size is out of stock.
  int addItem({
    required Product product,
    required ProductOption size,
    required ProductColour colour,
    int quantity = 1,
  }) {
    if (quantity <= 0 || !size.isInStock) {
      return 0;
    }

    final lineId = CartItem.lineIdFor(
      productId: product.id,
      size: size.label,
      colour: colour.name,
    );
    final index = _indexOf(lineId);
    final currentQuantity = index == -1 ? 0 : _items[index].quantity;
    final allowed = size.stock - currentQuantity;
    final added = quantity <= allowed ? quantity : allowed;

    if (added <= 0) {
      return 0;
    }

    if (index == -1) {
      _items.add(
        CartItem(
          product: product,
          size: size,
          colour: colour,
          quantity: added,
        ),
      );
    } else {
      _items[index] = _items[index].copyWith(quantity: currentQuantity + added);
    }

    notifyListeners();
    return added;
  }

  /// Increases a line by one unit. Returns `false` when the line is missing or
  /// already at the stock limit.
  bool increment(String lineId) {
    final index = _indexOf(lineId);
    if (index == -1) {
      return false;
    }
    final item = _items[index];
    if (item.quantity >= item.size.stock) {
      return false;
    }
    _items[index] = item.copyWith(quantity: item.quantity + 1);
    notifyListeners();
    return true;
  }

  /// Decreases a line by one unit. Never drops below one unit, so removal is
  /// always an explicit action. Returns `false` when nothing changed.
  bool decrement(String lineId) {
    final index = _indexOf(lineId);
    if (index == -1 || _items[index].quantity <= 1) {
      return false;
    }
    _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
    notifyListeners();
    return true;
  }

  /// Removes a line entirely. Returns `false` when the line was not present.
  bool removeItem(String lineId) {
    final index = _indexOf(lineId);
    if (index == -1) {
      return false;
    }
    _items.removeAt(index);
    notifyListeners();
    return true;
  }

  /// Empties the cart.
  void clear() {
    if (_items.isEmpty) {
      return;
    }
    _items.clear();
    notifyListeners();
  }

  int _indexOf(String lineId) =>
      _items.indexWhere((item) => item.lineId == lineId);
}