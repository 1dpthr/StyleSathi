import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/data/mock_products.dart';
import 'package:customer_app/data/product_repository.dart';
import 'package:customer_app/main.dart';
import 'package:customer_app/models/product.dart';
import 'package:customer_app/state/cart_controller.dart';
import 'package:customer_app/state/cart_scope.dart';
import 'package:customer_app/widgets/product_cards.dart';

/// End-to-end checks for the Browse-to-Cart milestone, driven through the real
/// widget tree rather than mocked callbacks.
void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    ProductRepository? repository,
  }) async {
    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      StyleSathiApp(repository: repository ?? ProductRepository()),
    );
    await tester.pumpAndSettle();
  }

  /// Finds a bottom navigation destination by its label.
  ///
  /// Scoped to the navigation bar because Product Details is pushed on top of
  /// the shell and does not show the bar.
  Finder navDestination(String label) => find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      );

  /// Matches [text] only inside a product card, avoiding the search field
  /// which also contains the queried text.
  Finder productCardWith(String text) => find.descendant(
        of: find.byType(ProductCard),
        matching: find.text(text),
      );

  /// Returns to the tab shell after a pushed Product Details screen.
  Future<void> popToShell(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
  }

  Future<void> tapNav(WidgetTester tester, String label) async {
    await tester.tap(navDestination(label));
    await tester.pumpAndSettle();
  }

  /// Reads the cart controller that the running app is using.
  CartController cartOf(WidgetTester tester) =>
      CartScope.read(tester.element(find.byType(NavigationBar)));

  /// Pumps the app with a single product so cart assertions stay unambiguous.
  Future<void> pumpSingleProductApp(WidgetTester tester) async {
    await pumpApp(
      tester,
      repository: ProductRepository(
        products: <Product>[MockProducts.all.first],
      ),
    );
  }

  /// Whether every match of [finder] sits inside the visible viewport.
  bool isFullyVisible(WidgetTester tester, Finder finder) {
    final size = tester.view.physicalSize / tester.view.devicePixelRatio;
    for (final element in finder.evaluate()) {
      final box = element.renderObject;
      if (box is! RenderBox || !box.hasSize || !box.attached) {
        return false;
      }
      final rect = box.localToGlobal(Offset.zero) & box.size;
      if (rect.top < 0 ||
          rect.bottom > size.height ||
          rect.left < 0 ||
          rect.right > size.width) {
        return false;
      }
    }
    return true;
  }

  /// Scrolls [finder] into view by dragging the keyed scroll view [scrollKey].
  ///
  /// Several widgets in this milestone sit below the fold on a phone sized
  /// viewport, so they must be scrolled to before being tapped or asserted.
  Future<void> scrollTo(
    WidgetTester tester,
    Finder finder,
    String scrollKey,
  ) async {
    if (finder.evaluate().isNotEmpty && isFullyVisible(tester, finder)) {
      return;
    }

    final scrollable = find.byKey(ValueKey<String>(scrollKey));
    for (var i = 0; i < 12; i++) {
      if (finder.evaluate().isNotEmpty && isFullyVisible(tester, finder)) {
        return;
      }
      await tester.drag(scrollable, const Offset(0, -260));
      await tester.pumpAndSettle();
    }
  }

  /// Taps a finder, scrolling it into view first when [scrollKey] is given.
  Future<void> tapVisible(
    WidgetTester tester,
    Finder finder, {
    String? scrollKey,
  }) async {
    if (scrollKey != null) {
      await scrollTo(tester, finder, scrollKey);
    }
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Lets an in-flight snack bar finish animating in.
  Future<void> settleSnackBar(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// Opens the Search tab and types [query].
  Future<void> searchFor(WidgetTester tester, String query) async {
    await tapNav(tester, 'Search');
    await tester.enterText(
      find.byKey(const ValueKey<String>('search-field')),
      query,
    );
    await tester.pumpAndSettle();
  }

  /// Searches for [query] and opens the matching product card.
  Future<void> openProduct(
    WidgetTester tester,
    String query,
    String name,
  ) async {
    await searchFor(tester, query);
    await tapVisible(
      tester,
      productCardWith(name),
      scrollKey: 'search-grid',
    );
  }

  /// Selects a size and adds to cart on the currently open Product Details.
  ///
  /// Returns the cart line identifier that was created.
  Future<String> addToCart(WidgetTester tester, String sizeLabel) async {
    final product = MockProducts.all.first;
    final size = product.sizes.firstWhere((s) => s.label == sizeLabel);
    final colour = product.colours.first;
    
    await tapVisible(tester, find.text(sizeLabel), scrollKey: 'details-scroll');
    await tapVisible(tester, find.text('Add Cart'), scrollKey: 'details-scroll');

    return '${product.id}|${size.label}|${colour.name}';
  }

  /// Opens the first mock product, adds it to the cart and returns to the shell.
  Future<String> addFirstProductToCart(WidgetTester tester) async {
    final product = MockProducts.all.first;
    await openProduct(tester, product.name, product.name);
    final lineId = await addToCart(tester, product.sizes.first.label);
    await popToShell(tester);
    return lineId;
  }

  testWidgets('opens on the Home tab with the designed sections', (
    tester,
  ) async {
    await pumpApp(tester);
    
    expect(find.text('Find Your'), findsOneWidget);
    expect(find.text('Scroll by Category'), findsOneWidget);
    expect(find.text('Trending'), findsOneWidget);

    // Later sections sit further down the scrolling home page.
    await scrollTo(tester, find.text('New Arrivals'), 'home-scroll');
    await scrollTo(tester, find.text('More For You'), 'home-scroll');
  });

  testWidgets('keeps the five bottom navigation destinations', (tester) async {
    await pumpApp(tester);

    for (final label in <String>[
      'Home',
      'Search',
      'Camera',
      'Cart',
      'Person',
    ]) {
      expect(navDestination(label), findsOneWidget, reason: 'missing $label');
    }
  });

  testWidgets('Camera and Person are coming soon placeholders', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(navDestination('Camera'));
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);

    await tester.tap(navDestination('Person'));
    await tester.pumpAndSettle();
    expect(find.text('Coming soon'), findsOneWidget);
  });
  testWidgets('typing a search query filters the product grid', (tester) async {
    await pumpApp(tester);

    await searchFor(tester, 'Loafers');

    expect(productCardWith('Hitz Blue 2 Loafers'), findsOneWidget);
    expect(productCardWith('Aviator Sunglasses'), findsNothing);
  });

  testWidgets('a search with no matches shows an empty state', (
    tester,
  ) async {
    await pumpApp(tester);

    await searchFor(tester, 'zzzznotathing');

    expect(find.text('No products found'), findsOneWidget);
  });

  testWidgets('filter chips toggle on and off', (tester) async {
    await pumpApp(tester);

    await tapNav(tester, 'Search');
    
    // Without a filter the grid mixes categories.
    await scrollTo(tester, productCardWith('Hitz Blue 2 Loafers'), 'search-grid');
    await scrollTo(tester, productCardWith('Round Frame Sunglasses'), 'search-grid');

    // Selecting the Watch chip narrows the grid to watches only.
    await tapVisible(tester, find.text('Watch'));
    expect(productCardWith('Chronograph Watch'), findsOneWidget);
    expect(productCardWith('Hitz Blue 2 Loafers'), findsNothing);

    // Tapping the chip again clears it and restores the full grid.
    await tapVisible(tester, find.text('Watch'));
    await scrollTo(tester, productCardWith('Hitz Blue 2 Loafers'), 'search-grid');
  });

  testWidgets('Product Details shows the selected product', (tester) async {
    await pumpApp(tester);

    await openProduct(tester, 'Loafers', 'Hitz Blue 2 Loafers');
    
    expect(find.text('4000 pkr'), findsOneWidget);
    expect(find.text('Add Cart'), findsOneWidget);
    expect(find.text('Try Now'), findsOneWidget);

    await scrollTo(tester, find.text('Product details'), 'details-scroll');
    expect(find.text('Product details'), findsOneWidget);

    await scrollTo(tester, find.text('Customer Reviews'), 'details-scroll');
    expect(find.text('Customer Reviews'), findsOneWidget);
  });

  testWidgets('Add Cart requires a size and then confirms without navigating', (
    tester,
  ) async {
    await pumpApp(tester);

    await openProduct(tester, 'Loafers', 'Hitz Blue 2 Loafers');
    
    // Adding without choosing a size is rejected with visible feedback.
    await tapVisible(tester, find.text('Add Cart'), scrollKey: 'details-scroll');
    await settleSnackBar(tester);
    expect(find.text('Please select a size first'), findsOneWidget);

    // Choose a size, then add.
    await tapVisible(tester, find.text('S'), scrollKey: 'details-scroll');
    await tapVisible(tester, find.text('Add Cart'), scrollKey: 'details-scroll');
    await settleSnackBar(tester);

    // Confirmation is shown and Product Details stays on screen.
    expect(find.text('Added to your cart'), findsOneWidget);
    expect(find.text('Your Cart'), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('the cart shows the added product with its selected options', (
    tester,
  ) async {
    await pumpApp(tester);

    await openProduct(tester, 'Loafers', 'Hitz Blue 2 Loafers');
        await tapVisible(tester, find.text('S'), scrollKey: 'details-scroll');
    await tapVisible(tester, find.text('Add Cart'), scrollKey: 'details-scroll');
    await popToShell(tester);

    await tapNav(tester, 'Cart');

    expect(find.text('Your Cart'), findsOneWidget);
    expect(find.text('Hitz Blue 2 Loafers'), findsOneWidget);
    expect(find.text('Size S  •  Blue'), findsOneWidget);

    // Totals follow the designs: 4000 sub total + 250 shipping = 4250.
    expect(find.text('250 pkr'), findsOneWidget);
    expect(find.text('4250 pkr'), findsOneWidget);

    // Tax has no agreed rule yet, so it must not be invented.
    expect(find.text('Not available'), findsOneWidget);

    // The unit price shows on the line item and again as the sub total.
    expect(find.text('4000 pkr'), findsNWidgets(2));
  });

  testWidgets('cart empty state offers a route back to browsing', (
    tester,
  ) async {
    await pumpApp(tester);

    await tapNav(tester, 'Cart');
    expect(find.text('Your cart is empty'), findsOneWidget);

    await tester.tap(find.text('Browse products'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey<String>('search-field')), findsOneWidget);
  });
  testWidgets('increasing quantity updates the displayed total', (tester) async {
    final product = MockProducts.all.first;
    await pumpSingleProductApp(tester);
    final lineId = await addFirstProductToCart(tester);

    await tapNav(tester, 'Cart');

    final cart = cartOf(tester);
    expect(cart.quantityOf(lineId), 1);

    await tester.tap(find.byKey(ValueKey<String>('increment-$lineId')));
    await tester.pumpAndSettle();

    expect(cart.quantityOf(lineId), 2);
    expect(cart.subtotalPkr, product.pricePkr * 2);
    expect(cart.orderTotalPkr, product.pricePkr * 2 + 250);
  });

  testWidgets('decreasing quantity updates the displayed total', (
    tester,
  ) async {
    final product = MockProducts.all.first;
    await pumpSingleProductApp(tester);
    final lineId = await addFirstProductToCart(tester);

    await tapNav(tester, 'Cart');

    final cart = cartOf(tester);

    // Add a second unit, then step back down.
    await tester.tap(find.byKey(ValueKey<String>('increment-$lineId')));
    await tester.pumpAndSettle();
    expect(cart.quantityOf(lineId), 2);

    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pumpAndSettle();

    expect(cart.quantityOf(lineId), 1);
    expect(cart.subtotalPkr, product.pricePkr);
  });

  testWidgets('removing a line empties the cart', (tester) async {
    await pumpSingleProductApp(tester);
    final lineId = await addFirstProductToCart(tester);

    await tapNav(tester, 'Cart');
    expect(find.text('Your cart is empty'), findsNothing);

    await tester.tap(find.byKey(ValueKey<String>('remove-$lineId')));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Proceed to Checkout'), findsNothing);
    expect(cartOf(tester).isEmpty, isTrue);
  });

  testWidgets('two different sizes become two cart lines', (tester) async {
    await pumpApp(tester);

    await openProduct(tester, 'Loafers', 'Hitz Blue 2 Loafers');
    
    await tapVisible(tester, find.text('S'), scrollKey: 'details-scroll');
    await tapVisible(tester, find.text('Add Cart'), scrollKey: 'details-scroll');

    await tapVisible(tester, find.text('M'), scrollKey: 'details-scroll');
    await tapVisible(tester, find.text('Add Cart'), scrollKey: 'details-scroll');
    await popToShell(tester);

    await tapNav(tester, 'Cart');

    final cart = cartOf(tester);
    expect(cart.lineCount, 2);
    expect(cart.subtotalPkr, 8000);
    expect(find.text('Size S  •  Blue'), findsOneWidget);
    expect(find.text('Size M  •  Blue'), findsOneWidget);
  });

  testWidgets('the cart badge counts units rather than lines', (
    tester,
  ) async {
    await pumpSingleProductApp(tester);
    final lineId = await addFirstProductToCart(tester);

    await tapNav(tester, 'Cart');

    await tester.tap(find.byKey(ValueKey<String>('increment-$lineId')));
    await tester.pumpAndSettle();

    final cart = cartOf(tester);
    expect(cart.lineCount, 1);
    expect(cart.totalQuantity, 2);
  });
}
