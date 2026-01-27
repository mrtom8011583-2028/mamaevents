import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';
import '../models/region.dart';
import '../../config/constants/api_constants.dart';

/// Service for managing menu items from Firestore
class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all menu items for a specific region
  Future<List<MenuItem>> getMenuByRegion(Region region) async {
    try {
      final snapshot = await _firestore
          .collection(ApiConstants.menusCollection)
          .doc(region.code.toLowerCase())
          .collection('items')
          .where('available', isEqualTo: true)
          .orderBy('category')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MenuItem.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Error fetching menu: $e');
      return [];
    }
  }

  /// Get menu items by category
  Future<List<MenuItem>> getMenuByCategory(Region region, String category) async {
    try {
      final snapshot = await _firestore
          .collection(ApiConstants.menusCollection)
          .doc(region.code.toLowerCase())
          .collection('items')
          .where('category', isEqualTo: category)
          .where('available', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MenuItem.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Error fetching menu by category: $e');
      return [];
    }
  }

  /// Get single menu item by ID
  Future<MenuItem?> getMenuItemById(Region region, String itemId) async {
    try {
      final doc = await _firestore
          .collection(ApiConstants.menusCollection)
          .doc(region.code.toLowerCase())
          .collection('items')
          .doc(itemId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        return MenuItem.fromJson({...data, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching menu item: $e');
      return null;
    }
  }

  /// Get all categories for a region
  Future<List<String>> getCategories(Region region) async {
    try {
      final snapshot = await _firestore
          .collection(ApiConstants.menusCollection)
          .doc(region.code.toLowerCase())
          .collection('items')
          .where('available', isEqualTo: true)
          .get();

      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc.data()['category'] as String?;
        if (category != null) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  /// Stream menu items (for real-time updates)
  Stream<List<MenuItem>> streamMenuByRegion(Region region) {
    return _firestore
        .collection(ApiConstants.menusCollection)
        .doc(region.code.toLowerCase())
        .collection('items')
        .where('available', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MenuItem.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }
}
