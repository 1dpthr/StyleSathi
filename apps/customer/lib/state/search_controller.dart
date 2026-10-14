import 'package:flutter/foundation.dart';

/// Search query and active filter chips for the Search screen.
///
/// Kept separate from the cart because it is screen state, not app state. The
/// Search screen persists across bottom navigation switches, so this controller
/// deliberately outlives individual widget rebuilds.
///
/// Named `ProductSearchController` because Flutter's Material library already
/// exports a `SearchController` for its own search view.
class ProductSearchController extends ChangeNotifier {
  String _query = '';
  final Set<String> _selectedCategories = <String>{};

  String get query => _query;

  /// Active filter chips. An empty set means no category filtering.
  Set<String> get selectedCategories =>
      Set<String>.unmodifiable(_selectedCategories);

  bool get hasActiveFilters => _selectedCategories.isNotEmpty;

  /// `true` when either a query or at least one chip is active, which is when
  /// the "clear" affordance becomes visible.
  bool get isFiltered => _query.trim().isNotEmpty || hasActiveFilters;

  void updateQuery(String value) {
    if (_query == value) {
      return;
    }
    _query = value;
    notifyListeners();
  }

  void clearQuery() => updateQuery('');

  /// Toggles a chip on or off.
  void toggleCategory(String category) {
    if (!_selectedCategories.remove(category)) {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  bool isSelected(String category) => _selectedCategories.contains(category);

  void clearFilters() {
    if (_selectedCategories.isEmpty) {
      return;
    }
    _selectedCategories.clear();
    notifyListeners();
  }

  /// Removes every query and filter, used by the Search screen empty state.
  void reset() {
    _query = '';
    _selectedCategories.clear();
    notifyListeners();
  }
}