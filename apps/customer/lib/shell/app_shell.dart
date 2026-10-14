import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../screens/cart_page.dart';
import '../screens/home_page.dart';
import '../screens/product_details_page.dart';
import '../screens/search_page.dart';
import '../state/search_controller.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/common.dart';

/// Root shell holding the five bottom navigation destinations.
///
/// Product Details is pushed on top of this shell with [Navigator.push], so
/// returning from it restores the previously selected tab.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ProductSearchController _searchController =
      ProductSearchController();
  AppDestination _current = AppDestination.home;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectDestination(AppDestination destination) {
    if (_current == destination) {
      return;
    }
    setState(() => _current = destination);
  }

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsPage(product: product),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature is coming soon')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's scroll position and text input alive
      // while switching, matching the behaviour of the reference designs.
      body: IndexedStack(
        index: _current.index,
        children: <Widget>[
          HomePage(
            repository: widget.repository,
            onOpenSearch: () =>
                _selectDestination(AppDestination.search),
            onOpenProduct: _openProduct,
            onTryNow: () => _showComingSoon('Try-on'),
          ),
          SearchPage(
            repository: widget.repository,
            controller: _searchController,
            onOpenProduct: _openProduct,
          ),
          _PlaceholderDestination(
            title: 'Camera',
            message:
                'Virtual try-on is being planned and is not available yet.',
            icon: Icons.photo_camera_outlined,
          ),
          CartPage(
            onBrowse: () => _selectDestination(AppDestination.search),
          ),
          _PlaceholderDestination(
            title: 'Your Account',
            message:
                'Account features such as profile, addresses and orders are not '
                'available yet.',
            icon: Icons.person_outline,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        current: _current,
        onSelect: _selectDestination,
      ),
    );
  }
}

/// Inert placeholder for destinations that are out of scope for this
/// milestone: Camera (virtual try-on) and Person (account management).
class _PlaceholderDestination extends StatelessWidget {
  const _PlaceholderDestination({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: EmptyState(
              icon: icon,
              title: 'Coming soon',
              message: message,
            ),
          ),
        ],
      ),
    );
  }
}