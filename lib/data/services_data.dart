// 🎯 MAMA EVENTS - Services Data
// All service offerings with image placeholders
// Images are commented - uncomment and add URLs when ready

import '../core/models/service.dart';

class ServicesData {
  static final List<Service> allServices = [
    // =============================================================================
    // 🏢 CORPORATE CATERING
    // =============================================================================
    Service(
      id: 'corporate_catering',
      title: 'Corporate Catering',
      description: '''
High-end professional catering services tailored for business environments. 
We specialize in boardroom lunches, executive meetings, product launches, 
and annual gala dinners. Our team ensures seamless service that reflects 
your company's professionalism and attention to detail.

Perfect for: Conferences, seminars, training sessions, office celebrations, 
and client meetings.
      ''',
      shortDescription: 'High-end boardroom lunches, coffee breaks, and annual gala dinners',
      imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&q=80', // Corporate catering/business lunch
      features: [
        'Boardroom Lunches & Executive Dining',
        'Coffee Breaks & Refreshment Services',
        'Annual Gala Dinners & Award Ceremonies',
        'Product Launch Events',
        'Conference & Seminar Catering',
        'Team Building Events',
        'Client Entertainment',
        'Professional Service Staff',
        'Custom Menu Planning',
        'Setup & Cleanup Services',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 1,
      pricing: {
        'PK': {'starting': 25000, 'unit': 'per event'},
      },
    ),
    
    // =============================================================================
    // 🎉 SOCIAL & PRIVATE EVENTS
    // =============================================================================
    Service(
      id: 'social_private_events',
      title: 'Social & Private Events',
      description: '''
Bespoke catering services for your intimate celebrations and social gatherings. 
From birthday parties to anniversaries, engagement dinners to home dinner parties, 
we create personalized menus that delight your guests and make your event memorable.

Our team works closely with you to understand your vision and dietary preferences, 
delivering a tailored culinary experience that exceeds expectations.
      ''',
      shortDescription: 'Bespoke menus for birthdays, anniversaries, and home dinner parties',
      imageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&q=80', // Birthday celebration/party
      features: [
        'Birthday Celebrations',
        'Anniversary Dinners',
        'Engagement Parties',
        'Baby Showers',
        'Home Dinner Parties',
        'Graduation Celebrations',
        'Customized Menus',
        'Dietary Accommodations',
        'Table Service',
        'Event Coordination',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 2,
      pricing: {
        'PK': {'starting': 18000, 'unit': 'per event'},
      },
    ),
    
    // =============================================================================
    // 💍 WEDDING BANQUETS
    // =============================================================================
    Service(
      id: 'wedding_banquets',
      title: 'Wedding Banquets',
      description: '''
Specialized wedding catering services that make your special day unforgettable. 
We offer comprehensive packages for Nikkah ceremonies, Mehndi functions, and 
Wedding receptions, with both Buffet and Plated dining options.

Our experienced team handles everything from menu design to service execution, 
ensuring your wedding food matches the elegance and significance of your celebration. 
We cater to traditional, fusion, and international wedding menus.
      ''',
      shortDescription: 'Specialized Nikkah and Wedding packages with Buffet and Plated options',
      imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&q=80', // Elegant wedding banquet
      features: [
        'Nikkah Ceremony Catering',
        'Mehndi Function Setups',
        'Wedding Reception Banquets',
        'Walima Celebrations',
        'Buffet Service Options',
        'Plated Dinner Service',
        'Multi-Cuisine Menus',
        'Live Chef Stations',
        'Dessert Tables',
        'Custom Wedding Cakes',
        'Beverage Services',
        'Traditional & Modern Menus',
        'Halal Certified',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 3,
      pricing: {
        'PK': {'starting': 75000, 'unit': 'per event'},
      },
    ),
    
    // =============================================================================
    // 👨‍🍳 LIVE INTERACTION STATIONS
    // =============================================================================
    Service(
      id: 'live_interaction_stations',
      title: 'Live Interaction Stations',
      description: '''
Interactive chef stations that transform your event into a culinary experience. 
Watch our professional chefs prepare fresh, customized dishes right before 
your eyes. Perfect for adding entertainment and engagement to any gathering.

Our live stations include Shawarma, Pasta, BBQ, Sushi, and more. Each station 
is fully equipped with professional equipment and staffed by expert chefs who 
interact with your guests, creating memorable moments.
      ''',
      shortDescription: 'Interactive chef stations for Shawarma, Pasta, BBQ, and Sushi',
      imageUrl: 'https://images.unsplash.com/photo-1556910110-a5a63dfd393c?w=800&q=80', // Live chef cooking station
      features: [
        'Live Shawarma Station',
        'Interactive Pasta Bar',
        'BBQ Grill Station',
        'Fresh Sushi Bar',
        'Crepe & Waffle Station',
        'Stir-Fry Wok Station',
        'Salad & Juice Bar',
        'Professional Chef Team',
        'High-End Equipment',
        'Custom Toppings & Sauces',
        'Guest Interaction',
        'Fresh Ingredients',
        'Visual Entertainment',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 5,
      pricing: {
        'PK': {'starting': 15000, 'unit': 'per station'},
      },
    ),
    
    // =============================================================================
    // 🎪 EVENT INFRASTRUCTURE
    // =============================================================================
    Service(
      id: 'event_infrastructure',
      title: 'Event Infrastructure',
      description: '''
Comprehensive event support services beyond catering. We provide complete 
event infrastructure including seating arrangements, stage setup, barriers, 
lighting, sound, and professional event staff. Inspired by industry-leading 
event management companies, we ensure every aspect of your event runs smoothly.

Our infrastructure services integrate seamlessly with our catering offerings, 
providing you with a one-stop solution for your complete event needs. From 
intimate gatherings to large-scale conferences, we have the resources to 
deliver excellence.
      ''',
      shortDescription: 'Integrated event support including seating, barriers, and staffing',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800&q=80', // Event setup/infrastructure
      features: [
        'Seating Arrangements (Chairs, Tables, Sofas)',
        'Stage & Podium Setup',
        'Crowd Control Barriers',
        'Red Carpet Service',
        'Lighting Solutions',
        'Sound System Setup',
        'Event Tents & Canopies',
        'Registration Desks',
        'Professional Event Staff',
        'Security Personnel',
        'Valet Parking Services',
        'Setup & Breakdown',
        'Event Coordinator',
        'On-Site Management',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 6,
      pricing: {
        'PK': {'starting': 30000, 'unit': 'per event'},
      },
    ),
  ];
  
  // =============================================================================
  // 📋 HELPER METHODS
  // =============================================================================
  
  /// Get all active services
  static List<Service> getActiveServices() {
    return allServices.where((service) => service.isActive).toList();
  }
  
  /// Get service by ID
  static Service? getServiceById(String id) {
    try {
      return allServices.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get services by region
  static List<Service> getServicesByRegion(String regionCode) {
    return allServices
        .where((service) => service.regions.contains(regionCode))
        .toList();
  }
  
  /// Get featured services (for homepage - first 3)
  static List<Service> getFeaturedServices() {
    return allServices.take(3).toList();
  }
}
