import 'package:cloud_firestore/cloud_firestore.dart';

/// Service model representing catering services
class Service {
  final String id;
  final String title;
  final String description;
  final String shortDescription;
  final String imageUrl;
  final List<String> features;
  final List<String> regions; // ['PK']
  final bool isActive;
  final int displayOrder;
  final Map<String, dynamic>? pricing;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.shortDescription,
    required this.imageUrl,
    required this.features,
    required this.regions,
    this.isActive = true,
    this.displayOrder = 0,
    this.pricing,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      regions: List<String>.from(json['regions'] ?? []),
      isActive: json['isActive'] ?? true,
      displayOrder: json['displayOrder'] ?? 0,
      pricing: json['pricing'] as Map<String, dynamic>?,
    );
  }

  factory Service.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Service.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'shortDescription': shortDescription,
      'imageUrl': imageUrl,
      'features': features,
      'regions': regions,
      'isActive': isActive,
      'displayOrder': displayOrder,
      'pricing': pricing,
    };
  }

  /// Check if service is available in specific region
  bool isAvailableInRegion(String regionCode) {
    return regions.contains(regionCode);
  }
}
