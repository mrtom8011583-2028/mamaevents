// 🎯 MAMA EVENTS - Services Data
// All service offerings with image placeholders
// Images are commented - uncomment and add URLs when ready

import '../core/models/service.dart';

class ServicesData {
  static final List<Service> allServices = [
    // 1. Wedding & Event Coverage
    Service(
      id: 'wedding_event_coverage',
      title: 'Wedding & Event Coverage',
      description: '''
Comprehensive wedding and event coverage services designed to make your special days truly unforgettable. We handle every aspect of your celebration – from the vibrant Mehndi and traditional Baraat to the elegant Walima.

Our team ensures seamless coordination and execution, allowing you to cherish every moment with your loved ones. We also provide full coverage for corporate galas, birthday bashes, and private functions, ensuring a consistent standard of excellence.
      ''',
      shortDescription: 'Complete coverage for Mehndi, Baraat, Walima, and Corporate Events.',
      imageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&q=80',
      features: [
        'Mehndi Function Management',
        'Baraat Ceremony Setup',
        'Walima Reception Coordination',
        'Corporate Event Management',
        'Birthday Party Planning',
        'Private Function Hosting',
        'On-site Event Coordination',
        'Timeline Management',
        'Vendor Coordination',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 1,
      pricing: {'PK': {'starting': 1500000, 'unit': 'per event'}},
    ),

    // 2. Luxury Furniture & Setup (VIP Events)
    Service(
      id: 'luxury_furniture_setup',
      title: 'Luxury Furniture & Setup',
      description: '''
Elevate your event with our premium furniture and VIP setup services. We provide an exclusive range of luxury lounges, plush sofas, and high-end table settings that exude sophistication.

Our collection includes velvet and silk-style tablecloths, designer chairs, and bespoke layout designs that transform any venue into a royal setting. Perfect for VIP corporate events, weddings, and high-profile gatherings.
      ''',
      shortDescription: 'Luxury sofas, lounges, and premium table setups for VIP events.',
      imageUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=800&q=80',
      features: [
        'Luxury Sofa Lounges',
        'Premium Dining Tables',
        'Velvet & Silk Table Linens',
        'Designer Chiavari Chairs',
        'VIP Enclosures',
        'Red Carpet Entrance',
        'Custom Layout Design',
        'Furniture Styling',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 2,
      pricing: {'PK': {'starting': 600000, 'unit': 'per setup'}},
    ),

    // 3. Floral & Venue Decor
    Service(
      id: 'floral_venue_decor',
      title: 'Floral & Venue Decor',
      description: '''
Breathtaking floral arrangements and venue decor that set the perfect mood. We specialize in using fresh, imported flowers to create stunning centerpieces, stage backdrops, and entrance arches.

Our decor services also include magnificent chandeliers (jhoomar), thematic drapery, and aesthetic installations that add a touch of magic to your venue.
      ''',
      shortDescription: 'Fresh imported flowers, complete venue decor, and decorative chandeliers.',
      imageUrl: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&q=80',
      features: [
        'Fresh Imported Flower Arrangements',
        'Themed Venue Decor',
        'Grand Chandeliers (Jhoomar)',
        'Stage Floral Decor',
        'Table Centerpieces',
        'Entrance Walkway Decor',
        'Ceiling Draping & Instincts',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 3,
      pricing: {'PK': {'starting': 800000, 'unit': 'per event'}},
    ),

    // 4. Special Effects & Grand Entries
    Service(
      id: 'special_effects_entry',
      title: 'Special Effects & Grand Entries',
      description: '''
Create a spectacular entrance and memorable moments with our special effects services. We offer a range of visual enhancements including fireworks, cold pyro, and confetti blasts specially timed for bride & groom entries.

These dramatic touches ensure high-energy excitement and picture-perfect moments that your guests will talk about for years.
      ''',
      shortDescription: 'Fireworks, cold pyro, and confetti blasts for grand entrances.',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80',
      features: [
        'Professional Fireworks Display',
        'Cold Pyro (Indoor Safe)',
        'Confetti Canon Blasts',
        'Low Fog / Cloud Effect',
        'Sparkular Machines',
        'Grand Bride & Groom Entry',
        'Cake Cutting Special Effects',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 4,
      pricing: {'PK': {'starting': 250000, 'unit': 'per show'}},
    ),

    // 5. Stage & Technical Setup
    Service(
      id: 'stage_technical_setup',
      title: 'Stage & Technical Setup',
      description: '''
State-of-the-art technical infrastructure for flawless event production. We provide high-resolution SMD/LED screens, professional concert-grade lighting, and robust trussing systems.

Our technical team ensures crystal clear sound and dazzling visuals, suitable for corporate presentations, musical performances, and grand wedding stages.
      ''',
      shortDescription: 'SMD/LED screens, professional lighting, and trussing systems.',
      imageUrl: 'https://images.unsplash.com/photo-1514525253440-b393452e8d26?w=800&q=80',
      features: [
        'High-Res SMD / LED Video Walls',
        'Professional Intelligent Lighting',
        'Heavy Duty Trussing Systems',
        'Concert Sound Systems',
        'Stage Fabrication',
        '3D Stage Design',
        'AV Technical Support',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 5,
      pricing: {'PK': {'starting': 900000, 'unit': 'per setup'}},
    ),

    // 6. Corporate Catering & Staffing
    Service(
      id: 'corporate_catering_staffing',
      title: 'Corporate Catering & Staffing',
      description: '''
Professional catering solutions tailored for the corporate world. From high-stakes board meetings to large-scale seminars, we provide hygienic, delicious food and impeccable service.

Our staff is rigorously trained, uniformed, and strictly adheres to hygiene protocols, representing your brand with the utmost professionalism.
      ''',
      shortDescription: 'Professional catering for meetings & seminars with trained, uniformed staff.',
      imageUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800&q=80',
      features: [
        'Meeting & Seminar Catering',
        'Executive Box Lunches',
        'Uniformed Professional Waiters',
        'Hygienic Serving Standards',
        'Buffet & Seated Service',
        'Coffee & Tea Service',
        'On-site Kitchen Management',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 6,
      pricing: {'PK': {'starting': 4500, 'unit': 'per person'}},
    ),

    // 7. Office Events & Corporate Dining
    Service(
      id: 'office_events_dining',
      title: 'Office Events & Corporate Dining',
      description: '''
Complete dining solutions for your office events. We arrange everything from daily office lunches to elaborate high-teas and corporate dinners.

Our service includes full setup with tables, chairs, premium cutlery, and dedicated serving staff, transforming your office space into a fine dining venue.
      ''',
      shortDescription: 'Office lunches, high-tea, and corporate dinners with complete setup.',
      imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&q=80',
      features: [
        'Daily Office Lunches',
        'Corporate High-Tea',
        'Annual Dinner Setup',
        'Tables & Chairs Rental',
        'Premium Cutlery & Crockery',
        'Dedicated Serving Staff',
        'Post-Event Cleanup',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 7,
      pricing: {'PK': {'starting': 5500, 'unit': 'per person'}},
    ),

    // 8. Live Food Stations
    Service(
      id: 'live_food_stations',
      title: 'Live Food Stations',
      description: '''
Add an interactive culinary element to your event with our Live Food Stations. Chefs prepare fresh delicacies right in front of your guests, engaging their senses.

Options include sizzling BBQ stations, artisanal tea & coffee counters, pasta bars, and more. A guaranteed crowd-pleaser that adds life to any party.
      ''',
      shortDescription: 'BBQ live stations, tea & coffee counters, and interactive food displays.',
      imageUrl: 'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?w=800&q=80',
      features: [
        'Live BBQ Grills',
        'Gourmet Tea & Coffee Bar',
        'Live Pasta Station',
        'Shawarma & Kebab Stations',
        'Fried Items Station',
        'Chatpata Corner (Chaat/Gol Gappay)',
        'Fresh Juice Bar',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 8,
      pricing: {'PK': {'starting': 85000, 'unit': 'per station'}},
    ),

    // 9. Kids Birthday Entertainment
    Service(
      id: 'kids_birthday_entertainment',
      title: 'Kids Birthday Entertainment',
      description: '''
Turn your child's birthday into an adventure playground! We provide a variety of high-energy entertainment options including safe jumping castles, fun slides, and bungee trampolines.

Our equipment is well-maintained and supervised to ensure maximum safety and fun for the little ones.
      ''',
      shortDescription: 'Jumping castles, slides, and bungee trampolines for kids.',
      imageUrl: 'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800&q=80',
      features: [
        'Themed Jumping Castles',
        'Inflatable Slides',
        'Bungee Trampolines',
        'Soft Play Area',
        'Ball Pits',
        'Safety Supervisors',
        'Clean & Sanitized Equipment',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 9,
      pricing: {'PK': {'starting': 35000, 'unit': 'per item'}},
    ),

    // 10. Kids Entertainment Activities
    Service(
      id: 'kids_entertainment_activities',
      title: 'Kids Entertainment Activities',
      description: '''
Engaging performances and activities to keep children mesmerized. Our talented entertainers include magicians, puppet masters, and face painters who bring joy and laughter.

Perfect for engaging kids throughout the event with interactive shows and creative fun.
      ''',
      shortDescription: 'Magic shows, puppet shows, and face painting.',
      imageUrl: 'https://images.unsplash.com/photo-1531315630201-bb15abeb1653?w=800&q=80',
      features: [
        'Live Magic Shows',
        'Puppet Theatre',
        'Professional Face Painting',
        'Balloon Twisting',
        'Storytelling Sessions',
        'Mascot Appearances',
        'Interactive Games Host',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 10,
      pricing: {'PK': {'starting': 45000, 'unit': 'per show'}},
    ),

    // 11. Birthday & Party Decor
    Service(
      id: 'birthday_party_decor',
      title: 'Birthday & Party Decor',
      description: '''
Trendy and vibrant decor for modern parties. We create Instagram-worthy backdrops using ring arches, neon signs, and shimmer walls.

Whether it's a first birthday or a milestone celebration, our themed decor elements are customized to match your style and color palette.
      ''',
      shortDescription: 'Ring arches, neon signs, shimmer walls, and themed elements.',
      imageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&q=80',
      features: [
        'Balloon Ring Arches',
        'Custom Neon Signs',
        'Sequined Shimmer Walls',
        'Themed Backdrops',
        'Cake Pedestals',
        'Fairy Lighting',
        'Personalized Signage',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 11,
      pricing: {'PK': {'starting': 95000, 'unit': 'per setup'}},
    ),

    // 12. Kids-Safe Crockery
    Service(
      id: 'kids_safe_crockery',
      title: 'Kids-Safe Crockery',
      description: '''
Safety first! We provide themed paper plates and high-quality melamine crockery specially designed for children's parties.

This ensures a worry-free environment where you don't have to stress about glass breakage or injuries, all while keeping the theme fun and colorful.
      ''',
      shortDescription: 'Themed paper plates and melamine crockery to avoid injuries.',
      imageUrl: 'https://images.unsplash.com/photo-1595246140625-573b715d11dc?w=800&q=80',
      features: [
        'Themed Paper Plates & Cups',
        'Unbreakable Melamine Crockery',
        'Disposable Cutlery',
        'Colored Napkins',
        'Safety-First Design',
        'Character Themed Sets',
        'Eco-friendly Options',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 12,
      pricing: {'PK': {'starting': 15000, 'unit': 'per package'}},
    ),

    // 13. Gifts & Goodie Stations
    Service(
      id: 'gifts_goodie_stations',
      title: 'Gifts & Goodie Stations',
      description: '''
A delightful way to thank your guests. We set up attractive counters for goodie bag and gift distribution at the end of your event.

Organized, decorated, and managed by our staff to ensure every guest sends off with a smile and a token of appreciation.
      ''',
      shortDescription: 'Goodie bag and gift distribution counters.',
      imageUrl: 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=800&q=80',
      features: [
        'Decorated Distribution Counters',
        'Goodie Bag Assembly',
        'Organized Distribution',
        'Themed Gift Displays',
        'Thank You Cards',
        'Staff Managed Counter',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 13,
      pricing: {'PK': {'starting': 25000, 'unit': 'per station'}},
    ),

    // 14. Beverage & Drink Counters
    Service(
      id: 'beverage_drink_counters',
      title: 'Beverage & Drink Counters',
      description: '''
Keep your guests refreshed with our specialized beverage counters. From standard cold drinks to exotic Mint Margaritas and colorful Mocktails.

Our bartenders mix drinks fresh on the spot, creating a functional and visual highlight for your event.
      ''',
      shortDescription: 'Cold drinks, Mint Margarita, Mocktails, and special drink bars.',
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&q=80',
      features: [
        'Mint Margarita Station',
        'Fresh Lime Bar',
        'Assorted Soft Drinks',
        'Custom Mocktails',
        'Slush Machines',
        'Mineral Water Service',
        'Ice & Garnish Setup',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 14,
      pricing: {'PK': {'starting': 75000, 'unit': 'per station'}},
    ),

    // 15. Service Staff
    Service(
      id: 'service_staff',
      title: 'Service Staff',
      description: '''
The backbone of any successful event. We provide highly trained, well-groomed, and uniformed service staff.

Our waiters, ushers, and coordinators are trained in hospitality etiquette, ensuring your guests are treated with respect and attended to promptly.
      ''',
      shortDescription: 'Trained waiters, uniformed staff, and hygienic serving standards.',
      imageUrl: 'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?w=800&q=80',
      features: [
        'Professional Waiters',
        'Uniformed Ushers',
        'Event Supervisors',
        'Bartenders',
        'Cleanup Crew',
        'Hospitality Etiquette Trained',
        'Hygiene Certified',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 15,
      pricing: {'PK': {'starting': 8000, 'unit': 'per staff'}},
    ),

    // 16. Customized Packages
    Service(
      id: 'customized_packages',
      title: 'Customized Packages',
      description: '''
Don't see exactly what you need? We offer fully flexible, budget-based customized packages for both corporate and private clients.

Tell us your requirements and budget, and we will tailor a solution that maximizes value without compromising on quality.
      ''',
      shortDescription: 'Budget-based customized packages with flexible options.',
      imageUrl: 'https://images.unsplash.com/photo-1551818255-e6e10975bc17?w=800&q=80',
      features: [
        'Budget-Oriented Planning',
        'Mix & Match Services',
        'Flexible Menu Selection',
        'Venue Sourcing',
        'Personalized Consultations',
        'Transparent Pricing',
        'Tailored Corporate Deals',
      ],
      regions: ['PK'],
      isActive: true,
      displayOrder: 16,
      pricing: {'PK': {'starting': 0, 'unit': 'custom'}},
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
