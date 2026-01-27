import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/models/menu_item.dart';
import '../core/models/region.dart';
import '../core/services/database_service.dart';

/// Manages menu items and categories
/// Fetches menu data from Firebase Realtime Database
class MenuProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  StreamSubscription<List<MenuItem>>? _subscription;

  // State
  List<MenuItem> _allMenuItems = []; // Source of truth
  List<MenuItem> _filteredItems = []; // Displayed items
  
  String _selectedCategory = 'All';
  String _selectedCuisine = 'All'; // Added cuisine filter
  String _searchQuery = '';
  
  bool _isLoading = true;
  String? _error;
  
  // Default Region (can be updated)
  Region _selectedRegion = Region.pakistan; 

  MenuProvider() {
    _initStream();
  }

  // Getters
  List<MenuItem> get menuItems => _filteredItems;
  
  List<String> get categories {
    final cats = _allMenuItems.map((e) => e.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }
  
  List<String> get cuisines {
     final cuisines = _allMenuItems
        .where((e) => e.cuisineType != null)
        .map((e) => e.cuisineType!)
        .toSet()
        .toList();
    cuisines.sort();
    return ['All', ...cuisines];
  }

  String get selectedCategory => _selectedCategory;
  String get selectedCuisine => _selectedCuisine; // Getter for cuisine
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get isEmpty => _allMenuItems.isEmpty;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initStream() {
    _isLoading = true;
    notifyListeners();

    _subscription = _db.getMenuItemsStream().listen(
      (items) {
        _allMenuItems = items;
        _applyFilters(); // Re-apply filters whenever data updates
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error loading menu items: $e');
        _error = 'Failed to load menu items: $e';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Filter menu items by category
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }
  
  /// Filter menu items by cuisine
  void setCuisine(String cuisine) {
    _selectedCuisine = cuisine;
    _applyFilters();
    notifyListeners();
  }

  /// Search menu items by name or description
  void searchItems(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Internal method to apply all filters (Category, Cuisine, Search, Region Availability)
  void _applyFilters() {
    _filteredItems = _allMenuItems.where((item) {
      // 1. Region Availability
      if (!item.regions.contains(_selectedRegion.code)) return false;
      if (!item.available) return false;

      // 2. Category Filter
      if (_selectedCategory != 'All' && item.category != _selectedCategory) {
        return false;
      }

      // 3. Cuisine Filter
      if (_selectedCuisine != 'All' && item.cuisineType != _selectedCuisine) {
        return false;
      }

      // 4. Search Filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = item.name.toLowerCase().contains(q);
        final matchesDesc = item.description.toLowerCase().contains(q);
        if (!matchesName && !matchesDesc) return false;
      }

      return true;
    }).toList();
  }

  /// Get featured items (e.g. random 6 or specific logic)
  List<MenuItem> getFeaturedItems({int limit = 6}) {
    // For now, just take the first N items from filtered list
    return _filteredItems.take(limit).toList();
  }
  
  /// Get items by specific category (helper)
  List<MenuItem> getItemsByCategory(String category) {
    return _allMenuItems
        .where((item) => (category == 'All' || item.category == category) && item.regions.contains(_selectedRegion.code))
        .toList();
  }

  // Region specific methods
  double getPrice(MenuItem item) {
    return item.getPrice(_selectedRegion);
  }

  String getFormattedPrice(MenuItem item) {
    return item.getFormattedPrice(_selectedRegion);
  }
  
  // Method to update region if needed (e.g. from settings)
  void updateRegion(Region region) {
    _selectedRegion = region;
    _applyFilters();
    notifyListeners();
  }

  // Refresh (No-op for real-time stream, but kept for compatibility)
  Future<void> refresh() async {
    // Stream updates automatically, but we could force a reload if we weren't using streams
  }
  
  // Legacy method name support if needed
  void filterByCategory(String category) => setCategory(category);
}