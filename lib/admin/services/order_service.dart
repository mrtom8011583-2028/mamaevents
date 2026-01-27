import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/database_service.dart';
import '../models/order_model.dart';
import '../models/activity_log_model.dart';
import 'activity_log_service.dart';

/// Order Service - Enterprise Order Management
/// Handles all order CRUD operations with automatic activity logging
class OrderService {
  final DatabaseService _dbService = DatabaseService();
  final ActivityLogService _activityLog = ActivityLogService();
  
  // RTDB reference
  DatabaseReference get _ordersRef => FirebaseDatabase.instance.ref('orders');

  /// Create a new order from a quote
  Future<String> createOrder({
    required String quoteId,
    required String customerId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String eventType,
    required String eventLocation,
    required DateTime eventDate,
    required int guestCount,
    required double totalAmount,
    required String currency,
    required String region,
    required List<String> services,
    String? notes,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      final now = DateTime.now();
      
      // Generate order ID
      final orderId = 'ORD-${region.substring(0, 3).toUpperCase()}-${now.millisecondsSinceEpoch}';
      
      final order = Order(
        orderId: orderId,
        quoteId: quoteId,
        customerId: customerId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        eventType: eventType,
        eventLocation: eventLocation,
        eventDate: eventDate,
        guestCount: guestCount,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.pending,
        totalAmount: totalAmount,
        currency: currency,
        paidAmount: 0,
        balanceAmount: totalAmount,
        region: region,
        orderDate: now,
        services: services,
        notes: notes,
        timeline: [
          OrderTimelineItem(
            status: OrderStatus.pending,
            timestamp: now,
            performedBy: currentUser.email ?? '',
            note: 'Order created from quote',
          ),
        ],
        createdAt: now,
        updatedAt: now,
        createdBy: currentUser.email ?? '',
      );

      // Save to RTDB
      await _ordersRef.child(orderId).set(order.toJson());

      // Log activity
      await _activityLog.log(
        ActivityLog.create(
          action: ActivityAction.orderCreated,
          performedBy: currentUser.uid,
          performedByName: currentUser.email ?? '',
          entityType: 'order',
          entityId: orderId,
          entityName: '$customerName - $eventType',
          note: 'Order created from quote $quoteId',
          relatedEntityType: 'quote',
          relatedEntityId: quoteId,
        ),
      );

      return orderId;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Get order by ID
  Future<Order?> getOrder(String orderId) async {
    try {
      final snapshot = await _ordersRef.child(orderId).get();
      if (snapshot.exists) {
        return Order.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  /// Get all orders (with optional filters)
  Stream<List<Order>> getOrders({
    String? region,
    OrderStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) {
    return _dbService.getOrdersStream().map((list) {
      var orders = list.map((m) => Order.fromJson(m)).toList();
      
      if (region != null && region != 'All') {
        orders = orders.where((o) => o.region.toLowerCase() == region.toLowerCase()).toList();
      }
      
      if (status != null) {
        orders = orders.where((o) => o.status == status).toList();
      }
      
      // Additional Date filtering if needed...
      
      return orders.take(limit).toList();
    });
  }

  /// Update order status
  Future<void> updateStatus({
    required String orderId,
    required OrderStatus newStatus,
    String? note,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      final order = await getOrder(orderId);
      if (order == null) throw Exception('Order not found');

      final now = DateTime.now();
      
      // Create new timeline item
      final timelineItem = OrderTimelineItem(
        status: newStatus,
        timestamp: now,
        performedBy: currentUser.email ?? '',
        note: note,
      );

      // Update order
      final updatedOrder = order.copyWith(
        status: newStatus,
        timeline: [...order.timeline, timelineItem],
        lastUpdatedBy: currentUser.email,
      );

      await _ordersRef.child(orderId).update(updatedOrder.toJson());

      // Log activity
      await _activityLog.log(
        ActivityLog.create(
          action: ActivityAction.statusChanged,
          performedBy: currentUser.uid,
          performedByName: currentUser.email ?? '',
          entityType: 'order',
          entityId: orderId,
          entityName: '${order.customerName} - ${order.eventType}',
          changesBefore: {'status': order.status.value},
          changesAfter: {'status': newStatus.value},
          note: note,
        ),
      );
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }

  /// Record payment
  Future<void> recordPayment({
    required String orderId,
    required double amount,
    String? note,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      final order = await getOrder(orderId);
      if (order == null) throw Exception('Order not found');

      final newPaidAmount = order.paidAmount + amount;
      final newBalance = order.totalAmount - newPaidAmount;
      
      PaymentStatus newPaymentStatus;
      if (newBalance <= 0) {
        newPaymentStatus = PaymentStatus.paid;
      } else if (newPaidAmount > 0) {
        newPaymentStatus = PaymentStatus.partial;
      } else {
        newPaymentStatus = PaymentStatus.pending;
      }

      final updatedOrder = order.copyWith(
        paidAmount: newPaidAmount,
        balanceAmount: newBalance,
        paymentStatus: newPaymentStatus,
        lastUpdatedBy: currentUser.email,
      );

      await _ordersRef.child(orderId).update(updatedOrder.toJson());

      // Log activity
      await _activityLog.log(
        ActivityLog.create(
          action: ActivityAction.paymentReceived,
          performedBy: currentUser.uid,
          performedByName: currentUser.email ?? '',
          entityType: 'order',
          entityId: orderId,
          entityName: '${order.customerName} - ${order.eventType}',
          changesBefore: {
            'paidAmount': order.paidAmount,
            'balanceAmount': order.balanceAmount,
            'paymentStatus': order.paymentStatus.value,
          },
          changesAfter: {
            'paidAmount': newPaidAmount,
            'balanceAmount': newBalance,
            'paymentStatus': newPaymentStatus.value,
          },
          note: note ?? 'Payment of ${order.currency} $amount received',
        ),
      );
    } catch (e) {
      throw Exception('Failed to record payment: $e');
    }
  }

  /// Add note to order
  Future<void> addNote({
    required String orderId,
    required String note,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      final order = await getOrder(orderId);
      if (order == null) throw Exception('Order not found');

      final existingNotes = order.notes ?? '';
      final newNotes = existingNotes.isEmpty 
        ? note 
        : '$existingNotes\n\n--- ${DateTime.now().toString().split('.')[0]} ---\n$note';

      await _ordersRef.child(orderId).update({'notes': newNotes});

      // Log activity
      await _activityLog.log(
        ActivityLog.create(
          action: ActivityAction.noteAdded,
          performedBy: currentUser.uid,
          performedByName: currentUser.email ?? '',
          entityType: 'order',
          entityId: orderId,
          entityName: '${order.customerName} - ${order.eventType}',
          note: note,
        ),
      );
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  /// Assign order to staff
  Future<void> assignStaff({
    required String orderId,
    required String staffEmail,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      final order = await getOrder(orderId);
      if (order == null) throw Exception('Order not found');

      await _ordersRef.child(orderId).update({
        'assignedTo': staffEmail,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
        'lastUpdatedBy': currentUser.email,
      });

      // Log activity
      await _activityLog.log(
        ActivityLog.create(
          action: ActivityAction.orderUpdated,
          performedBy: currentUser.uid,
          performedByName: currentUser.email ?? '',
          entityType: 'order',
          entityId: orderId,
          entityName: '${order.customerName} - ${order.eventType}',
          note: 'Assigned to $staffEmail',
        ),
      );
    } catch (e) {
      throw Exception('Failed to assign staff: $e');
    }
  }

  /// Cancel order
  Future<void> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('Not authenticated');

      await updateStatus(
        orderId: orderId,
        newStatus: OrderStatus.cancelled,
        note: 'Cancelled: $reason',
      );

      // Log activity 
      final order = await getOrder(orderId);
      await _activityLog.log(
        ActivityLog.create(
          action: ActivityAction.orderCancelled,
          performedBy: currentUser.uid,
          performedByName: currentUser.email ?? '',
          entityType: 'order',
          entityId: orderId,
          entityName: order != null ? '${order.customerName} - ${order.eventType}' : orderId,
          note: reason,
        ),
      );
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  /// Get order statistics
  Future<Map<String, int>> getOrderStats() async {
    try {
      final snapshot = await _ordersRef.get();
      if (!snapshot.exists) return {'total': 0};
      
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final orders = data.values.map((e) => Order.fromJson(Map<String, dynamic>.from(e))).toList();

      return {
        'total': orders.length,
        'pending': orders.where((o) => o.status == OrderStatus.pending).length,
        'confirmed': orders.where((o) => o.status == OrderStatus.confirmed).length,
        'preparing': orders.where((o) => o.status == OrderStatus.preparing).length,
        'completed': orders.where((o) => o.status == OrderStatus.completed).length,
        'cancelled': orders.where((o) => o.status == OrderStatus.cancelled).length,
      };
    } catch (e) {
      throw Exception('Failed to get stats: $e');
    }
  }
}
