import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/models/event_package.dart';
import '../core/services/event_service.dart';

/// Manages event categories and packages
/// Fetches data from Firebase Realtime Database via EventService
class EventsProvider extends ChangeNotifier {
  final EventService _eventService = EventService();
  StreamSubscription<List<EventCategory>>? _subscription;

  // State
  List<EventCategory> _categories = [];
  bool _isLoading = true;
  String? _error;

  EventsProvider() {
    _initStream();
  }

  // Getters
  List<EventCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initStream() {
    _isLoading = true;
    notifyListeners();

    _subscription = _eventService.getEventCategoriesStream().listen(
      (categories) {
        // Filter out inactive categories securely
        // Note: Admin might need to see all, but for now this is primarily for UI
        // We can add a filter method if needed, but usually the UI filters based on requirements
        _categories = categories; 
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error loading event categories: $e');
        _error = 'Failed to load events: $e';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Get specific category by ID
  EventCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get active categories only (for Customer UI)
  List<EventCategory> get activeCategories {
    return _categories.where((e) => e.status == 'active').toList();
  }

  /// Refresh (No-op as we use streams, but good for consistent API)
  Future<void> refresh() async {
    // Stream handles updates automatically
  }
}
