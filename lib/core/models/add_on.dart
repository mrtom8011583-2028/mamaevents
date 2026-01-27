/// Represents a live station or add-on service
class AddOn {
  final String id;
  final String name;
  final String type;           // liveStation, dessert, beverage, decoration
  final String description;
  final String image;          // Base64
  final double priceEstimate;  // Starting price in PKR
  final List<String> applicableCategories; // wedding, corporate, birthday
  final bool popular;
  final String status;         // active, inactive
  final int createdAt;
  final int updatedAt;

  AddOn({
    required this.id,
    required this.name,
    this.type = 'liveStation',
    this.description = '',
    this.image = '',
    this.priceEstimate = 0,
    this.applicableCategories = const ['wedding', 'corporate', 'birthday'],
    this.popular = false,
    this.status = 'active',
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'description': description,
    'image': image,
    'priceEstimate': priceEstimate,
    'applicableCategories': applicableCategories,
    'popular': popular,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    type: json['type']?.toString() ?? 'liveStation',
    description: json['description']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    priceEstimate: double.tryParse(json['priceEstimate'].toString()) ?? 0,
    applicableCategories: (json['applicableCategories'] as List?)
      ?.map((e) => e.toString()).toList() ?? 
      ['wedding', 'corporate', 'birthday'],
    popular: json['popular'] == true,
    status: json['status']?.toString() ?? 'active',
    createdAt: int.tryParse(json['createdAt'].toString()) ?? 0,
    updatedAt: int.tryParse(json['updatedAt'].toString()) ?? 0,
  );

  /// Get formatted price
  String get formattedPrice => 'PKR ${priceEstimate.toStringAsFixed(0)}';

  /// Icon based on type
  String get typeIcon {
    switch (type) {
      case 'liveStation': return '🎪';
      case 'dessert': return '🍰';
      case 'beverage': return '🥤';
      case 'decoration': return '🎊';
      default: return '✨';
    }
  }
}

/// Available add-on types
class AddOnType {
  static const String liveStation = 'liveStation';
  static const String dessert = 'dessert';
  static const String beverage = 'beverage';
  static const String decoration = 'decoration';

  static List<String> get all => [liveStation, dessert, beverage, decoration];

  static String getLabel(String type) {
    switch (type) {
      case liveStation: return 'Live Station';
      case dessert: return 'Dessert';
      case beverage: return 'Beverage';
      case decoration: return 'Decoration';
      default: return type;
    }
  }
}
