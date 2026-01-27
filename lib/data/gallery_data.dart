// 📸 MAMA EVENTS - Gallery Data
// Event photos organized by category

class GalleryImage {
  final String id;
  final String title;
  final String description;
  final String category; // 'Wedding', 'Corporate', 'Social', 'Live Stations', 'Outdoor'
  final String imageUrl;
  final String? photographer;
  final DateTime? eventDate;
  final List<String> tags;

  GalleryImage({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.photographer,
    this.eventDate,
    this.tags = const [],
  });
}

class GalleryData {
  static final List<GalleryImage> allImages = [
    // =============================================================================
    // 💍 WEDDING EVENTS
    // =============================================================================
    GalleryImage(
      id: 'wed_001',
      title: 'Elegant Wedding Reception',
      description: '500-guest wedding at Marriott Hotel with full buffet service',
      category: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&q=80',
      tags: ['buffet', 'wedding', 'grand'],
    ),
    GalleryImage(
      id: 'wed_002',
      title: 'Nikkah Ceremony Setup',
      description: 'Intimate Nikkah with traditional Pakistani cuisine',
      category: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?w=800&q=80',
      tags: ['nikkah', 'traditional', 'elegant'],
    ),
    GalleryImage(
      id: 'wed_003',
      title: 'Mehndi Function Catering',
      description: 'Vibrant Mehndi event with live food stations',
      category: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=800&q=80',
      tags: ['mehndi', 'colorful', 'live-stations'],
    ),
    GalleryImage(
      id: 'wed_004',
      title: 'Walima Banquet',
      description: 'Grand Walima dinner for 800 guests',
      category: 'Wedding',
      imageUrl: 'https://images.unsplash.com/photo-1478145046317-39f10e56b5e9?w=800&q=80',
      tags: ['walima', 'grand', 'luxury'],
    ),
    
    // =============================================================================
    // 🕌 WALIMA EVENTS
    // =============================================================================
    GalleryImage(
      id: 'walima_001',
      title: 'Traditional Walima Setup',
      description: 'Elegant Walima reception with 500 guests',
      category: 'Walima',
      imageUrl: 'https://images.unsplash.com/photo-1544148103-0773bf10d330?w=800&q=80',
      tags: ['walima', 'traditional', 'grand'],
    ),
    GalleryImage(
      id: 'walima_002',
      title: 'Premium Walima Dinner',
      description: 'Luxurious groom reception with live stations',
      category: 'Walima',
      imageUrl: 'https://images.unsplash.com/photo-1555244162-803834f70033?w=800&q=80',
      tags: ['walima', 'premium', 'dinner'],
    ),
    GalleryImage(
      id: 'walima_003',
      title: 'Grand Walima Hall',
      description: 'Spectacular venue setup for 1000 guests',
      category: 'Walima',
      imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800&q=80',
      tags: ['walima', 'grand', 'venue'],
    ),
    GalleryImage(
      id: 'walima_004',
      title: 'Royal Walima Feast',
      description: 'Traditional cuisine with modern presentation',
      category: 'Walima',
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&q=80',
      tags: ['walima', 'royal', 'feast'],
    ),

    // =============================================================================
    // 🏢 CORPORATE EVENTS
    // =============================================================================
    GalleryImage(
      id: 'corp_001',
      title: 'Annual Gala Dinner',
      description: 'Corporate gala for Fortune 500 company',
      category: 'Corporate',
      imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&q=80',
      tags: ['gala', 'corporate', 'formal'],
    ),
    GalleryImage(
      id: 'corp_002',
      title: 'Conference Lunch Setup',
      description: 'Three-day conference catering for 300 delegates',
      category: 'Corporate',
      imageUrl: 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&q=80',
      tags: ['conference', 'lunch', 'professional'],
    ),
    GalleryImage(
      id: 'corp_003',
      title: 'Product Launch Event',
      description: 'Exclusive product launch with cocktail reception',
      category: 'Corporate',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80',
      tags: ['launch', 'cocktail', 'premium'],
    ),
    GalleryImage(
      id: 'corp_004',
      title: 'Boardroom Lunch',
      description: 'Executive lunch for C-level meeting',
      category: 'Corporate',
      imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
      tags: ['executive', 'boardroom', 'premium'],
    ),

    // =============================================================================
    // 🎉 SOCIAL & PRIVATE EVENTS
    // =============================================================================
    GalleryImage(
      id: 'social_001',
      title: 'Birthday Celebration',
      description: '50th birthday party with themed decorations',
      category: 'Social',
      imageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&q=80',
      tags: ['birthday', 'celebration', 'themed'],
    ),
    GalleryImage(
      id: 'social_002',
      title: 'Anniversary Dinner',
      description: '25th anniversary dinner party at home',
      category: 'Social',
      imageUrl: 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&q=80',
      tags: ['anniversary', 'intimate', 'home'],
    ),
    GalleryImage(
      id: 'social_003',
      title: 'Graduation Party',
      description: 'University graduation celebration for 100 guests',
      category: 'Social',
      imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&q=80',
      tags: ['graduation', 'young', 'celebration'],
    ),

    // =============================================================================
    // 👨‍🍳 LIVE STATIONS
    // =============================================================================
    GalleryImage(
      id: 'live_001',
      title: 'Shawarma Station',
      description: 'Live shawarma carving at corporate event',
      category: 'Live Stations',
      imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=800&q=80',
      tags: ['shawarma', 'live-cooking', 'interactive'],
    ),
    GalleryImage(
      id: 'live_002',
      title: 'Pasta Bar Setup',
      description: 'Interactive pasta station with 5 sauce options',
      category: 'Live Stations',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&q=80',
      tags: ['pasta', 'italian', 'interactive'],
    ),
    GalleryImage(
      id: 'live_003',
      title: 'BBQ Grill Station',
      description: 'Outdoor BBQ with live chef grilling',
      category: 'Live Stations',
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
      tags: ['bbq', 'grill', 'outdoor'],
    ),
    GalleryImage(
      id: 'live_004',
      title: 'Sushi Rolling Station',
      description: 'Professional sushi chef preparing fresh rolls',
      category: 'Live Stations',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800&q=80',
      tags: ['sushi', 'japanese', 'premium'],
    ),

    // =============================================================================
    // ⛵ OUTDOOR EVENTS
    // =============================================================================
    GalleryImage(
      id: 'outdoor_001',
      title: 'Yacht Party Catering',
      description: 'Luxury yacht event catering',
      category: 'Outdoor',
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&q=80',
      tags: ['yacht', 'luxury'],
    ),
    GalleryImage(
      id: 'outdoor_002',
      title: 'Beach Wedding Setup',
      description: 'Beachfront wedding reception at sunset',
      category: 'Outdoor',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
      tags: ['beach', 'wedding', 'sunset'],
    ),
    GalleryImage(
      id: 'outdoor_003',
      title: 'Garden Party',
      description: 'Elegant garden party with floral decorations',
      category: 'Outdoor',
      imageUrl: 'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&q=80',
      tags: ['garden', 'floral', 'elegant'],
    ),
    GalleryImage(
      id: 'outdoor_004',
      title: 'Desert Safari Dinner',
      description: 'Traditional Arabian dinner in the desert',
      category: 'Outdoor',
      imageUrl: 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=800&q=80',
      tags: ['desert', 'arabian', 'traditional'],
    ),
  ];

  // =============================================================================
  // 📋 HELPER METHODS
  // =============================================================================

  /// Get all categories
  static List<String> getCategories() {
    final categories = allImages.map((img) => img.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  /// Get images by category
  static List<GalleryImage> getImagesByCategory(String category) {
    if (category == 'All') {
      return allImages;
    }
    return allImages.where((img) => img.category == category).toList();
  }

  /// Get images by tag
  static List<GalleryImage> getImagesByTag(String tag) {
    return allImages.where((img) => img.tags.contains(tag)).toList();
  }

  /// Get featured images (first 6)
  static List<GalleryImage> getFeaturedImages() {
    return allImages.take(6).toList();
  }

  /// Search images
  static List<GalleryImage> searchImages(String query) {
    final lowerQuery = query.toLowerCase();
    return allImages.where((img) {
      return img.title.toLowerCase().contains(lowerQuery) ||
          img.description.toLowerCase().contains(lowerQuery) ||
          img.category.toLowerCase().contains(lowerQuery) ||
          img.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
