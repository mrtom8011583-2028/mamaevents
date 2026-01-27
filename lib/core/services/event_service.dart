import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/event_package.dart';

/// Service to handle Event Packages (Big Boxes, Small Boxes, Treasure Chests)
/// Uses Firebase Realtime Database
class EventService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Singleton pattern
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  DatabaseReference get _eventsRef => _db.ref('events');

  // ===========================================================================
  // READ METHODS (Streams)
  // ===========================================================================

  /// Stream of all Event Categories (Big Boxes)
  /// e.g., Wedding, Corporate, Party
  Stream<List<EventCategory>> getEventCategoriesStream() {
    // We order by 'order' in the query, but we also sort client-side to be sure
    return _eventsRef.orderByChild('order').onValue.map((event) {
      if (event.snapshot.value == null) return [];

      try {
        final data = event.snapshot.value;
        List<EventCategory> categories = [];

        if (data is Map) {
          categories = data.values.map((e) {
            return EventCategory.fromJson(Map<String, dynamic>.from(e as Map));
          }).toList();
        } else if (data is List) {
           // Should not happen with push() IDs but handling list structure just in case
           for (var item in data) {
             if (item != null) {
               categories.add(EventCategory.fromJson(Map<String, dynamic>.from(item as Map)));
             }
           }
        }
        
        // 1. Sort Categories by Order
        categories.sort((a, b) => a.order.compareTo(b.order));

        // 2. Sort Sub-Categories by Order inside each Category
        for (var cat in categories) {
          cat.subCategories.sort((a, b) => a.order.compareTo(b.order));
        }

        return categories;
      } catch (e) {
        print('Error parsing event categories: $e');
        return [];
      }
    });
  }

  /// Get a single Event Category by ID
  Future<EventCategory?> getEventCategory(String id) async {
    final snapshot = await _eventsRef.child(id).get();
    if (snapshot.value != null) {
      final category = EventCategory.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      // Sort sub-categories by order to ensure tabs are correct
      category.subCategories.sort((a, b) => a.order.compareTo(b.order));
      return category;
    }
    return null;
  }

  // ===========================================================================
  // WRITE METHODS (The Admin's Magic Wand)
  // ===========================================================================

  /// Create or Update a Big Box (Event Category)
  /// This saves the ENTIRE tree (Sub-categories and Packages included)
  Future<void> saveEventCategory(EventCategory category) async {
    await _eventsRef.child(category.id).set(category.toJson());
  }

  /// Delete a Big Box
  Future<void> deleteEventCategory(String id) async {
    await _eventsRef.child(id).remove();
  }

  /// Toggle Visibility (Show/Hide Switch)
  Future<void> toggleCategoryStatus(String id, bool isActive) async {
    await _eventsRef.child(id).update({'status': isActive ? 'active' : 'inactive'});
  }

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  /// Seed initial data from hardcoded file (One-time setup for Admin)
  Future<void> seedInitialData(List<EventCategory> categories) async {
    final Map<String, dynamic> updates = {};
    for (var cat in categories) {
      updates[cat.id] = cat.toJson();
    }
    await _eventsRef.update(updates);
  }
}
