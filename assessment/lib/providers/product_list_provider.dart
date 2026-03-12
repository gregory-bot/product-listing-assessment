import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

enum ProductListState { initial, loading, loaded, error, refreshing }

class ProductListProvider extends ChangeNotifier {
  ProductListState _state = ProductListState.initial;
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _filterQuery = '';
  final Map<String, VariantModel> _selectedVariants = {};
  final Set<String> _favoriteIds = {};
  String? _errorMessage;
  bool? _lastSortAscending;

  ProductListState get state => _state;

  List<ProductModel> get products => List.unmodifiable(_products);

  List<ProductModel> get filteredProducts => List.unmodifiable(_filteredProducts);

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    // Use refreshing state if already loaded or refreshing, loading otherwise
    if (_state == ProductListState.loaded ||
        _state == ProductListState.refreshing) {
      _state = ProductListState.refreshing;
    } else {
      _state = ProductListState.loading;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final service = GetIt.instance<ProductService>();
      final fetched = await service.fetchProducts();

      _products = fetched;
      
      // Apply current filter to new products
      if (_filterQuery.isNotEmpty) {
        _filteredProducts = _products
            .where((p) =>
                p.title.toLowerCase().contains(_filterQuery.toLowerCase()))
            .toList();
      } else {
        _filteredProducts = List.from(_products);
      }
      
      // Re-apply sort if it was previously applied
      if (_lastSortAscending != null) {
        _applySortToFiltered(_lastSortAscending!);
      }

      for (final p in _products) {
        if (p.variants.isNotEmpty && !_selectedVariants.containsKey(p.id)) {
          _selectedVariants[p.id] = p.variants.first;
        }
      }

      _state = ProductListState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProductListState.error;
    }

    notifyListeners();
  }

  void selectVariant(String productId, VariantModel variant) {
    _selectedVariants[productId] = variant;
    notifyListeners();
  }

  VariantModel? selectedVariantFor(String productId) =>
      _selectedVariants[productId];

  void filterProducts(String query) {
    _filterQuery = query.trim();
    
    if (_filterQuery.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((p) =>
              p.title.toLowerCase().contains(_filterQuery.toLowerCase()))
          .toList();
    }
    
    // Re-apply sort if it was previously applied
    if (_lastSortAscending != null) {
      _applySortToFiltered(_lastSortAscending!);
    }
    
    notifyListeners();
  }

  void sortByPrice({required bool ascending}) {
    _lastSortAscending = ascending;
    _applySortToFiltered(ascending);
    notifyListeners();
  }

  void _applySortToFiltered(bool ascending) {
    _filteredProducts.sort((a, b) {
      final aVariant = _selectedVariants[a.id];
      final bVariant = _selectedVariants[b.id];
      
      // Products with no selected variant sort to end
      if (aVariant == null && bVariant == null) return 0;
      if (aVariant == null) return 1;
      if (bVariant == null) return -1;
      
      final comparison = aVariant.price.compareTo(bVariant.price);
      return ascending ? comparison : -comparison;
    });
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);
}
