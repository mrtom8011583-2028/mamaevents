import 'package:cloud_firestore/cloud_firestore.dart';

/// Location model for service areas
class Location {
  final String id;
  final String name;
  final String region;
  final GeoPoint? coordinates;
  final bool isActive;
  final String? description;

  Location({
    required this.id,
    required this.name,
    required this.region,
    this.coordinates,
    this.isActive = true,
    this.description,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      region: json['region'] ?? 'PK',
      coordinates: json['coordinates'] as GeoPoint?,
      isActive: json['isActive'] ?? true,
      description: json['description'],
    );
  }

  factory Location.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Location.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'coordinates': coordinates,
      'isActive': isActive,
      'description': description,
    };
  }
}
