import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../state/cart_scope.dart';

/// The five bottom navigation destinations from the Figma designs:
/// Home, Search, Camera, Cart, Person.
///
/// Camera and Person are intentionally inert placeholders in this milestone:
/// virtual try-on and account management are out of scope
/// (see `docs/05_CUSTOMER_BROWSE_CART_FLOW.md`).
enum AppDestination { home, search, camera, cart, person }

/// Bottom navigation bar with a live cart badge.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final AppDestination current;
  final ValueChanged<AppDestination> onSelect;

  @override
  Widget build(BuildContext context) {
    // Subscribes this widget to cart changes so the badge count stays correct.
    final cart = CartScope.of(context);
    final badgeCount = cart.totalQuantity;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: NavigationBar(
        height: 66,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        elevation: 0,
        selectedIndex: current.index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) =>
            onSelect(AppDestination.values[index]),
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          const NavigationDestination(
            icon: Icon(Icons.photo_camera_outlined),
            selectedIcon: Icon(Icons.photo_camera),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: _CartIcon(
              selected: current == AppDestination.cart,
              badgeCount: badgeCount,
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
      ),
    );
  }
}

class _CartIcon extends StatelessWidget {
  const _CartIcon({required this.selected, required this.badgeCount});

  final bool selected;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Icon(
          selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
        ),
        if (badgeCount > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints: const BoxConstraints(minWidth: 16),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.background, width: 1.2),
              ),
              child: Text(
                badgeCount > 99 ? '99+' : '$badgeCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Confirmation shown after a successful add-to-cart.
///
/// The milestone decision is that adding to the cart confirms the action and
/// updates the badge without navigating away from Product Details.
void showAddedToCartConfirmation(BuildContext context, {required int quantity}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        quantity > 1
            ? '$quantity units added to your cart'
            : 'Added to your cart',
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}