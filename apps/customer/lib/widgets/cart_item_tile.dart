import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme/app_colors.dart';
import '../models/cart_item.dart';
import 'product_placeholder_image.dart';

/// A single cart line: thumbnail, name, selected options, price and the
/// quantity stepper.
///
/// The Figma cart design only shows a decrement control, but the milestone
/// acceptance criteria require both increasing and decreasing, so the stepper
/// here provides both.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final atStockLimit = item.quantity >= item.size.stock;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 92,
            width: 84,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ProductPlaceholderImage(
                colors: item.product.placeholderColors,
                icon: item.product.placeholderIcon,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: textTheme.titleSmall,
                      ),
                    ),
                    IconButton(
                      key: ValueKey<String>('remove-${item.lineId}'),
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppColors.inkMuted,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: 'Remove ${item.product.name}',
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Size ${item.size.label}  •  ${item.colour.name}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  formatPkr(item.product.pricePkr),
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _StepperButton(
                      icon: Icons.remove,
                      tooltip: 'Decrease quantity',
                      onPressed: item.quantity > 1 ? onDecrement : null,
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall,
                      ),
                    ),
                    _StepperButton(
                      key: ValueKey<String>('increment-${item.lineId}'),
                      icon: Icons.add,
                      tooltip: 'Increase quantity',
                      onPressed: atStockLimit ? null : onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Material(
        color: AppColors.background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          color: AppColors.ink,
          disabledColor: AppColors.inkMuted.withValues(alpha: 0.4),
          tooltip: tooltip,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );
  }
}