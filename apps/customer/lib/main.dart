import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/product_repository.dart';
import 'shell/app_shell.dart';
import 'state/cart_controller.dart';
import 'state/cart_scope.dart';

void main() {
  runApp(const StyleSathiApp());
}

/// Customer application root.
///
/// This milestone delivers the Browse-to-Cart flow with local mock data and an
/// in-memory cart. Firebase, checkout, orders, wishlist and try-on are out of
/// scope, see `docs/05_CUSTOMER_BROWSE_CART_FLOW.md`.
class StyleSathiApp extends StatefulWidget {
  const StyleSathiApp({super.key, this.repository});

  /// Injectable so tests can supply a controlled catalogue.
  final ProductRepository? repository;

  @override
  State<StyleSathiApp> createState() => _StyleSathiAppState();
}

class _StyleSathiAppState extends State<StyleSathiApp> {
  final CartController _cartController = CartController();
  late final ProductRepository _repository =
      widget.repository ?? ProductRepository();

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: _cartController,
      child: MaterialApp(
        title: 'Style Sathi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: AppShell(repository: _repository),
      ),
    );
  }
}
