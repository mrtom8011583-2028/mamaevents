import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

/// Notification Service
/// Handles admin notifications system
class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _notificationsCollection =>
      _firestore.collection('admin_notifications');

  /// Create a new notification
  Future<void> createNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) async {
    await _notificationsCollection.add({
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'actionUrl': actionUrl,
      'metadata': metadata,
    });
  }

  /// Get all notifications stream
  Stream<List<AdminNotification>> getNotifications({int? limit}) {
    Query query = _notificationsCollection
        .orderBy('timestamp', descending: true);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AdminNotification.fromFirestore(doc))
          .toList();
    });
  }

  /// Get unread notifications count
  Stream<int> getUnreadCount() {
    return _notificationsCollection
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationsCollection.doc(notificationId).update({
      'isRead': true,
    });
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    final batch = _firestore.batch();
    final unreadDocs = await _notificationsCollection
        .where('isRead', isEqualTo: false)
        .get();
    
    for (var doc in unreadDocs.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    
    await batch.commit();
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsCollection.doc(notificationId).delete();
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
