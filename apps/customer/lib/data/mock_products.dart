import 'package:flutter/material.dart';

import '../models/product.dart';

/// In-memory product catalogue used for the Browse-to-Cart milestone.
///
/// Firebase and the real backend are explicitly out of scope for this
/// milestone (see `docs/05_CUSTOMER_BROWSE_CART_FLOW.md`), so the catalogue is
/// local and static. Every price is in Pakistani Rupees, matching the designs.
abstract final class MockProducts {
  static const List<Product> all = <Product>[
    Product(
      id: 'p-hitz-blue-2',
      name: 'Hitz Blue 2 Loafers',
      subtitle: 'HITZ',
      description:
          'HITZ, the most stylish range of genuine leather casual shoes '
          'exclusively designed to match the latest trends of the new '
          'generation. Known for its sturdy and stylish designs.',
      category: 'Shoes',
      collection: 'Casual',
      pricePkr: 4000,
      sizes: <ProductOption>[
        ProductOption(label: 'S', stock: 4),
        ProductOption(label: 'M', stock: 6),
        ProductOption(label: 'L', stock: 2),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Blue', value: 0xFF2F4F7F),
        ProductColour(name: 'Black', value: 0xFF1F1F1F),
      ],
      placeholderColors: <Color>[Color(0xFF5B6B7F), Color(0xFF2C3A4B)],
      placeholderIcon: Icons.ice_skating_outlined,
      rating: 5,
      reviewCount: 2,
      isTrending: true,
      isNewArrival: true,
    ),
    Product(
      id: 'p-urban-runner',
      name: 'Urban Runner Sneakers',
      subtitle: 'Stride',
      description:
          'A lightweight everyday sneaker with a cushioned sole and breathable '
          'upper, built for long city walks.',
      category: 'Shoes',
      collection: 'Casual',
      pricePkr: 5200,
      sizes: <ProductOption>[
        ProductOption(label: 'S', stock: 3),
        ProductOption(label: 'M', stock: 5),
        ProductOption(label: 'L', stock: 0),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'White', value: 0xFFF2F2F0),
        ProductColour(name: 'Navy', value: 0xFF24304A),
      ],
      placeholderColors: <Color>[Color(0xFFD9DDE2), Color(0xFF8A929C)],
      placeholderIcon: Icons.ice_skating_outlined,
      isTrending: true,
    ),
    Product(
      id: 'p-velvet-derby',
      name: 'Velvet Derby Formal',
      subtitle: 'Atelier',
      description:
          'A polished derby with a slim profile, finished for evening and '
          'formal occasions.',
      category: 'Shoes',
      collection: 'Formals',
      pricePkr: 7800,
      sizes: <ProductOption>[
        ProductOption(label: 'M', stock: 2),
        ProductOption(label: 'L', stock: 3),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Tan', value: 0xFF8B5E3C),
      ],
      placeholderColors: <Color>[Color(0xFF6E4A2E), Color(0xFF3A2617)],
      placeholderIcon: Icons.ice_skating_outlined,
      isNewArrival: true,
    ),
    Product(
      id: 'p-slim-trousers',
      name: 'Slim Fit Trousers',
      subtitle: 'Meridian',
      description:
          'Tailored slim-fit trousers with a clean break and a comfortable '
          'all-day waistband.',
      category: 'Pants',
      collection: 'Formals',
      pricePkr: 4500,
      sizes: <ProductOption>[
        ProductOption(label: '30', stock: 5),
        ProductOption(label: '32', stock: 4),
        ProductOption(label: '34', stock: 2),
        ProductOption(label: '36', stock: 1),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Charcoal', value: 0xFF3A3A3A),
        ProductColour(name: 'Navy', value: 0xFF24304A),
      ],
      placeholderColors: <Color>[Color(0xFF6E7480), Color(0xFF39404C)],
      placeholderIcon: Icons.dry_cleaning_outlined,
      isTrending: true,
    ),
    Product(
      id: 'p-cargo-joggers',
      name: 'Cargo Joggers',
      subtitle: 'Northline',
      description:
          'Relaxed cargo joggers with side pockets and an elasticated waist, '
          'made for everyday wear.',
      category: 'Pants',
      collection: 'Casual',
      pricePkr: 3600,
      sizes: <ProductOption>[
        ProductOption(label: 'S', stock: 6),
        ProductOption(label: 'M', stock: 6),
        ProductOption(label: 'L', stock: 4),
        ProductOption(label: 'XL', stock: 0),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Olive', value: 0xFF5B6348),
        ProductColour(name: 'Black', value: 0xFF1F1F1F),
      ],
      placeholderColors: <Color>[Color(0xFF8A8F6E), Color(0xFF43492F)],
      placeholderIcon: Icons.dry_cleaning_outlined,
    ),
    Product(
      id: 'p-chrono-watch',
      name: 'Chronograph Watch',
      subtitle: 'Meridian',
      description:
          'A classic chronograph with a stainless steel case, mineral glass '
          'and a five ATM water resistance rating.',
      category: 'Watch',
      collection: 'Formals',
      pricePkr: 12500,
      sizes: <ProductOption>[
        ProductOption(label: 'Standard', stock: 3),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Silver', value: 0xFFB9BDC2),
        ProductColour(name: 'Gold', value: 0xFFC9A227),
      ],
      placeholderColors: <Color>[Color(0xFFB8BCC1), Color(0xFF5A5F66)],
      placeholderIcon: Icons.watch_outlined,
      isNewArrival: true,
    ),
    Product(
      id: 'p-leather-strap-watch',
      name: 'Minimal Leather Watch',
      subtitle: 'Atelier',
      description:
          'A minimal dress watch with a slim stainless case and a soft leather '
          'strap.',
      category: 'Watch',
      collection: 'Casual',
      pricePkr: 8900,
      sizes: <ProductOption>[
        ProductOption(label: 'Standard', stock: 4),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Brown', value: 0xFF6B4A2F),
      ],
      placeholderColors: <Color>[Color(0xFF9A7A5A), Color(0xFF46321F)],
      placeholderIcon: Icons.watch_outlined,
    ),
    Product(
      id: 'p-signet-ring',
      name: 'Emerald Signet Ring',
      subtitle: 'Nadir',
      description:
          'A hand-finished signet ring set with a deep green stone, plated in '
          'gold tone metal.',
      category: 'Rings',
      collection: 'Formals',
      pricePkr: 3200,
      sizes: <ProductOption>[
        ProductOption(label: 'M', stock: 5),
        ProductOption(label: 'L', stock: 2),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Emerald', value: 0xFF1F6F4A),
        ProductColour(name: 'Gold', value: 0xFFC9A227),
      ],
      placeholderColors: <Color>[Color(0xFF2E8B5F), Color(0xFF14402B)],
      placeholderIcon: Icons.diamond_outlined,
      isTrending: true,
    ),
    Product(
      id: 'p-stacking-rings',
      name: 'Delicate Stacking Rings',
      subtitle: 'Nadir',
      description:
          'A set of three fine stacking rings designed to be worn together or '
          'separately.',
      category: 'Rings',
      collection: 'Casual',
      pricePkr: 2450,
      sizes: <ProductOption>[
        ProductOption(label: 'S', stock: 3),
        ProductOption(label: 'M', stock: 0),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Rose Gold', value: 0xFFB76E79),
      ],
      placeholderColors: <Color>[Color(0xFFC68B95), Color(0xFF6E3A42)],
      placeholderIcon: Icons.diamond_outlined,
    ),
    Product(
      id: 'p-round-sunglasses',
      name: 'Round Frame Sunglasses',
      subtitle: 'Solace',
      description:
          'Lightweight round-frame sunglasses with polarised lenses and a '
          'universally flattering fit.',
      category: 'Glasses',
      collection: 'Casual',
      pricePkr: 2750,
      sizes: <ProductOption>[
        ProductOption(label: 'Standard', stock: 8),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Gold', value: 0xFFC9A227),
        ProductColour(name: 'Black', value: 0xFF1F1F1F),
      ],
      placeholderColors: <Color>[Color(0xFFC9A227), Color(0xFF6B5714)],
      placeholderIcon: Icons.visibility_outlined,
      isNewArrival: true,
    ),
    Product(
      id: 'p-aviator-sunglasses',
      name: 'Aviator Sunglasses',
      subtitle: 'Solace',
      description:
          'Classic aviator frames with adjustable nose pads and gradient '
          'tinted lenses.',
      category: 'Glasses',
      collection: 'Formals',
      pricePkr: 3600,
      sizes: <ProductOption>[
        ProductOption(label: 'Standard', stock: 5),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Silver', value: 0xFFB9BDC2),
      ],
      placeholderColors: <Color>[Color(0xFFAEB4BA), Color(0xFF4C5259)],
      placeholderIcon: Icons.visibility_outlined,
      isTrending: true,
    ),
    Product(
      id: 'p-kurta-shalwar',
      name: 'Cotton Kurta Shalwar',
      subtitle: 'Nadir',
      description:
          'A breathable cotton kurta with matching shalwar, finished with '
          'traditional detailing.',
      category: 'Traditional',
      collection: 'Traditional',
      pricePkr: 5200,
      sizes: <ProductOption>[
        ProductOption(label: 'M', stock: 4),
        ProductOption(label: 'L', stock: 3),
        ProductOption(label: 'XL', stock: 1),
      ],
      colours: <ProductColour>[
        ProductColour(name: 'Maroon', value: 0xFF6E2233),
        ProductColour(name: 'Cream', value: 0xFFF0E6D2),
      ],
      placeholderColors: <Color>[Color(0xFF8E3A4B), Color(0xFF3C141C)],
      placeholderIcon: Icons.checkroom_outlined,
      isNewArrival: true,
    ),
  ];

  /// Filter chips shown on the Search screen, in design order.
  static const List<String> categories = <String>[
    'Shoes',
    'Watch',
    'Pants',
    'Rings',
    'Glasses',
    'Traditional',
  ];

  /// Home page "Scroll by Category" rail.
  static const List<String> collections = <String>[
    'Casual',
    'Formals',
    'Traditional',
  ];
}