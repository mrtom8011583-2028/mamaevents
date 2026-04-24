import 'package:firebase_database/firebase_database.dart';
import '../models/notification_model.dart';
import 'package:flutter/foundation.dart';

/// Notification Service
/// Handles admin notifications system (Refactored to Realtime Database)
class NotificationService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  
  DatabaseReference get _notificationsRef =>
      _db.ref('admin_notifications');

  /// Create a new notification
  Future<void> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final newRef = _notificationsRef.push();
      await newRef.set({
        'title': title,
        'message': message,
        'type': type.name,
        'timestamp': ServerValue.timestamp,
        'isRead': false,
        'actionUrl': actionUrl,
        'metadata': metadata,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error creating notification: $e');
      }
    }
  }

  /// Get all notifications stream
  Stream<List<AdminNotification>> getNotifications({int? limit}) {
    Query query = _notificationsRef.orderByChild('timestamp');
    
    if (limit != null) {
      query = query.limitToLast(limit);
    }
    
    return query.onValue.map((event) {
      if (event.snapshot.value == null) return [];
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<AdminNotification> notifications = [];
      
      data.forEach((key, value) {
        final map = Map<String, dynamic>.from(value as Map);
        map['id'] = key;
        notifications.add(AdminNotification.fromMap(map));
      });
      
      // Sort descending (newest first)
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return notifications;
    });
  }

  /// Get unread notifications count
  Stream<int> getUnreadCount() {
    return _notificationsRef.orderByChild('isRead').equalTo(false).onValue.map((event) {
      if (event.snapshot.value == null) return 0;
      return event.snapshot.children.length; // Count children
    });
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.child(notificationId).update({
      'isRead': true,
    });
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    final snapshot = await _notificationsRef.orderByChild('isRead').equalTo(false).get();
    if (snapshot.exists) {
      final Map<String, dynamic> updates = {};
      for (var child in snapshot.children) {
        updates['/${child.key}/isRead'] = true;
      }
      await _notificationsRef.update(updates);
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.child(notificationId).remove();
  }

  /// Auto-create notifications for new quotes
  Future<void> notifyNewQuote(String quoteId, String customerName) async {
    await createNotification(
      title: 'New Quote Request',
      message: 'Quote request from $customerName',
      type: NotificationType.newQuote,
      actionUrl: '/admin?highlight=$quoteId',
      metadata: {'quoteId': quoteId},
    );
  }

  /// Auto-create notifications for new orders
  Future<void> notifyNewOrder(String orderId, String customerName) async {
    await createNotification(
      title: 'New Order',
      message: 'New order from $customerName',
      type: NotificationType.newOrder,
      actionUrl: '/admin/orders?highlight=$orderId',
      metadata: {'orderId': orderId},
    );
  }

  /// Auto-create notifications for payments
  Future<void> notifyPayment(String orderId, double amount, String currency) async {
    await createNotification(
      title: 'Payment Received',
      message: 'Payment of $currency $amount received for order $orderId',
      type: NotificationType.payment,
      actionUrl: '/admin/orders?highlight=$orderId',
      metadata: {'orderId': orderId, 'amount': amount},
    );
  }
}
