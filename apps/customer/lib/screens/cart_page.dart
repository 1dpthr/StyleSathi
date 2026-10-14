import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../state/cart_controller.dart';
import '../state/cart_scope.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../widgets/common.dart';

/// Checkout is out of scope for this milestone, so the summary button only
/// explains that it is unavailable rather than starting a payment flow.
void _showCheckoutUnavailable(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text('Checkout is not available yet')),
    );
}

/// Cart screen from `your cart.png`.
///
/// `your cart 2.png` is a byte-identical duplicate export of the same screen,
/// so this is the only cart route.
class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onBrowse});

  /// Sends the customer to the Search tab from the empty state.
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    // Rebuilds when the cart changes.
    final cart = CartScope.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Your Cart',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: cart.isEmpty
                ? EmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Your cart is empty',
                    message:
                        'Browse products and add the ones you like to see them here.',
                    action: PillButton(
                      label: 'Browse products',
                      onPressed: onBrowse,
                    ),
                  )
                : _CartContents(cart: cart),
          ),
        ],
      ),
    );
  }
}

class _CartContents extends StatelessWidget {
  const _CartContents({required this.cart});

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    final items = cart.items;

    return ListView(
      key: const ValueKey<String>('cart-scroll'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: <Widget>[
        for (final item in items) ...<Widget>[
          CartItemTile(
            item: item,
            onIncrement: () => cart.increment(item.lineId),
            onDecrement: () => cart.decrement(item.lineId),
            onRemove: () => cart.removeItem(item.lineId),
          ),
          const SizedBox(height: 12),
        ],
        _DescriptionSummary(cart: cart),
        const SizedBox(height: 20),
        CartSummary(
          subtotalPkr: cart.subtotalPkr,
          shippingPkr: cart.shippingPkr,
          orderTotalPkr: cart.orderTotalPkr,
          onCheckout: () => _showCheckoutUnavailable(context),
        ),
      ],
    );
  }
}

class _DescriptionSummary extends StatelessWidget {
  const _DescriptionSummary({required this.cart});

  final CartController cart;

  @override
  Widget build(BuildContext context) {
    // The design shows one description block for the cart contents, matching
    // the single-item layout of the reference.
    final descriptions = <String, String>{};
    for (final item in cart.items) {
      descriptions[item.product.id] = item.product.description;
    }

    final entries = descriptions.entries.toList();

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final entry in entries) ...<Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  entry.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}