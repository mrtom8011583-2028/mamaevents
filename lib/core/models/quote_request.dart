import 'package:cloud_firestore/cloud_firestore.dart';

/// Quote request model for customer inquiries
class QuoteRequest {
  final String id;
  final String region;
  final String serviceType;
  final String name;
  final String email;
  final String phone;
  final int guests;
  final DateTime eventDate;
  final String? location;
  final String? budget;
  final String? dietaryRequirements;
  final String? additionalNotes;
  final String status; // 'pending', 'contacted', 'completed'
  final DateTime createdAt;

  QuoteRequest({
    required this.id,
    required this.region,
    required this.serviceType,
    required this.name,
    required this.email,
    required this.phone,
    required this.guests,
    required this.eventDate,
    this.location,
    this.budget,
    this.dietaryRequirements,
    this.additionalNotes,
    this.status = 'pending',
    required this.createdAt,
  });

  factory QuoteRequest.fromJson(Map<String, dynamic> json) {
    return QuoteRequest(
      id: json['id'] ?? '',
      region: json['region'] ?? '',
      serviceType: json['serviceType'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      guests: json['guests'] ?? 0,
      eventDate: json['eventDate'] != null
          ? (json['eventDate'] as Timestamp).toDate()
          : DateTime.now(),
      location: json['location'],
      budget: json['budget'],
      dietaryRequirements: json['dietaryRequirements'],
      additionalNotes: json['additionalNotes'],
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory QuoteRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuoteRequest.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'region': region,
      'serviceType': serviceType,
      'name': name,
      'email': email,
      'phone': phone,
      'guests': guests,
      'eventDate': Timestamp.fromDate(eventDate),
      'location': location,
      'budget': budget,
      'dietaryRequirements': dietaryRequirements,
      'additionalNotes': additionalNotes,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
