import '../models/product.dart';
import 'mock_products.dart';

/// Read-only access to the product catalogue for this milestone.
///
/// The repository is the single seam that will later be replaced by a remote
/// data source. Screens depend on this interface, not on the mock data, so the
/// backend can be introduced without changing the UI layer.
class ProductRepository {
  ProductRepository({List<Product>? products})
      : _products = List<Product>.unmodifiable(products ?? MockProducts.all);

  final List<Product> _products;

  /// Every product in the catalogue.
  List<Product> get all => _products;

  /// Filter chips rendered on the Search screen.
  List<String> get categories => MockProducts.categories;

  /// Home page "Scroll by Category" rail values.
  List<String> get collections => MockProducts.collections;

  Product? byId(String id) {
    for (final product in _products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  List<Product> trending() =>
      _products.where((product) => product.isTrending).toList(growable: false);

  List<Product> newArrivals() => _products
      .where((product) => product.isNewArrival)
      .toList(growable: false);

  List<Product> byCollection(String collection) => _products
      .where((product) => product.collection.toLowerCase() == collection.toLowerCase())
      .toList(growable: false);

  /// Free-text search across product name, subtitle, category and collection.
  List<Product> search(String query) => _products
      .where((product) => product.matchesQuery(query))
      .toList(growable: false);

  /// Applies the active filter chips to [results].
  ///
  /// An empty [selectedCategories] means "no filtering", which keeps a plain
  /// search usable. Selecting several chips matches any of them.
  List<Product> applyCategoryFilters(
    List<Product> results,
    Set<String> selectedCategories,
  ) {
    if (selectedCategories.isEmpty) {
      return results;
    }
    return results
        .where((product) => selectedCategories.any(product.matchesCategory))
        .toList(growable: false);
  }

  /// Convenience search used by the Search screen.
  List<Product> searchWithFilters(String query, Set<String> selectedCategories) =>
      applyCategoryFilters(search(query), selectedCategories);
}