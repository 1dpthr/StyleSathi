import 'package:flutter/material.dart';

import '../core/formatters.dart';
import '../core/theme/app_colors.dart';

/// Cart totals block from the Figma `your cart.png` design.
///
/// The design shows a `Tax +` row, but no tax rule has been agreed, so tax is
/// deliberately not calculated and the order total is sub total plus shipping.
class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.subtotalPkr,
    required this.shippingPkr,
    required this.orderTotalPkr,
    required this.onCheckout,
  });

  final int subtotalPkr;
  final int shippingPkr;
  final int orderTotalPkr;

  /// Checkout is out of scope for this milestone, so the button stays disabled
  /// while still matching the approved design.
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.cardGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text('Summary', style: textTheme.titleMedium),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Sub Total', value: formatPkr(subtotalPkr)),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Shipping', value: formatPkr(shippingPkr)),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Tax',
            value: 'Not available',
            muted: true,
            trailing: const Icon(
              Icons.info_outline,
              size: 16,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.ink),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Order Total',
                  style: textTheme.titleMedium,
                ),
              ),
              Text(
                formatPkr(orderTotalPkr),
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.goldDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onCheckout,
            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
            label: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.muted = false,
    this.trailing,
  });

  final String label;
  final String value;
  final bool muted;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = muted ? AppColors.inkMuted : AppColors.ink;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(label, style: textTheme.titleMedium?.copyWith(color: color)),
        ),
        if (trailing != null) ...<Widget>[
          trailing!,
          const SizedBox(width: 6),
        ],
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: muted ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}