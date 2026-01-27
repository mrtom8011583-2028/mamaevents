import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/menu_item.dart';
import '../models/add_on.dart';

class DatabaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  DatabaseReference get eventsRef => _eventsRef;
  DatabaseReference get liveStationsRef => _liveStationsRef;
  DatabaseReference get menuItemsRef => _menuItemsRef;
  DatabaseReference get ordersRef => _ordersRef;
  DatabaseReference get quotesRef => _quotesRef;
  DatabaseReference get addOnsRef => _addOnsRef;

  DatabaseReference get _eventsRef => _db.ref('events');
  DatabaseReference get _liveStationsRef => _db.ref('live_stations');
  DatabaseReference get _menuItemsRef => _db.ref('menu_items');
  DatabaseReference get _ordersRef => _db.ref('orders');
  DatabaseReference get _quotesRef => _db.ref('quote_requests');
  DatabaseReference get _addOnsRef => _db.ref('addOns');

  // ===========================================================================
  // READ METHODS (Streams)
  // ===========================================================================

  /// Stream of all quotes
  Stream<List<Map<String, dynamic>>> getQuotesStream() {
    return _quotesRef.orderByChild('createdAt').onValue.map((event) {
      if (event.snapshot.value == null) return [];
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Map<String, dynamic>> quotes = [];
      data.forEach((key, value) {
        final quoteMap = Map<String, dynamic>.from(value as Map);
        // Ensure ID is included if not present (though we usually save it)
        quoteMap['id'] ??= key;
        quotes.add(quoteMap);
      });
      // Sort client-side since map order isn't guaranteed
      quotes.sort((a, b) {
        // Handle timestamps that might be strings or numbers
        var timeA = a['createdAt'];
        var timeB = b['createdAt'];
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeB.compareTo(timeA); // Descending
      });
      return quotes;
    });
  }

  /// Stream of all menu items
  Stream<List<MenuItem>> getMenuItemsStream() {
    return _menuItemsRef.onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.values.map((e) {
        return MenuItem.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    });
  }

  /// Stream of specific orders (e.g. pending)
  Stream<List<Map<String, dynamic>>> getPendingOrdersStream() {
    return _ordersRef.orderByChild('status').equalTo('pending').onValue.map((event) {
      if (event.snapshot.value == null) return [];
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Map<String, dynamic>> orders = [];
      data.forEach((key, value) {
        orders.add(Map<String, dynamic>.from(value));
      });
      return orders;
    });
  }

  /// Stream of ALL orders
  Stream<List<Map<String, dynamic>>> getOrdersStream() {
    return _ordersRef.orderByChild('createdAt').onValue.map((event) {
      if (event.snapshot.value == null) return [];
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Map<String, dynamic>> orders = [];
      data.forEach((key, value) {
        final order = Map<String, dynamic>.from(value as Map);
        order['id'] ??= key;
        orders.add(order);
      });
      
      // Client-side sort desc by createdAt
      orders.sort((a, b) {
        final tA = a['createdAt'];
        final tB = b['createdAt'];
        if (tA == null) return 1;
        if (tB == null) return -1;
        return tB.compareTo(tA);
      });
      
      return orders;
    });
  }

  /// Create or Update a Menu Item
  Future<void> updateMenuItem(MenuItem item) async {
    await _menuItemsRef.child(item.id).set(item.toJson());
  }

  /// Delete a Menu Item
  Future<void> deleteMenuItem(String id) async {
    await _menuItemsRef.child(id).remove();
  }

  Future<void> submitOrder(Map<String, dynamic> orderData) async {
    final newOrderRef = _ordersRef.push();
    await newOrderRef.set({
      ...orderData,
      'id': newOrderRef.key,
      'createdAt': ServerValue.timestamp,
    });
  }

  /// Update Order Status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _ordersRef.child(orderId).update({'status': status});
  }

  /// Seeding: Upload menu items (Admin use only)
  Future<void> seedMenuItems(List<MenuItem> items) async {
    final Map<String, dynamic> updates = {};
    for (var item in items) {
      updates['menu_items/${item.id}'] = item.toJson();
    }
    await _db.ref().update(updates);
  }

  /// Submit a new quote
  Future<void> submitQuote(Map<String, dynamic> quoteData) async {
    // Generate a reference with the quoteId if provided, otherwise push new
    DatabaseReference ref;
    if (quoteData.containsKey('quoteId')) {
      ref = _quotesRef.child(quoteData['quoteId']);
    } else {
      ref = _quotesRef.push();
      quoteData['quoteId'] = ref.key;
    }

    // Ensure we have a creation timestamp
    if (quoteData['createdAt'] == null) {
      quoteData['createdAt'] = ServerValue.timestamp;
    }
    // Handle Timestamp-like objects if any (safe dynamic cast)
    if (quoteData['serviceDate'] != null && quoteData['serviceDate'].runtimeType.toString().contains('Timestamp')) {
      quoteData['serviceDate'] = (quoteData['serviceDate'] as dynamic).millisecondsSinceEpoch;
    }
    if (quoteData['eventDate'] != null && quoteData['eventDate'].runtimeType.toString().contains('Timestamp')) {
        quoteData['eventDate'] = (quoteData['eventDate'] as dynamic).millisecondsSinceEpoch;
    }

    await ref.set(quoteData);
  }

  /// Update Quote Status
  Future<void> updateQuoteStatus(String quoteId, String status) async {
    await _quotesRef.child(quoteId).update({'status': status});
  }

  /// Delete a quote
  Future<void> deleteQuote(String quoteId) async {
    await _quotesRef.child(quoteId).remove();
  }
  DatabaseReference get _contactMessagesRef => _db.ref('contact_messages');

  /// Stream of contact messages
  Stream<List<Map<String, dynamic>>> getContactMessagesStream() {
    return _contactMessagesRef.orderByChild('createdAt').onValue.map((event) {
      if (event.snapshot.value == null) return [];
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Map<String, dynamic>> messages = [];
      data.forEach((key, value) {
        final msgMap = Map<String, dynamic>.from(value as Map);
        msgMap['id'] ??= key;
        messages.add(msgMap);
      });
      // Sort desc
      messages.sort((a, b) {
        var timeA = a['createdAt'];
        var timeB = b['createdAt'];
        if (timeA == null) return 1;
        if (timeB == null) return -1;
        return timeB.compareTo(timeA);
      });
      return messages;
    });
  }

  /// Submit a new contact message
  Future<void> submitContactMessage(Map<String, dynamic> data) async {
    final ref = _contactMessagesRef.push();
    data['id'] = ref.key;
    data['createdAt'] = ServerValue.timestamp;
    data['status'] = 'unread'; // default status
    await ref.set(data);
  }

  /// Update Contact Message Status
  Future<void> updateContactMessageStatus(String id, String status) async {
    await _contactMessagesRef.child(id).update({'status': status});
  }

  /// Delete a contact message
  Future<void> deleteContactMessage(String id) async {
    await _contactMessagesRef.child(id).remove();
  }

  // ===========================================================================
  // ADD-ONS (Live Stations & Extras)
  // ===========================================================================

  /// Stream of all add-ons
  Stream<List<AddOn>> getAddOnsStream({String? categoryFilter}) {
    return _addOnsRef.onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      var addOns = data.values
          .map((e) => AddOn.fromJson(Map<String, dynamic>.from(e)))
          .where((addon) => addon.status == 'active')
          .toList();

      // Filter by category if specified
      if (categoryFilter != null && categoryFilter.isNotEmpty) {
        addOns = addOns
            .where((addon) => addon.applicableCategories.contains(categoryFilter))
            .toList();
      }

      return addOns;
    });
  }

  /// Create a new add-on
  Future<void> createAddOn(AddOn addon) async {
    final id = addon.id.isNotEmpty ? addon.id : _addOnsRef.push().key!;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final newAddOn = AddOn(
      id: id,
      name: addon.name,
      type: addon.type,
      description: addon.description,
      image: addon.image,
      priceEstimate: addon.priceEstimate,
      applicableCategories: addon.applicableCategories,
      popular: addon.popular,
      status: addon.status,
      createdAt: now,
      updatedAt: now,
    );

    await _addOnsRef.child(id).set(newAddOn.toJson());
  }

  /// Update an existing add-on
  Future<void> updateAddOn(AddOn addon) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final updatedAddOn = AddOn(
      id: addon.id,
      name: addon.name,
      type: addon.type,
      description: addon.description,
      image: addon.image,
      priceEstimate: addon.priceEstimate,
      applicableCategories: addon.applicableCategories,
      popular: addon.popular,
      status: addon.status,
      createdAt: addon.createdAt,
      updatedAt: now,
    );

    await _addOnsRef.child(addon.id).set(updatedAddOn.toJson());
  }

  /// Delete an add-on
  Future<void> deleteAddOn(String id) async {
    await _addOnsRef.child(id).remove();
  }

  /// Seed add-ons (Admin use only)
  Future<void> seedAddOns(List<AddOn> addOns) async {
    final Map<String, dynamic> updates = {};
    for (var addon in addOns) {
      updates['addOns/${addon.id}'] = addon.toJson();
    }
    await _db.ref().update(updates);
  }

}

