import 'package:cloud_firestore/cloud_firestore.dart';

/// Testimonial/Review model
class Testimonial {
  final String id;
  final String clientName;
  final String clientTitle;
  final double rating;
  final String comment;
  final String eventType;
  final String? imageUrl;
  final String region;
  final DateTime createdAt;
  final bool isApproved;

  Testimonial({
    required this.id,
    required this.clientName,
    required this.clientTitle,
    required this.rating,
    required this.comment,
    required this.eventType,
    this.imageUrl,
    required this.region,
    required this.createdAt,
    this.isApproved = false,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] ?? '',
      clientName: json['clientName'] ?? '',
      clientTitle: json['clientTitle'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      eventType: json['eventType'] ?? '',
      imageUrl: json['imageUrl'],
      region: json['region'] ?? 'PK',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isApproved: json['isApproved'] ?? false,
    );
  }

  factory Testimonial.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Testimonial.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'clientTitle': clientTitle,
      'rating': rating,
      'comment': comment,
      'eventType': eventType,
      'imageUrl': imageUrl,
      'region': region,
      'createdAt': Timestamp.fromDate(createdAt),
      'isApproved': isApproved,
    };
  }

  /// Get star representation
  String get stars => '⭐' * rating.round();
}
