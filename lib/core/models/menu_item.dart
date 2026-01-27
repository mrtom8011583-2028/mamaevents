
import 'region.dart';

/// Model representing a menu item in the catering service
class MenuItem {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final Map<String, double> prices; // {'PK': 5000}
  final bool available;
  final List<String> regions; // ['PK']
  final List<String> tags; // ['halal', 'vegetarian', 'spicy'] - deprecated, use dietaryTags
  final List<String> dietaryTags; // ['Halal', 'Vegetarian', 'Vegan', 'Gluten-Free']
  final String? cuisineType; // 'Middle Eastern', 'Desi/South Asian', 'International'
  final String? servings; // '6-8 people' or '50-75 people'
  final int servingsCount; // Number value for calculations
  final String preparationTime; // e.g., "2 hours"
  final bool liveStation; // Is this a live chef station item
  final bool isPricePerHead; // Price is per person instead of total
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.prices,
    this.available = true,
    required this.regions,
    this.tags = const [],
    this.dietaryTags = const [],
    this.cuisineType,
    this.servings,
    this.servingsCount = 10,
    this.preparationTime = '2-3 hours',
    this.liveStation = false,
    this.isPricePerHead = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Get price for specific region
  double getPrice(Region region) {
    return prices[region.code] ?? 0.0;
  }

  /// Get formatted price for specific region
  String getFormattedPrice(Region region) {
    var price = getPrice(region);
    return region.formatPrice(price);
  }

  /// Check if item is available in specific region
  bool isAvailableInRegion(Region region) {
    return regions.contains(region.code) && available;
  }

  /// Check if item has specific tag
  bool hasTag(String tag) {
    return tags.contains(tag.toLowerCase());
  }

  /// Get per-person price
  double getPricePerPerson(Region region) {
    final totalPrice = getPrice(region);
    if (servingsCount == 0 && !isPricePerHead) return totalPrice; // Prevent division by zero
    // If it is price per head, the total price IS the per person price (or unit price).
    // If not, we divide by servings.
    return isPricePerHead ? totalPrice : totalPrice / servingsCount;
  }

  /// Create from JSON (Firestore)
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unnamed Item',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
      imageUrl: json['imageUrl']?.toString() ?? '',
      prices: _parsePrices(json),
      available: json['available'] == true,
      regions: (json['regions'] as List?)?.map((e) => e.toString()).toList() ?? [],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      dietaryTags: (json['dietaryTags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      cuisineType: json['cuisineType']?.toString(),
      servings: json['servings']?.toString(),
      servingsCount: int.tryParse(json['servingsCount'].toString()) ?? 10,
      preparationTime: json['preparationTime']?.toString() ?? '2-3 hours',
      liveStation: json['liveStation'] == true,
      isPricePerHead: json['isPricePerHead'] == true, // Handle new field
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  static Map<String, double> _parsePrices(Map<String, dynamic> json) {
    final Map<String, double> prices = {};
    
    // 1. Try to parse 'prices' map
    if (json['prices'] != null && json['prices'] is Map) {
      final map = json['prices'] as Map;
      map.forEach((key, value) {
        // Handle variations like 'pk', 'PK', 'Pk'
        final k = key.toString().toUpperCase(); 
        final v = double.tryParse(value.toString()) ?? 0.0;
        if (v > 0) prices[k] = v;
      });
    }

    // 2. Fallback to root level 'price'
    if (prices.isEmpty && json['price'] != null) {
      final v = double.tryParse(json['price'].toString()) ?? 0.0;
      if (v > 0) prices['PK'] = v;
    }

    // 3. Fallback to 'PK' if implicit
    if (prices.isEmpty && json['PK'] != null) {
       final v = double.tryParse(json['PK'].toString()) ?? 0.0;
       if (v > 0) prices['PK'] = v;
    }

    return prices;
  }

  /// Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'prices': prices,
      'available': available,
      'regions': regions,
      'tags': tags,
      'dietaryTags': dietaryTags,
      'cuisineType': cuisineType,
      'servings': servings,
      'servingsCount': servingsCount,
      'preparationTime': preparationTime,
      'liveStation': liveStation,
      'isPricePerHead': isPricePerHead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? imageUrl,
    Map<String, double>? prices,
    bool? available,
    List<String>? regions,
    List<String>? tags,
    List<String>? dietaryTags,
    String? cuisineType,
    String? servings,
    int? servingsCount,
    String? preparationTime,
    bool? liveStation,
    bool? isPricePerHead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      prices: prices ?? this.prices,
      available: available ?? this.available,
      regions: regions ?? this.regions,
      tags: tags ?? this.tags,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      cuisineType: cuisineType ?? this.cuisineType,
      servings: servings ?? this.servings,
      servingsCount: servingsCount ?? this.servingsCount,
      preparationTime: preparationTime ?? this.preparationTime,
      liveStation: liveStation ?? this.liveStation,
      isPricePerHead: isPricePerHead ?? this.isPricePerHead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, category: $category, regions: $regions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Menu categories enum
enum MenuCategory {
  corporate('Corporate Events', 'Business meetings, conferences'),
  wedding('Wedding Catering', 'Elegant wedding celebrations'),
  sandwich('Sandwich Catering', 'Fresh sandwiches and wraps'),
  buffet('Buffet Catering', 'Self-service buffets'),
  breakfast('Breakfast', 'Morning meals'),
  lunch('Lunch', 'Midday dining'),
  dinner('Dinner', 'Evening meals'),
  desserts('Desserts', 'Sweet treats'),
  beverages('Beverages', 'Drinks and refreshments');

  const MenuCategory(this.displayName, this.description);

  final String displayName;
  final String description;

  static MenuCategory fromString(String value) {
    return MenuCategory.values.firstWhere(
          (cat) => cat.name.toLowerCase() == value.toLowerCase(),
      orElse: () => MenuCategory.corporate,
    );
  }
}