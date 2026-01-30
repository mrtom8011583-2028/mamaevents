
/// Activity Log Model - Track all admin actions
/// Enterprise audit trail for compliance and tracking
class ActivityLog {
  final String logId;
  final ActivityAction action;
  final String performedBy;
  final String performedByName;
  
  final String entityType; // 'order', 'quote', 'customer', 'payment'
  final String entityId;
  final String entityName; // Human-readable reference
  
  final Map<String, dynamic>? changesBefore;
  final Map<String, dynamic>? changesAfter;
  
  final String? note;
  final String ipAddress;
  final DateTime timestamp;
  
  final String? relatedEntityType;
  final String? relatedEntityId;

  ActivityLog({
    required this.logId,
    required this.action,
    required this.performedBy,
    required this.performedByName,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    this.changesBefore,
    this.changesAfter,
    this.note,
    this.ipAddress = '',
    required this.timestamp,
    this.relatedEntityType,
    this.relatedEntityId,
  });

  // Get action description
  String get description {
    switch (action) {
      case ActivityAction.orderCreated:
        return 'Created order';
      case ActivityAction.orderUpdated:
        return 'Updated order';
      case ActivityAction.orderCancelled:
        return 'Cancelled order';
      case ActivityAction.statusChanged:
        return 'Changed status';
      case ActivityAction.paymentReceived:
        return 'Payment received';
      case ActivityAction.quoteCreated:
        return 'Created quote';
      case ActivityAction.quoteUpdated:
        return 'Updated quote';
      case ActivityAction.quoteSent:
        return 'Sent quote to customer';
      case ActivityAction.customerAdded:
        return 'Added customer';
      case ActivityAction.customerUpdated:
        return 'Updated customer';
      case ActivityAction.categoryCreated:
        return 'Created event category';
      case ActivityAction.categoryUpdated:
        return 'Updated event category';
      case ActivityAction.categoryDeleted:
        return 'Deleted event category';
      case ActivityAction.subCategoryCreated:
        return 'Created sub-category';
      case ActivityAction.subCategoryUpdated:
        return 'Updated sub-category';
      case ActivityAction.subCategoryDeleted:
        return 'Deleted sub-category';
      case ActivityAction.packageCreated:
        return 'Created package';
      case ActivityAction.packageUpdated:
        return 'Updated package';
      case ActivityAction.packageDeleted:
        return 'Deleted package';
      case ActivityAction.noteAdded:
        return 'Added note';
      case ActivityAction.fileUploaded:
        return 'Uploaded file';
      case ActivityAction.emailSent:
        return 'Sent email';
      case ActivityAction.login:
        return 'Logged in';
      case ActivityAction.logout:
        return 'Logged out';
      default:
        return 'Performed action';
    }
  }

  // Get detailed message
  String get message {
    if (note != null && note!.isNotEmpty) {
      return note!;
    }
    
    String msg = '$performedByName $description';
    
    if (changesBefore != null && changesAfter != null) {
      // Show key changes
      if (changesBefore!['status'] != changesAfter!['status']) {
        msg += ' from ${changesBefore!['status']} to ${changesAfter!['status']}';
      }
    }
    
    return msg;
  }

  // From Firestore (Keep for compatibility, use dynamic)
  factory ActivityLog.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLog.fromJson(data, id: (doc as dynamic).id);
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  // From JSON (RTDB)
  factory ActivityLog.fromJson(Map<String, dynamic> json, {String? id}) {
    return ActivityLog(
      logId: id ?? json['logId'] ?? '',
      action: ActivityAction.fromString(json['action'] ?? ''),
      performedBy: json['performedBy'] ?? '',
      performedByName: json['performedByName'] ?? '',
      entityType: json['entityType'] ?? '',
      entityId: json['entityId'] ?? '',
      entityName: json['entityName'] ?? '',
      changesBefore: json['changesBefore'] != null ? Map<String, dynamic>.from(json['changesBefore'] as Map) : null,
      changesAfter: json['changesAfter'] != null ? Map<String, dynamic>.from(json['changesAfter'] as Map) : null,
      note: json['note'],
      ipAddress: json['ipAddress'] ?? '',
      timestamp: json['timestamp'] is int 
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
          : (json['timestamp'] != null && json['timestamp'].runtimeType.toString().contains('Timestamp')
              ? (json['timestamp'] as dynamic).toDate() 
              : DateTime.now()),
      relatedEntityType: json['relatedEntityType'],
      relatedEntityId: json['relatedEntityId'],
    );
  }

  // To JSON (RTDB)
  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'action': action.value,
      'performedBy': performedBy,
      'performedByName': performedByName,
      'entityType': entityType,
      'entityId': entityId,
      'entityName': entityName,
      'changesBefore': changesBefore,
      'changesAfter': changesAfter,
      'note': note,
      'ipAddress': ipAddress,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'relatedEntityType': relatedEntityType,
      'relatedEntityId': relatedEntityId,
    };
  }

  // Factory for creating logs easily
  factory ActivityLog.create({
    required ActivityAction action,
    required String performedBy,
    required String performedByName,
    required String entityType,
    required String entityId,
    required String entityName,
    Map<String, dynamic>? changesBefore,
    Map<String, dynamic>? changesAfter,
    String? note,
    String? relatedEntityType,
    String? relatedEntityId,
  }) {
    return ActivityLog(
      logId: '', // Will be set by Firestore
      action: action,
      performedBy: performedBy,
      performedByName: performedByName,
      entityType: entityType,
      entityId: entityId,
      entityName: entityName,
      changesBefore: changesBefore,
      changesAfter: changesAfter,
      note: note,
      timestamp: DateTime.now(),
      relatedEntityType: relatedEntityType,
      relatedEntityId: relatedEntityId,
    );
  }
}

/// Activity Action Enum
enum ActivityAction {
  // Order actions
  orderCreated('order_created', 'Created Order', '➕'),
  orderUpdated('order_updated', 'Updated Order', '✏️'),
  orderCancelled('order_cancelled', 'Cancelled Order', '❌'),
  statusChanged('status_changed', 'Status Changed', '🔄'),
  
  // Payment actions
  paymentReceived('payment_received', 'Payment Received', '💰'),
  paymentRefunded('payment_refunded', 'Payment Refunded', '↩️'),
  
  // Quote actions
  quoteCreated('quote_created', 'Created Quote', '📝'),
  quoteUpdated('quote_updated', 'Updated Quote', '✏️'),
  quoteSent('quote_sent', 'Sent Quote', '📧'),
  quoteAccepted('quote_accepted', 'Quote Accepted', '✅'),
  quoteRejected('quote_rejected', 'Quote Rejected', '❌'),
  
  // Customer actions
  customerAdded('customer_added', 'Added Customer', '👤'),
  customerUpdated('customer_updated', 'Updated Customer', '✏️'),
  
  // General actions
  noteAdded('note_added', 'Added Note', '📌'),
  fileUploaded('file_uploaded', 'Uploaded File', '📎'),
  emailSent('email_sent', 'Sent Email', '📧'),
  smsSent('sms_sent', 'Sent SMS', '💬'),
  
  // Event Management actions
  categoryCreated('category_created', 'Created Category', '📁'),
  categoryUpdated('category_updated', 'Updated Category', '✏️'),
  categoryDeleted('category_deleted', 'Deleted Category', '🗑️'),
  subCategoryCreated('subcategory_created', 'Created Sub-Category', '📂'),
  subCategoryUpdated('subcategory_updated', 'Updated Sub-Category', '✏️'),
  subCategoryDeleted('subcategory_deleted', 'Deleted Sub-Category', '🗑️'),
  packageCreated('package_created', 'Created Package', '📦'),
  packageUpdated('package_updated', 'Updated Package', '✏️'),
  packageDeleted('package_deleted', 'Deleted Package', '🗑️'),
  
  // System actions
  login('login', 'Logged In', '🔓'),
  logout('logout', 'Logged Out', '🔒'),
  settingsChanged('settings_changed', 'Changed Settings', '⚙️');

  final String value;
  final String label;
  final String icon;

  const ActivityAction(this.value, this.label, this.icon);

  static ActivityAction fromString(String value) {
    return ActivityAction.values.firstWhere(
      (action) => action.value == value,
      orElse: () => ActivityAction.noteAdded,
    );
  }
}

/// Activity Log Filter
class ActivityLogFilter {
  final String? entityType;
  final String? performedBy;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ActivityAction>? actions;

  ActivityLogFilter({
    this.entityType,
    this.performedBy,
    this.startDate,
    this.endDate,
    this.actions,
  });
}
