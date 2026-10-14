import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/models/product.dart';
import 'package:customer_app/state/cart_controller.dart';

const ProductColour blue = ProductColour(name: 'Blue', value: 0xFF2F4F7F);
const ProductColour black = ProductColour(name: 'Black', value: 0xFF1F1F1F);

Product buildProduct({
  String id = 'p-1',
  int pricePkr = 4000,
  List<ProductOption>? sizes,
}) {
  return Product(
    id: id,
    name: 'Test Product',
    subtitle: 'Test',
    description: 'Test product used by the cart tests.',
    category: 'Shoes',
    collection: 'Casual',
    pricePkr: pricePkr,
    sizes: sizes ??
        const <ProductOption>[
          ProductOption(label: 'S', stock: 4),
          ProductOption(label: 'M', stock: 6),
          ProductOption(label: 'L', stock: 0),
        ],
    colours: const <ProductColour>[blue, black],
    placeholderColors: const <Color>[],
  );
}

Product buildWatch({String id = 'watch', int pricePkr = 12500}) {
  return buildProduct(
    id: id,
    pricePkr: pricePkr,
    sizes: const <ProductOption>[ProductOption(label: 'Standard', stock: 3)],
  );
}

String lineId(String productId, String size, String colour) =>
    '$productId|$size|$colour';

void main() {
  group('CartController totals', () {
    test('starts empty with zeroed totals and no shipping', () {
      final cart = CartController();

      expect(cart.isEmpty, isTrue);
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.subtotalPkr, 0);
      expect(cart.shippingPkr, 0);
      expect(cart.orderTotalPkr, 0);
    });

    test('subtotal multiplies unit price by quantity', () {
      final cart = CartController();
      final product = buildProduct(pricePkr: 4000);

      cart.addItem(
        product: product,
        size: product.sizes[0],
        colour: blue,
        quantity: 3,
      );

      expect(cart.subtotalPkr, 12000);
      expect(cart.totalQuantity, 3);
    });

    test('shipping is a flat 250 pkr and total is subtotal plus shipping', () {
      final cart = CartController();
      final product = buildProduct(pricePkr: 4000);

      cart.addItem(product: product, size: product.sizes[0], colour: blue);

      expect(cart.shippingPkr, 250);
      expect(cart.subtotalPkr, 4000);
      expect(cart.orderTotalPkr, 4250);
    });

    test('tax is not calculated because no rule has been agreed', () {
      final cart = CartController();
      final product = buildProduct(pricePkr: 4000);

      cart.addItem(product: product, size: product.sizes[0], colour: blue);

      expect(cart.taxPkr, 0);
      expect(
        cart.orderTotalPkr,
        cart.subtotalPkr + cart.shippingPkr,
        reason: 'Order total must exclude tax until a rule is provided.',
      );
    });

    test('sums subtotal across several distinct lines', () {
      final cart = CartController();
      final shoes = buildProduct(id: 'shoes', pricePkr: 4000);
      final watch = buildWatch();

      cart.addItem(
        product: shoes,
        size: shoes.sizes[0],
        colour: blue,
        quantity: 2,
      );
      cart.addItem(product: watch, size: watch.sizes[0], colour: black);

      expect(cart.lineCount, 2);
      expect(cart.totalQuantity, 3);
      expect(cart.subtotalPkr, 2 * 4000 + 12500);
      expect(cart.orderTotalPkr, 2 * 4000 + 12500 + 250);
    });

    test('shipping is dropped when the cart becomes empty again', () {
      final cart = CartController();
      final product = buildProduct();

      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      expect(cart.shippingPkr, 250);

      cart.clear();

      expect(cart.isEmpty, isTrue);
      expect(cart.shippingPkr, 0);
      expect(cart.orderTotalPkr, 0);
    });
  });
  group('CartController add behaviour', () {
    test('adding the same variant twice merges into one line', () {
      final cart = CartController();
      final product = buildProduct();
      final size = product.sizes[0];

      cart.addItem(product: product, size: size, colour: blue);
      cart.addItem(product: product, size: size, colour: blue);

      expect(cart.lineCount, 1);
      expect(cart.quantityOf(lineId(product.id, 'S', 'Blue')), 2);
    });

    test('a different size creates a separate line', () {
      final cart = CartController();
      final product = buildProduct();

      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      cart.addItem(product: product, size: product.sizes[1], colour: blue);

      expect(cart.lineCount, 2);
      expect(cart.totalQuantity, 2);
    });

    test('a different colour creates a separate line', () {
      final cart = CartController();
      final product = buildProduct();

      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      cart.addItem(product: product, size: product.sizes[0], colour: black);

      expect(cart.lineCount, 2);
      expect(cart.containsProduct(product.id), isTrue);
    });

    test('an out-of-stock size is rejected', () {
      final cart = CartController();
      final product = buildProduct();

      final added = cart.addItem(
        product: product,
        size: product.sizes[2], // Size L has zero stock.
        colour: blue,
      );

      expect(added, 0);
      expect(cart.isEmpty, isTrue);
    });

    test('quantity is capped at the available stock', () {
      final cart = CartController();
      final product = buildProduct(
        sizes: const <ProductOption>[ProductOption(label: 'S', stock: 2)],
      );

      final added = cart.addItem(
        product: product,
        size: product.sizes[0],
        colour: blue,
        quantity: 5,
      );

      expect(added, 2);
      expect(cart.quantityOf(lineId(product.id, 'S', 'Blue')), 2);
    });

    test('re-adding a variant already at the stock limit adds nothing', () {
      final cart = CartController();
      final product = buildProduct(
        sizes: const <ProductOption>[ProductOption(label: 'S', stock: 1)],
      );
      final size = product.sizes[0];

      cart.addItem(product: product, size: size, colour: blue);
      final second = cart.addItem(product: product, size: size, colour: blue);

      expect(second, 0);
      expect(cart.quantityOf(lineId(product.id, 'S', 'Blue')), 1);
    });

    test('a non-positive quantity is rejected', () {
      final cart = CartController();
      final product = buildProduct();

      expect(
        cart.addItem(
          product: product,
          size: product.sizes[0],
          colour: blue,
          quantity: 0,
        ),
        0,
      );
      expect(cart.isEmpty, isTrue);
    });
  });
  group('CartController quantity controls', () {
    test('increment raises the quantity by one', () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      final id = lineId(product.id, 'S', 'Blue');

      expect(cart.increment(id), isTrue);
      expect(cart.quantityOf(id), 2);
      expect(cart.subtotalPkr, 8000);
    });

    test('increment stops at the stock limit', () {
      final cart = CartController();
      final product = buildProduct(
        sizes: const <ProductOption>[ProductOption(label: 'S', stock: 2)],
      );
      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      final id = lineId(product.id, 'S', 'Blue');

      expect(cart.increment(id), isTrue);
      expect(
        cart.increment(id),
        isFalse,
        reason: 'Already at the stock limit.',
      );
      expect(cart.quantityOf(id), 2);
    });

    test('increment returns false for an unknown line', () {
      final cart = CartController();

      expect(cart.increment('missing|line'), isFalse);
    });

    test('decrement lowers the quantity and updates the subtotal', () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(
        product: product,
        size: product.sizes[0],
        colour: blue,
        quantity: 2,
      );
      final id = lineId(product.id, 'S', 'Blue');

      expect(cart.decrement(id), isTrue);
      expect(cart.quantityOf(id), 1);
      expect(cart.subtotalPkr, 4000);
    });

    test('decrement never drops below one unit', () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      final id = lineId(product.id, 'S', 'Blue');

      expect(cart.decrement(id), isFalse);
      expect(cart.quantityOf(id), 1);
      expect(cart.isNotEmpty, isTrue);
    });

    test('decrement returns false for an unknown line', () {
      final cart = CartController();

      expect(cart.decrement('missing|line'), isFalse);
    });
  });

  group('CartController removal', () {
    test('removeItem drops the line and recalculates totals', () {
      final cart = CartController();
      final product = buildProduct(pricePkr: 4000);
      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      cart.addItem(product: product, size: product.sizes[1], colour: blue);

      expect(cart.lineCount, 2);
      expect(cart.subtotalPkr, 8000);

      expect(cart.removeItem(lineId(product.id, 'S', 'Blue')), isTrue);

      expect(cart.lineCount, 1);
      expect(cart.contains(lineId(product.id, 'S', 'Blue')), isFalse);
      expect(cart.subtotalPkr, 4000);
      expect(cart.totalQuantity, 1);
    });

    test('removing every line empties the cart', () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      cart.addItem(product: product, size: product.sizes[0], colour: black);

      cart.removeItem(lineId(product.id, 'S', 'Blue'));
      cart.removeItem(lineId(product.id, 'S', 'Black'));

      expect(cart.isEmpty, isTrue);
      expect(cart.orderTotalPkr, 0);
    });

    test('removing an unknown line returns false and leaves the cart alone',
        () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);

      expect(cart.removeItem('missing|line'), isFalse);
      expect(cart.lineCount, 1);
    });

    test('clear empties the cart', () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);

      cart.clear();

      expect(cart.isEmpty, isTrue);
      expect(cart.items, isEmpty);
    });

    test('clear on an already empty cart does not notify listeners', () {
      final cart = CartController();
      var notifications = 0;
      cart.addListener(() => notifications++);

      cart.clear();

      expect(notifications, 0);
    });
  });

  group('CartController notifications', () {
    test('notifies listeners when the cart changes', () {
      final cart = CartController();
      var notifications = 0;
      cart.addListener(() => notifications++);

      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);
      cart.increment(lineId(product.id, 'S', 'Blue'));
      cart.decrement(lineId(product.id, 'S', 'Blue'));
      cart.removeItem(lineId(product.id, 'S', 'Blue'));

      expect(notifications, 4);
    });

    test('the exposed items list cannot be mutated by callers', () {
      final cart = CartController();
      final product = buildProduct();
      cart.addItem(product: product, size: product.sizes[0], colour: blue);

      expect(() => cart.items.clear(), throwsUnsupportedError);
    });
  });

  group('shippingFor helper', () {
    test('returns 0 for an empty cart', () {
      expect(shippingFor(0, true), 0);
    });

    test('returns the flat fee for a non-empty cart', () {
      expect(kFlatShippingPkr, 250);
      expect(shippingFor(4000, false), 250);
    });
  });
}