// 💬 MAMA EVENTS - Customer Testimonials
// Real customer reviews from Pakistan

class Testimonial {
  final String id;
  final String customerName;
  final String location; // e.g., "Lahore, Pakistan"
  final String regionCode; // 'PK'
  final String eventType; // e.g., "Wedding Reception"
  final String review;
  final double rating; // 1.0 to 5.0
  final DateTime date;
  final String? customerTitle; // e.g., "Business Owner"
  final int? guestCount;

  Testimonial({
    required this.id,
    required this.customerName,
    required this.location,
    required this.regionCode,
    required this.eventType,
    required this.review,
    required this.rating,
    required this.date,
    this.customerTitle,
    this.guestCount,
  });

  String get initials {
    final parts = customerName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return customerName.substring(0, 2).toUpperCase();
  }
}

class TestimonialsData {
  static final List<Testimonial> allTestimonials = [
    // =============================================================================
    // 🇵🇰 PAKISTAN TESTIMONIALS
    // =============================================================================
    Testimonial(
      id: 'test_pk_001',
      customerName: 'Ayesha Khan',
      location: 'Lahore, Pakistan',
      regionCode: 'PK',
      eventType: 'Wedding Reception',
      review: 'Fresh Catering made our wedding day absolutely perfect! The food was exceptional, setup was beautiful, and service was impeccable. Our 500 guests couldn\'t stop talking about the delicious biryani and live pasta station. Highly recommend!',
      rating: 5.0,
      date: DateTime(2025, 12, 15),
      guestCount: 500,
    ),
    Testimonial(
      id: 'test_pk_002',
      customerName: 'Muhammad Ali',
      location: 'Karachi, Pakistan',
      regionCode: 'PK',
      eventType: 'Corporate Gala',
      review: 'We hired Fresh Catering for our annual corporate gala and they exceeded all expectations. Professional team, on-time service, and the food quality was outstanding. Will definitely use them again for future events.',
      rating: 5.0,
      date: DateTime(2025, 11, 20),
      customerTitle: 'CEO, Tech Solutions Ltd',
      guestCount: 300,
    ),
    Testimonial(
      id: 'test_pk_003',
      customerName: 'Fatima Ahmed',
      location: 'Islamabad, Pakistan',
      regionCode: 'PK',
      eventType: 'Birthday Celebration',
      review: 'Organized my father\'s 60th birthday with Fresh Catering. The live shawarma station was a huge hit! Food was fresh and delicious, staff was courteous, and pricing was very reasonable. Thank you for making it memorable!',
      rating: 4.5,
      date: DateTime(2026, 1, 5),
      guestCount: 150,
    ),
    Testimonial(
      id: 'test_pk_004',
      customerName: 'Hassan Raza',
      location: 'Lahore, Pakistan',
      regionCode: 'PK',
      eventType: 'Mehndi Function',
      review: 'Amazing experience with Fresh Catering! The colorful Mehndi setup and traditional Pakistani cuisine were perfect. Guests loved the chaat counter and BBQ station. Great value for money!',
      rating: 5.0,
      date: DateTime(2025, 10, 8),
      guestCount: 400,
    ),

  ];

  // =============================================================================
  // 📋 HELPER METHODS
  // =============================================================================

  /// Get testimonials by region
  static List<Testimonial> getTestimonialsByRegion(String regionCode) {
    return allTestimonials
        .where((t) => t.regionCode == regionCode)
        .toList();
  }

  /// Get featured testimonials (5-star only)
  static List<Testimonial> getFeaturedTestimonials() {
    return allTestimonials.where((t) => t.rating == 5.0).toList();
  }

  /// Get recent testimonials (last 3 months)
  static List<Testimonial> getRecentTestimonials() {
    final threeMonthsAgo = DateTime.now().subtract(const Duration(days: 90));
    return allTestimonials
        .where((t) => t.date.isAfter(threeMonthsAgo))
        .toList();
  }

  /// Get average rating
  static double getAverageRating() {
    if (allTestimonials.isEmpty) return 0.0;
    final sum = allTestimonials.fold<double>(0, (prev, t) => prev + t.rating);
    return sum / allTestimonials.length;
  }

  /// Get average rating by region
  static double getAverageRatingByRegion(String regionCode) {
    final regionTestimonials = getTestimonialsByRegion(regionCode);
    if (regionTestimonials.isEmpty) return 0.0;
    final sum = regionTestimonials.fold<double>(0, (prev, t) => prev + t.rating);
    return sum / regionTestimonials.length;
  }

  /// Get total count
  static int getTotalCount() => allTestimonials.length;

  /// Get count by region
  static int getCountByRegion(String regionCode) {
    return getTestimonialsByRegion(regionCode).length;
  }
}
