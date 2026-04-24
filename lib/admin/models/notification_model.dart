import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification Model
class AdminNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
  });

  factory AdminNotification.fromMap(Map<String, dynamic> data) {
    return AdminNotification(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => NotificationType.info,
      ),
      timestamp: data['timestamp'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int)
          : DateTime.now(),
      isRead: data['isRead'] ?? false,
      actionUrl: data['actionUrl'],
      metadata: data['metadata'] != null ? Map<String, dynamic>.from(data['metadata']) : null,
    );
  }

  factory AdminNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id; // Ensure ID is passed
    return AdminNotification.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'actionUrl': actionUrl,
      'metadata': metadata,
    };
  }
}

enum NotificationType {
  newQuote('🆕', 'New Quote'),
  newOrder('📦', 'New Order'),
  payment('💰', 'Payment'),
  statusChange('🔄', 'Status Change'),
  reminder('⏰', 'Reminder'),
  alert('⚠️', 'Alert'),
  info('ℹ️', 'Info');

  final String icon;
  final String label;
  const NotificationType(this.icon, this.label);
}
