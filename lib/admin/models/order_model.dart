import 'package:cloud_firestore/cloud_firestore.dart';

/// Order Model - Enterprise Event Management
/// Represents a confirmed order/booking for an event
class Order {
  final String orderId;
  final String quoteId;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  
  final String eventType;
  final String eventLocation;
  final DateTime eventDate;
  final int guestCount;
  
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  
  final double totalAmount;
  final String currency; // PKR
  final double paidAmount;
  final double balanceAmount;
  
  final String region; // Pakistan
  final DateTime orderDate;
  final DateTime? deliveryDate;
  
  final List<OrderTimelineItem> timeline;
  final List<String> services; // What's included
  final String? notes;
  final String? assignedTo; // Staff member
  
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? lastUpdatedBy;

  Order({
    required this.orderId,
    required this.quoteId,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.eventType,
    required this.eventLocation,
    required this.eventDate,
    required this.guestCount,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.currency,
    this.paidAmount = 0,
    required this.balanceAmount,
    required this.region,
    required this.orderDate,
    this.deliveryDate,
    this.timeline = const [],
    this.services = const [],
    this.notes,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.lastUpdatedBy,
  });

  // Calculate payment percentage
  double get paymentPercentage => 
    totalAmount > 0 ? (paidAmount / totalAmount) * 100 : 0;

  // Check if overdue
  bool get isOverdue =>
    deliveryDate != null && 
    DateTime.now().isAfter(deliveryDate!) &&
    status != OrderStatus.completed &&
    status != OrderStatus.cancelled;

  // From Firestore
  factory Order.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      orderId: doc.id,
      quoteId: data['quoteId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      eventType: data['eventType'] ?? '',
      eventLocation: data['eventLocation'] ?? '',
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      guestCount: data['guestCount'] ?? 0,
      status: OrderStatus.fromString(data['status'] ?? 'pending'),
      paymentStatus: PaymentStatus.fromString(data['paymentStatus'] ?? 'pending'),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'PKR',
      paidAmount: (data['paidAmount'] ?? 0).toDouble(),
      balanceAmount: (data['balanceAmount'] ?? 0).toDouble(),
      region: data['region'] ?? 'Pakistan',
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      deliveryDate: data['deliveryDate'] != null 
        ? (data['deliveryDate'] as Timestamp).toDate() 
        : null,
      timeline: (data['timeline'] as List<dynamic>?)
        ?.map((item) => OrderTimelineItem.fromMap(item))
        .toList() ?? [],
      services: List<String>.from(data['services'] ?? []),
      notes: data['notes'],
      assignedTo: data['assignedTo'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      lastUpdatedBy: data['lastUpdatedBy'],
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'quoteId': quoteId,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'eventType': eventType,
      'eventLocation': eventLocation,
      'eventDate': Timestamp.fromDate(eventDate),
      'guestCount': guestCount,
      'status': status.value,
      'paymentStatus': paymentStatus.value,
      'totalAmount': totalAmount,
      'currency': currency,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'region': region,
      'orderDate': Timestamp.fromDate(orderDate),
      'deliveryDate': deliveryDate != null 
        ? Timestamp.fromDate(deliveryDate!) 
        : null,
      'timeline': timeline.map((item) => item.toMap()).toList(),
      'services': services,
      'notes': notes,
      'assignedTo': assignedTo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'lastUpdatedBy': lastUpdatedBy,
    };
  }

  // From RTDB (JSON)
  factory Order.fromJson(Map<String, dynamic> data) {
    return Order(
      orderId: data['id'] ?? data['orderId'] ?? '',
      quoteId: data['quoteId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerEmail: data['customerEmail'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      eventType: data['eventType'] ?? '',
      eventLocation: data['eventLocation'] ?? '',
      eventDate: DateTime.fromMillisecondsSinceEpoch(data['eventDate'] ?? 0),
      guestCount: data['guestCount'] ?? 0,
      status: OrderStatus.fromString(data['status'] ?? 'pending'),
      paymentStatus: PaymentStatus.fromString(data['paymentStatus'] ?? 'pending'),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'PKR',
      paidAmount: (data['paidAmount'] ?? 0).toDouble(),
      balanceAmount: (data['balanceAmount'] ?? 0).toDouble(),
      region: data['region'] ?? 'Pakistan',
      orderDate: DateTime.fromMillisecondsSinceEpoch(data['orderDate'] ?? DateTime.now().millisecondsSinceEpoch),
      deliveryDate: data['deliveryDate'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(data['deliveryDate']) 
        : null,
      timeline: (data['timeline'] as List<dynamic>?)
        ?.map((item) => OrderTimelineItem.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? [],
      services: List<String>.from(data['services'] ?? []),
      notes: data['notes'],
      assignedTo: data['assignedTo'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
      createdBy: data['createdBy'] ?? '',
      lastUpdatedBy: data['lastUpdatedBy'],
    );
  }

  // To RTDB (JSON)
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'quoteId': quoteId,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'eventType': eventType,
      'eventLocation': eventLocation,
      'eventDate': eventDate.millisecondsSinceEpoch,
      'guestCount': guestCount,
      'status': status.value,
      'paymentStatus': paymentStatus.value,
      'totalAmount': totalAmount,
      'currency': currency,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'region': region,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'deliveryDate': deliveryDate?.millisecondsSinceEpoch,
      'timeline': timeline.map((item) => item.toJson()).toList(),
      'services': services,
      'notes': notes,
      'assignedTo': assignedTo,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'lastUpdatedBy': lastUpdatedBy,
    };
  }

  // Copy with
  Order copyWith({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    double? paidAmount,
    double? balanceAmount,
    DateTime? deliveryDate,
    List<OrderTimelineItem>? timeline,
    String? notes,
    String? assignedTo,
    String? lastUpdatedBy,
  }) {
    return Order(
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
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount,
      currency: currency,
      paidAmount: paidAmount ?? this.paidAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      region: region,
      orderDate: orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      timeline: timeline ?? this.timeline,
      services: services,
      notes: notes ?? this.notes,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      createdBy: createdBy,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }
}

/// Order Status Enum
enum OrderStatus {
  pending('pending', 'Pending', '⏳'),
  confirmed('confirmed', 'Confirmed', '✅'),
  preparing('preparing', 'Preparing', '🔄'),
  ready('ready', 'Ready', '📦'),
  inTransit('in_transit', 'In Transit', '🚚'),
  delivered('delivered', 'Delivered', '🎉'),
  completed('completed', 'Completed', '✔️'),
  cancelled('cancelled', 'Cancelled', '❌');

  final String value;
  final String label;
  final String icon;

  const OrderStatus(this.value, this.label, this.icon);

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Payment Status Enum
enum PaymentStatus {
  pending('pending', 'Pending', '⏳'),
  partial('partial', 'Partial', '💰'),
  paid('paid', 'Paid', '✅'),
  refunded('refunded', 'Refunded', '↩️');

  final String value;
  final String label;
  final String icon;

  const PaymentStatus(this.value, this.label, this.icon);

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

/// Order Timeline Item
class OrderTimelineItem {
  final OrderStatus status;
  final DateTime timestamp;
  final String performedBy;
  final String? note;

  OrderTimelineItem({
    required this.status,
    required this.timestamp,
    required this.performedBy,
    this.note,
  });

  factory OrderTimelineItem.fromMap(Map<String, dynamic> map) {
    return OrderTimelineItem(
      status: OrderStatus.fromString(map['status'] ?? 'pending'),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      performedBy: map['performedBy'] ?? '',
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.value,
      'timestamp': Timestamp.fromDate(timestamp),
      'performedBy': performedBy,
      'note': note,
    };
  }

  factory OrderTimelineItem.fromJson(Map<String, dynamic> map) {
    return OrderTimelineItem(
      status: OrderStatus.fromString(map['status'] ?? 'pending'),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      performedBy: map['performedBy'] ?? '',
      note: map['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'performedBy': performedBy,
      'note': note,
    };
  }
}
