import 'package:flutter/widgets.dart';

import 'cart_controller.dart';

/// Provides the [CartController] to the widget tree.
///
/// [InheritedNotifier] rebuilds listening widgets whenever the cart changes,
/// which keeps the cart badge, cart page and totals in sync without a third
/// party state management package.
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Returns the nearest [CartController] and subscribes the caller to changes.
  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'No CartScope found above this widget.');
    return scope!.notifier!;
  }

  /// Returns the nearest [CartController] without subscribing the caller.
  ///
  /// Use this from callbacks, for example button handlers, so that an action
  /// does not mark an unrelated widget as needing a rebuild.
  static CartController read(BuildContext context) {
    final scope = context.getElementForInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'No CartScope found above this widget.');
    final widget = scope!.widget as CartScope;
    return widget.notifier!;
  }
}