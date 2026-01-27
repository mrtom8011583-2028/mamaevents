import 'package:flutter/material.dart';
import 'region.dart';

/// Menu sections for a package (Main Course, Rice, BBQ, etc.)
class MenuSections {
  final List<String> mainCourse;
  final List<String> rice;
  final List<String> starters;
  final List<String> bbqGrilled;
  final List<String> sides;
  final List<String> desserts;
  final List<String> breads;
  final List<String> beverages;
  final List<String> liveStations;

  MenuSections({
    this.mainCourse = const [],
    this.rice = const [],
    this.starters = const [],
    this.bbqGrilled = const [],
    this.sides = const [],
    this.desserts = const [],
    this.breads = const [],
    this.beverages = const [],
    this.liveStations = const [],
  });

  Map<String, dynamic> toJson() => {
    'mainCourse': mainCourse,
    'rice': rice,
    'starters': starters,
    'bbqGrilled': bbqGrilled,
    'sides': sides,
    'desserts': desserts,
    'breads': breads,
    'beverages': beverages,
    'liveStations': liveStations,
  };

  factory MenuSections.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MenuSections();
    return MenuSections(
      mainCourse: (json['mainCourse'] as List?)?.map((e) => e.toString()).toList() ?? [],
      rice: (json['rice'] as List?)?.map((e) => e.toString()).toList() ?? [],
      starters: (json['starters'] as List?)?.map((e) => e.toString()).toList() ?? [],
      bbqGrilled: (json['bbqGrilled'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sides: (json['sides'] as List?)?.map((e) => e.toString()).toList() ?? [],
      desserts: (json['desserts'] as List?)?.map((e) => e.toString()).toList() ?? [],
      breads: (json['breads'] as List?)?.map((e) => e.toString()).toList() ?? [],
      beverages: (json['beverages'] as List?)?.map((e) => e.toString()).toList() ?? [],
      liveStations: (json['liveStations'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  /// Returns a flat list of all menu items (for backward compatibility)
  List<String> get allItems => [
    ...mainCourse,
    ...rice,
    ...starters,
    ...bbqGrilled,
    ...sides,
    ...desserts,
    ...breads,
    ...beverages,
    ...liveStations,
  ];
}

/// Package features (Bone-Free, Mess-Free, etc.) - especially for Corporate
class PackageFeatures {
  final bool boneFree;
  final bool messFree;
  final bool grilled;
  final bool lowOil;
  final bool ketoFriendly;

  PackageFeatures({
    this.boneFree = false,
    this.messFree = false,
    this.grilled = false,
    this.lowOil = false,
    this.ketoFriendly = false,
  });

  Map<String, dynamic> toJson() => {
    'boneFree': boneFree,
    'messFree': messFree,
    'grilled': grilled,
    'lowOil': lowOil,
    'ketoFriendly': ketoFriendly,
  };

  factory PackageFeatures.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PackageFeatures();
    return PackageFeatures(
      boneFree: json['boneFree'] == true,
      messFree: json['messFree'] == true,
      grilled: json['grilled'] == true,
      lowOil: json['lowOil'] == true,
      ketoFriendly: json['ketoFriendly'] == true,
    );
  }

  /// Returns list of enabled feature labels
  List<String> get enabledLabels {
    final labels = <String>[];
    if (boneFree) labels.add('Bone-Free');
    if (messFree) labels.add('Mess-Free');
    if (grilled) labels.add('Grilled');
    if (lowOil) labels.add('Low Oil');
    if (ketoFriendly) labels.add('Keto-Friendly');
    return labels;
  }
}

/// Cake On Demand options (for Birthday packages)
class CakeOnDemand {
  final bool included;
  final int includedWeight; // in lbs
  final List<String> flavors;
  final bool customizationAvailable;
  final String specialNote;

  CakeOnDemand({
    this.included = false,
    this.includedWeight = 2,
    this.flavors = const [],
    this.customizationAvailable = false,
    this.specialNote = '',
  });

  Map<String, dynamic> toJson() => {
    'included': included,
    'includedWeight': includedWeight,
    'flavors': flavors,
    'customizationAvailable': customizationAvailable,
    'specialNote': specialNote,
  };

  factory CakeOnDemand.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CakeOnDemand();
    return CakeOnDemand(
      included: json['included'] == true,
      includedWeight: int.tryParse(json['includedWeight'].toString()) ?? 2,
      flavors: (json['flavors'] as List?)?.map((e) => e.toString()).toList() ?? [],
      customizationAvailable: json['customizationAvailable'] == true,
      specialNote: json['specialNote']?.toString() ?? '',
    );
  }
}

/// Pricing options for a package
class PackagePricing {
  final bool displayPrice;
  final double pricePerPerson;
  final int minimumGuests;

  PackagePricing({
    this.displayPrice = false,
    this.pricePerPerson = 0,
    this.minimumGuests = 50,
  });

  Map<String, dynamic> toJson() => {
    'displayPrice': displayPrice,
    'pricePerPerson': pricePerPerson,
    'minimumGuests': minimumGuests,
  };

  factory PackagePricing.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PackagePricing();
    return PackagePricing(
      displayPrice: json['displayPrice'] == true,
      pricePerPerson: double.tryParse(json['pricePerPerson'].toString()) ?? 0,
      minimumGuests: int.tryParse(json['minimumGuests'].toString()) ?? 50,
    );
  }
}

/// Represents a catering package tier (Economy, Premium, Royal)
class PackageTier {
  final String id;
  final String categoryId;      // wedding, corporate, birthday
  final String eventTypeId;     // valima, mehndi, barat, etc.
  final String tier;            // economy, premium, royal
  final String name;
  final String tagline;
  final String description;
  final List<String> images;    // Base64 images (max 2)
  final MenuSections menuSections;
  final PackageFeatures features;
  final CakeOnDemand cakeOnDemand;
  final PackagePricing pricing;
  final String status;          // active, inactive
  final int createdAt;
  final int updatedAt;

  // Legacy fields for backward compatibility
  final int tierLevel;
  final bool isMostPopular;
  final Map<String, double> basePriceByRegion;
  final List<String> featuresLegacy;
  final List<String> idealFor;
  final String servingCapacity;
  final List<String> menuItems;
  final String imageUrl;
  final List<String> tags;

  PackageTier({
    required this.id,
    this.categoryId = '',
    this.eventTypeId = '',
    this.tier = 'economy',
    required this.name,
    this.tagline = '',
    this.description = '',
    this.images = const [],
    MenuSections? menuSections,
    PackageFeatures? features,
    CakeOnDemand? cakeOnDemand,
    PackagePricing? pricing,
    this.status = 'active',
    this.createdAt = 0,
    this.updatedAt = 0,
    // Legacy
    String? subtitle,
    this.tierLevel = 1,
    this.isMostPopular = false,
    Map<String, double>? basePriceByRegion,
    List<String>? featuresLegacy,
    this.idealFor = const [],
    this.servingCapacity = '',
    this.menuItems = const [],
    this.imageUrl = '',
    this.tags = const [],
  })  : menuSections = menuSections ?? MenuSections(),
        features = features ?? PackageFeatures(),
        cakeOnDemand = cakeOnDemand ?? CakeOnDemand(),
        pricing = pricing ?? PackagePricing(),
        basePriceByRegion = basePriceByRegion ?? {},
        featuresLegacy = featuresLegacy ?? [];

  // Getter for subtitle (backward compatibility)
  String get subtitle => tagline.isNotEmpty ? tagline : '';

  double getPrice(Region region) {
    if (pricing.displayPrice && pricing.pricePerPerson > 0) {
      return pricing.pricePerPerson;
    }
    return basePriceByRegion[region.code] ?? basePriceByRegion['PK'] ?? 0;
  }

  String getFormattedPrice(Region region) {
    final price = getPrice(region);
    return 'Rs ${price.toStringAsFixed(0)}';
  }

  /// Get tier level from tier string
  int getTierLevel() {
    if (tierLevel > 0) return tierLevel;
    switch (tier.toLowerCase()) {
      case 'economy': return 1;
      case 'premium': return 2;
      case 'royal': return 3;
      default: return 1;
    }
  }

  /// Get all menu items (combines new menuSections with legacy menuItems)
  List<String> getAllMenuItems() {
    final items = menuSections.allItems;
    if (items.isEmpty) return menuItems;
    return items;
  }

  /// AUTO-GENERATION: Generate legacy featuresLegacy from structured features
  /// This ensures frontend displays "What's Included" section correctly
  List<String> _generateLegacyFeatures() {
    final List<String> generated = [];
    
    // Add feature labels from PackageFeatures object
    if (features.boneFree) generated.add('Bone-Free');
    if (features.messFree) generated.add('Mess-Free');
    if (features.grilled) generated.add('Grilled');
    if (features.lowOil) generated.add('Low Oil');
    if (features.ketoFriendly) generated.add('Keto-Friendly');
    
    // Add idealFor items
    generated.addAll(idealFor);
    
    // Add tags
    generated.addAll(tags);
    
    // If we generated items, return them; otherwise keep existing legacy features
    if (generated.isNotEmpty) return generated;
    return featuresLegacy;
  }

  /// AUTO-GENERATION: Generate legacy menuItems from structured menuSections
  /// This ensures frontend displays "Complete Menu" section correctly
  List<String> _generateLegacyMenuItems() {
    final items = menuSections.allItems;
    // If new menuSections has items, use them; otherwise keep legacy menuItems
    if (items.isNotEmpty) return items;
    return menuItems;
  }

  /// AUTO-GENERATION: Generate legacy basePriceByRegion from structured pricing
  /// This ensures frontend displays correct pricing instead of "Rs 0"
  Map<String, double> _generateBasePriceByRegion() {
    // If pricing object has displayPrice enabled and price set, generate region map
    if (pricing.displayPrice && pricing.pricePerPerson > 0) {
      return {'PK': pricing.pricePerPerson};
    }
    // Otherwise keep existing basePriceByRegion
    return basePriceByRegion.isNotEmpty ? basePriceByRegion : {};
  }

  /// AUTO-GENERATION: Generate legacy servingCapacity from structured pricing
  /// This ensures frontend displays minimum guest count correctly
  String _generateServingCapacity() {
    // If already has legacy servingCapacity, keep it
    if (servingCapacity.isNotEmpty) return servingCapacity;
    // Generate from new pricing structure
    if (pricing.minimumGuests > 0) {
      return 'Min ${pricing.minimumGuests} Guests';
    }
    return '';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'eventTypeId': eventTypeId,
    'tier': tier,
    'name': name,
    'tagline': tagline,
    'description': description,
    'images': images,
    'menuSections': menuSections.toJson(),
    'features': features.toJson(),
    'cakeOnDemand': cakeOnDemand.toJson(),
    'pricing': pricing.toJson(),
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    // Legacy fields
    'subtitle': subtitle,
    'tierLevel': tierLevel > 0 ? tierLevel : getTierLevel(),
    'isMostPopular': isMostPopular,
    'basePriceByRegion': _generateBasePriceByRegion(), // ✅ AUTO-GENERATED
    'featuresLegacy': _generateLegacyFeatures(),      // ✅ AUTO-GENERATED
    'idealFor': idealFor,
    'servingCapacity': _generateServingCapacity(),    // ✅ AUTO-GENERATED
    'menuItems': _generateLegacyMenuItems(),          // ✅ AUTO-GENERATED
    'imageUrl': imageUrl,
    'tags': tags,
  };

  factory PackageTier.fromJson(Map<String, dynamic> json) => PackageTier(
    id: json['id']?.toString() ?? '',
    categoryId: json['categoryId']?.toString() ?? '',
    eventTypeId: json['eventTypeId']?.toString() ?? '',
    tier: json['tier']?.toString() ?? 'economy',
    name: json['name']?.toString() ?? 'Unnamed Package',
    tagline: json['tagline']?.toString() ?? json['subtitle']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    menuSections: MenuSections.fromJson(json['menuSections'] != null ? Map<String, dynamic>.from(json['menuSections'] as Map) : null),
    features: PackageFeatures.fromJson(json['features'] != null ? Map<String, dynamic>.from(json['features'] as Map) : null),
    cakeOnDemand: CakeOnDemand.fromJson(json['cakeOnDemand'] != null ? Map<String, dynamic>.from(json['cakeOnDemand'] as Map) : null),
    pricing: PackagePricing.fromJson(json['pricing'] != null ? Map<String, dynamic>.from(json['pricing'] as Map) : null),
    status: json['status']?.toString() ?? 'active',
    createdAt: int.tryParse(json['createdAt'].toString()) ?? 0,
    updatedAt: int.tryParse(json['updatedAt'].toString()) ?? 0,
    // Legacy
    tierLevel: int.tryParse(json['tierLevel'].toString()) ?? 1,
    isMostPopular: json['isMostPopular'] == true,
    basePriceByRegion: (json['basePriceByRegion'] as Map?)?.map(
      (key, value) => MapEntry(key.toString(), double.tryParse(value.toString()) ?? 0.0),
    ) ?? {},
    featuresLegacy: (json['featuresLegacy'] as List?)?.map((e) => e.toString()).toList() ?? 
                   (json['features'] is List ? (json['features'] as List).map((e) => e.toString()).toList() : []),
    idealFor: (json['idealFor'] as List?)?.map((e) => e.toString()).toList() ?? [],
    servingCapacity: json['servingCapacity']?.toString() ?? '',
    menuItems: (json['menuItems'] as List?)?.map((e) => e.toString()).toList() ?? [],
    imageUrl: json['imageUrl']?.toString() ?? '',
    tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );
}

/// Represents an event sub-category (Valima, Mehndi, Barat, etc.)
class EventSubCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String tagline;
  final int order;
  final List<PackageTier> packages;
  final String imageUrl;

  EventSubCategory({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = '🎉',
    this.tagline = '',
    this.order = 1,
    this.packages = const [],
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'tagline': tagline,
    'order': order,
    'packages': packages.map((p) => p.toJson()).toList(),
    'imageUrl': imageUrl,
  };

  factory EventSubCategory.fromJson(Map<String, dynamic> json) =>
    EventSubCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '🎉',
      tagline: json['tagline']?.toString() ?? '',
      order: int.tryParse(json['order'].toString()) ?? 1,
      packages: (json['packages'] as List?)
        ?.map((p) => PackageTier.fromJson(Map<String, dynamic>.from(p as Map)))
        .toList() ?? [],
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
}

class EventCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String status;
  final int order; // NEW: Controls display order
  final List<EventSubCategory> subCategories;
  final String imageUrl;

  EventCategory({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = Icons.celebration,
    this.color = const Color(0xFFD4AF37),
    this.status = 'active',
    this.order = 99,
    this.subCategories = const [],
    this.imageUrl = '',
  });

  /// Get total package count across all sub-categories
  int get totalPackages => subCategories.fold(0, (sum, sub) => sum + sub.packages.length);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon.codePoint,
    'color': color.value,
    'status': status,
    'order': order,
    'subCategories': subCategories.map((s) => s.toJson()).toList(),
    'imageUrl': imageUrl,
  };

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: IconData(json['icon'] ?? 0xe0b7, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] ?? 0xFFD4AF37),
      status: json['status']?.toString() ?? 'active',
      order: int.tryParse(json['order'].toString()) ?? 99,
      subCategories: (json['subCategories'] as List?)
        ?.map((e) => EventSubCategory.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList() ?? [],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
