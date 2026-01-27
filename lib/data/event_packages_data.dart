import 'package:flutter/material.dart';
import '../core/models/event_package.dart';

/// Complete Event Packages Data following the multi-level navigation structure:
/// Wedding → Mehndi/Barat/Valima/Dholki → Economy/Premium/Royal packages
/// Corporate → Office Lunches/Seminars/Galas → packages
/// Birthday → Kids/Adults → packages

class EventPackagesData {
  
  // ===========================================================================
  // WEDDING - MEHNDI PACKAGES (The "Chatkhara" Series)
  // ===========================================================================
  
  static final mehndiEco1 = PackageTier(
    id: 'mehndi_eco_1',
    name: 'The Street Mehndi',
    subtitle: 'Fun Street Food Festival',
    description: 'Colorful street-style snacks for a lively Mehndi night.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1400},
    featuresLegacy: ['Live Stalls', 'Street Style', 'Colorful'],
    idealFor: ['Casual Mehndi', 'Outdoor Events'],
    servingCapacity: 'Min 50 Guests',
    menuItems: [
      'Gol Gappa Station',
      'Dahi Bhalla',
      'Papri Chaat',
      'Samosa Chaat',
      'Rooh Afza Sharbat',
    ],
    tags: ['🌶️ Chatpata', '🎉 Fun'],
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
  );

  static final mehndiEco2 = PackageTier(
    id: 'mehndi_eco_2',
    name: 'The Tikka Night',
    subtitle: 'BBQ Focus',
    description: 'Simple BBQ-centric menu for a fun Mehndi.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1600},
    featuresLegacy: ['Live BBQ', 'Spicy', 'Youth Favorite'],
    idealFor: ['Young Crowds', 'Night Events'],
    servingCapacity: 'Min 50 Guests',
    menuItems: [
      'Chicken Tikka Boti',
      'Seekh Kabab',
      'Puri Paratha',
      'Imli Chutney',
      'Fresh Salad',
      'Cold Drinks',
    ],
    tags: ['🔥 BBQ', '🌙 Night'],
    imageUrl: 'https://images.unsplash.com/photo-1599487488170-9a1204f9eb37?w=800&q=80',
  );

  static final mehndiPrem1 = PackageTier(
    id: 'mehndi_prem_1',
    name: 'The Complete Chatkhara',
    subtitle: 'Full Street Food Experience',
    description: 'All your favorite chaat items plus live Jalebi.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 2200},
    featuresLegacy: ['Live Jalebi', 'Multiple Stalls', 'Instagram-worthy'],
    idealFor: ['Grand Mehndi', 'Large Gatherings'],
    servingCapacity: 'Min 80 Guests',
    menuItems: [
      'Live Gol Gappa Counter',
      'Dahi Bhalla',
      'Aloo Tikki Chaat',
      'Chana Chaat',
      'Live Jalebi Station',
      'Lassi Corner',
    ],
    tags: ['⭐ Popular', '📸 Instagram'],
    imageUrl: 'https://images.unsplash.com/photo-1606471191009-63994c53433b?w=800&q=80',
  );

  static final mehndiPrem2 = PackageTier(
    id: 'mehndi_prem_2',
    name: 'The Fusion Mehndi',
    subtitle: 'Continental + Desi Mix',
    description: 'Modern fusion menu with traditional favorites.',
    tierLevel: 2,
    basePriceByRegion: {'PK': 2400},
    featuresLegacy: ['Fusion Menu', 'Modern', 'Unique'],
    idealFor: ['Modern Couples', 'Themed Events'],
    servingCapacity: 'Min 80 Guests',
    menuItems: [
      'Chicken Shawarma Station',
      'Loaded Fries',
      'Dahi Bhalla',
      'Fruit Chaat',
      'Mocktail Bar',
      'Mini Desserts',
    ],
    tags: ['🌍 Fusion', '✨ Modern'],
    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
  );

  static final mehndiRoyal1 = PackageTier(
    id: 'mehndi_royal_1',
    name: 'The Royal Mehndi',
    subtitle: 'Premium Street Festival',
    description: 'Luxurious take on street food with premium ingredients.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 3200},
    featuresLegacy: ['Premium Ingredients', 'Chef Specials', 'VIP Service'],
    idealFor: ['Elite Families', 'Celebrity Events'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Gourmet Gol Gappa (Flavored Waters)',
      'Aloo Tikki with Truffle',
      'Mutton Seekh Kabab',
      'Live Jalebi & Rabri',
      'Kulfi Falooda Station',
      'Premium Mocktails',
    ],
    tags: ['👑 Royal', '💎 Premium'],
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  );

  static final mehndiRoyal2 = PackageTier(
    id: 'mehndi_royal_2',
    name: 'The Grand Mehndi Feast',
    subtitle: 'Complete Entertainment Package',
    description: 'Full-service Mehndi with dhol players included.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 4000},
    featuresLegacy: ['Dhol Included', 'Full Service', 'Complete Setup'],
    idealFor: ['Grand Weddings', 'Full Night Events'],
    servingCapacity: 'Min 150 Guests',
    menuItems: [
      'Complete Chaat Counter',
      'Live BBQ Station',
      'Biryani Counter',
      'Dessert Bar',
      'Beverages Station',
      'Late Night Halwa Puri',
    ],
    tags: ['🎺 Entertainment', '🌟 Grand'],
    imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&q=80',
  );

  static final mehndiSubCategory = EventSubCategory(
    id: 'mehndi',
    name: 'Mehndi',
    description: 'The "Chatkhara" Series - Fun, colorful, spicy street food festival style',
    icon: '🎨',
    packages: [mehndiEco1, mehndiEco2, mehndiPrem1, mehndiPrem2, mehndiRoyal1, mehndiRoyal2],
    imageUrl: 'https://images.unsplash.com/photo-1583089892943-e02e5b017b6a?w=800&q=80',
  );

  // ===========================================================================
  // WEDDING - BARAT PACKAGES (The "Heavy" Series)
  // ===========================================================================

  static final baratEco1 = PackageTier(
    id: 'barat_eco_1',
    name: 'The Simple Barat',
    subtitle: 'Traditional Essentials',
    description: 'Classic Barat menu with essential items.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1800},
    featuresLegacy: ['Traditional', 'Value', 'Classic'],
    idealFor: ['Budget Weddings', 'Intimate Barats'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Chicken Korma',
      'Mutton Pulao',
      'Shami Kabab',
      'Naan',
      'Raita & Salad',
      'Kheer',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1596797038530-2c107229654b?w=800&q=80',
  );

  static final baratEco2 = PackageTier(
    id: 'barat_eco_2',
    name: 'The Desi Barat',
    subtitle: 'Home-style Flavors',
    description: 'Authentic home-style cooking for Barat.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 2000},
    featuresLegacy: ['Desi Ghee', 'Home Style', 'Authentic'],
    idealFor: ['Traditional Families', 'Classic Weddings'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Beef Korma (Desi Ghee)',
      'Chicken Biryani',
      'Dal Makhni',
      'Roghni Naan',
      'Green Salad',
      'Zarda',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
  );

  static final baratPrem1 = PackageTier(
    id: 'barat_prem_1',
    name: 'The Grand Barat',
    subtitle: 'Premium Meat Selection',
    description: 'Premium cuts and traditional preparations.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 2800},
    featuresLegacy: ['Premium Meat', 'Multiple Courses', 'Popular Choice'],
    idealFor: ['Premium Weddings', 'Large Barats'],
    servingCapacity: 'Min 150 Guests',
    menuItems: [
      'Mutton Kunna (Slow Cooked)',
      'Beef Korma',
      'Chicken Karahi',
      'Afghani Pulao',
      'Live Tandoor',
      'Gulab Jamun & Kheer',
    ],
    tags: ['⭐ Popular'],
    imageUrl: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=800&q=80',
  );

  static final baratPrem2 = PackageTier(
    id: 'barat_prem_2',
    name: 'The BBQ Barat',
    subtitle: 'Live BBQ Focus',
    description: 'BBQ-centric Barat with live cooking stations.',
    tierLevel: 2,
    basePriceByRegion: {'PK': 2600},
    featuresLegacy: ['Live BBQ', 'Interactive', 'Entertainment'],
    idealFor: ['Outdoor Barats', 'Evening Events'],
    servingCapacity: 'Min 150 Guests',
    menuItems: [
      'Live BBQ Station (4 Items)',
      'Mutton Karahi',
      'Chicken Biryani',
      'Fresh Naan',
      'Salads & Raita',
      'Ice Cream',
    ],
    tags: ['🔥 Live BBQ'],
    imageUrl: 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=800&q=80',
  );

  static final baratRoyal1 = PackageTier(
    id: 'barat_royal_1',
    name: 'The Royal Barat',
    subtitle: 'Signature Luxury',
    description: 'Our signature luxury Barat experience.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 4000},
    featuresLegacy: ['Whole Lamb', 'Premium Service', 'Royal Treatment'],
    idealFor: ['Elite Weddings', 'VIP Events'],
    servingCapacity: 'Min 200 Guests',
    menuItems: [
      'Whole Lamb Roast (Sajji)',
      'Mutton Biryani (Degi)',
      'Beef Nihari',
      'Chicken White Korma',
      'Live Tandoor Station',
      'Premium Dessert Bar',
    ],
    tags: ['👑 Royal', '🐑 Whole Lamb'],
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
  );

  static final baratRoyal2 = PackageTier(
    id: 'barat_royal_2',
    name: 'The Emperor\'s Feast',
    subtitle: 'Ultimate Luxury',
    description: 'The most lavish Barat experience possible.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 5500},
    featuresLegacy: ['Complete Setup', 'Unlimited Variety', 'White Glove Service'],
    idealFor: ['Grand Weddings', 'Celebrity Events'],
    servingCapacity: 'Min 300 Guests',
    menuItems: [
      'Whole Lamb Roast',
      'Mutton Kunna (Desi Ghee)',
      'Beef Korma Special',
      'Chicken Karahi',
      'Afghani Pulao',
      'Mutton Biryani',
      'Live BBQ (6 Items)',
      'Complete Dessert Counter',
    ],
    tags: ['👑 Emperor', '💎 Ultimate'],
    imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f29da8c059?w=800&q=80',
  );

  static final baratSubCategory = EventSubCategory(
    id: 'barat',
    name: 'Barat',
    description: 'The "Heavy" Series - Rich, abundant, premium meats',
    icon: '💍',
    packages: [baratEco1, baratEco2, baratPrem1, baratPrem2, baratRoyal1, baratRoyal2],
    imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&q=80',
  );

  // ===========================================================================
  // WEDDING - VALIMA PACKAGES (The "Elegant" Series)
  // ===========================================================================

  static final valimaEco1 = PackageTier(
    id: 'valima_eco_1',
    name: 'The Simple Valima',
    subtitle: 'Elegant Essentials',
    description: 'Sophisticated, lighter spice with cream-based korma.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1600},
    featuresLegacy: ['Cream Based', 'Mild Spice', 'Elegant'],
    idealFor: ['Intimate Valimas', 'Budget Conscious'],
    servingCapacity: 'Min 80 Guests',
    menuItems: [
      'Chicken White Korma (Cream based)',
      'Egg Fried Rice',
      'Chicken Manchurian (Indo-Chinese)',
      'Naan',
      'Fruit Custard',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&q=80',
  );

  static final valimaEco2 = PackageTier(
    id: 'valima_eco_2',
    name: 'The Roast & Rice',
    subtitle: 'Continental Touch',
    description: 'Steam roast with fried rice combination.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1800},
    featuresLegacy: ['Steam Roast', 'Continental', 'Popular'],
    idealFor: ['Modern Couples', 'Day Events'],
    servingCapacity: 'Min 80 Guests',
    menuItems: [
      'Chicken Steam Roast (Quarter pieces)',
      'Vegetable Fried Rice',
      'Chicken Jalfrezi',
      'Naan',
      'Kulfi Crunch',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
  );

  static final valimaPrem1 = PackageTier(
    id: 'valima_prem_1',
    name: 'The Continental Mix',
    subtitle: 'Best of Both Worlds',
    description: 'Beef Stroganoff and continental favorites.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 2600},
    featuresLegacy: ['Continental', 'Fusion', 'Trending'],
    idealFor: ['Modern Valimas', 'Young Couples'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Beef Stroganoff (Creamy Beef Curry)',
      'Garlic Butter Rice',
      'Chicken Cashew Nut',
      'Chicken Chow Mein',
      'Chocolate Brownie with Sauce',
    ],
    tags: ['⭐ Popular', '🌍 Continental'],
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
  );

  static final valimaPrem2 = PackageTier(
    id: 'valima_prem_2',
    name: 'The Modern Desi',
    subtitle: 'Desi with a Twist',
    description: 'Traditional flavors with modern presentation.',
    tierLevel: 2,
    basePriceByRegion: {'PK': 2400},
    featuresLegacy: ['Modern Desi', 'Turkish Kabab', 'Unique'],
    idealFor: ['Fusion Lovers', 'Trendy Events'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Beef White Korma',
      'Peas Pulao',
      'Turkish Kabab (Beef/Chicken Mix)',
      'Butter Chicken',
      'Rasmalai',
    ],
    tags: ['🇹🇷 Turkish'],
    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
  );

  static final valimaRoyal1 = PackageTier(
    id: 'valima_royal_1',
    name: 'The Executive Valima',
    subtitle: 'Premium Elegance',
    description: 'Mutton karahi and seafood for the executive taste.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 3500},
    featuresLegacy: ['Mutton Karahi', 'Seafood', 'Executive'],
    idealFor: ['Corporate Couples', 'Elite Families'],
    servingCapacity: 'Min 150 Guests',
    menuItems: [
      'Mutton White Karahi (Desi Ghee)',
      'Afghani Pulao (Mutton)',
      'Finger Fish with Tartar Sauce',
      'Palak Paneer (Spinach & Cheese)',
      'Cheesecake Slices',
    ],
    tags: ['👔 Executive', '🐟 Seafood'],
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
  );

  static final valimaRoyal2 = PackageTier(
    id: 'valima_royal_2',
    name: 'The Luxury Spread',
    subtitle: 'Ultimate Elegance',
    description: 'Premium seafood and live dessert counters.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 4500},
    featuresLegacy: ['Jumbo Prawns', 'Live Desserts', 'Luxury'],
    idealFor: ['Grand Valimas', 'VIP Events'],
    servingCapacity: 'Min 200 Guests',
    menuItems: [
      'Mutton Makhni Handi (Butter Mutton)',
      'Singaporean Rice (Layered Rice, Noodles & Creamy Chicken)',
      'Grilled Jumbo Prawns',
      'Stuffed Chicken Breast with White Sauce',
      'Live Jalebi & Ice Cream Counter',
    ],
    tags: ['👑 Luxury', '🦐 Prawns'],
    imageUrl: 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=800&q=80',
  );

  static final valimaSubCategory = EventSubCategory(
    id: 'valima',
    name: 'Valima',
    description: 'The "Elegant" Series - Sophisticated with continental touches',
    icon: '✨',
    packages: [valimaEco1, valimaEco2, valimaPrem1, valimaPrem2, valimaRoyal1, valimaRoyal2],
    imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f29da8c059?w=800&q=80',
  );

  // ===========================================================================
  // WEDDING - DHOLKI PACKAGES (The "Casual" Series)
  // ===========================================================================

  static final dholkiEco1 = PackageTier(
    id: 'dholki_eco_1',
    name: 'The Bun Kabab Night',
    subtitle: 'Street Food Vibes',
    description: 'Casual street food for an intimate Dholki.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1200},
    featuresLegacy: ['Casual', 'Fun', 'Street Food'],
    idealFor: ['Small Gatherings', 'Home Events'],
    servingCapacity: 'Min 30 Guests',
    menuItems: [
      'Bun Kabab Station',
      'French Fries',
      'Cold Drinks',
      'Chutney Varieties',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&q=80',
  );

  static final dholkiEco2 = PackageTier(
    id: 'dholki_eco_2',
    name: 'The Halwa Puri Breakfast',
    subtitle: 'Traditional Morning',
    description: 'Classic breakfast Dholki with halwa puri.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1000},
    featuresLegacy: ['Breakfast', 'Traditional', 'Morning'],
    idealFor: ['Morning Dholkis', 'Traditional Families'],
    servingCapacity: 'Min 40 Guests',
    menuItems: [
      'Suji Halwa',
      'Puri (Served Hot)',
      'Chana Masala',
      'Achar & Salad',
      'Chai',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&q=80',
  );

  static final dholkiPrem1 = PackageTier(
    id: 'dholki_prem_1',
    name: 'The BBQ Night',
    subtitle: 'Casual BBQ Party',
    description: 'Relaxed BBQ evening for Dholki celebrations.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 1800},
    featuresLegacy: ['Live BBQ', 'Night Event', 'Popular'],
    idealFor: ['Evening Dholkis', 'Young Crowds'],
    servingCapacity: 'Min 50 Guests',
    menuItems: [
      'Chicken Tikka',
      'Malai Boti',
      'Seekh Kabab',
      'Paratha',
      'Raita & Chutney',
      'Beverages',
    ],
    tags: ['⭐ Popular', '🔥 BBQ'],
    imageUrl: 'https://images.unsplash.com/photo-1599487488170-9a1204f9eb37?w=800&q=80',
  );

  static final dholkiPrem2 = PackageTier(
    id: 'dholki_prem_2',
    name: 'The Chai & Snacks',
    subtitle: 'Evening Tea Party',
    description: 'Tea-time themed Dholki with variety of snacks.',
    tierLevel: 2,
    basePriceByRegion: {'PK': 1600},
    featuresLegacy: ['Tea Party', 'Variety', 'Cozy'],
    idealFor: ['Ladies Dholkis', 'Afternoon Events'],
    servingCapacity: 'Min 40 Guests',
    menuItems: [
      'Assorted Samosas',
      'Spring Rolls',
      'Chicken Patties',
      'Sandwiches',
      'Chai Station',
      'Mini Desserts',
    ],
    tags: ['☕ Tea Party'],
    imageUrl: 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=800&q=80',
  );

  static final dholkiRoyal1 = PackageTier(
    id: 'dholki_royal_1',
    name: 'The Grand Dholki',
    subtitle: 'Full Night Celebration',
    description: 'Complete Dholki package with dinner and snacks.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 2800},
    featuresLegacy: ['Full Night', 'Complete Menu', 'Premium'],
    idealFor: ['Large Dholkis', 'Night Long Events'],
    servingCapacity: 'Min 80 Guests',
    menuItems: [
      'Evening Snacks Counter',
      'Live BBQ Station',
      'Biryani',
      'Dessert Bar',
      'Chai & Coffee Station',
      'Late Night Bun Kabab',
    ],
    tags: ['🌙 Full Night'],
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  );

  static final dholkiRoyal2 = PackageTier(
    id: 'dholki_royal_2',
    name: 'The Premium Dholki Night',
    subtitle: 'Luxury Casual',
    description: 'Premium ingredients for an upscale Dholki.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 3200},
    featuresLegacy: ['Premium', 'Luxury Casual', 'VIP'],
    idealFor: ['Elite Families', 'Special Occasions'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Premium BBQ (Mutton Items)',
      'Chicken White Korma',
      'Fried Rice',
      'Premium Desserts',
      'Mocktail Bar',
      'Late Night Street Food',
    ],
    tags: ['💎 Premium'],
    imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=800&q=80',
  );

  static final dholkiSubCategory = EventSubCategory(
    id: 'dholki',
    name: 'Dholki',
    description: 'The "Casual" Series - Intimate, home-style comfort food',
    icon: '🥁',
    packages: [dholkiEco1, dholkiEco2, dholkiPrem1, dholkiPrem2, dholkiRoyal1, dholkiRoyal2],
    imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800&q=80',
  );

  // ===========================================================================
  // WEDDING CATEGORY
  // ===========================================================================

  static final weddingCategory = EventCategory(
    id: 'wedding',
    name: 'Wedding Events',
    description: 'Traditional & Royal Wedding Celebrations - Mehndi, Barat, Valima & Dholki',
    icon: Icons.favorite,
    color: const Color(0xFFE91E63), // Pink for weddings
    order: 1, // Wedding First
    subCategories: [mehndiSubCategory, baratSubCategory, valimaSubCategory, dholkiSubCategory],
    imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=1920&q=80',
  );

  // ===========================================================================
  // CORPORATE PACKAGES
  // ===========================================================================

  static final corpLunch1 = PackageTier(
    id: 'corp_lunch_1',
    name: 'Office Lunch Basic',
    subtitle: 'Simple & Professional',
    description: 'Basic lunch package for office meetings.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1200},
    featuresLegacy: ['Quick Service', 'Professional', 'Value'],
    idealFor: ['Daily Meetings', 'Small Teams'],
    servingCapacity: 'Min 20 Guests',
    menuItems: [
      'Chicken Biryani',
      'Raita',
      'Salad',
      'Cold Drinks',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  );

  static final corpLunch2 = PackageTier(
    id: 'corp_lunch_2',
    name: 'Executive Lunch',
    subtitle: 'Premium Office Catering',
    description: 'Premium lunch for executive meetings.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1600},
    featuresLegacy: ['Executive', 'Variety', 'Professional Setup'],
    idealFor: ['Board Meetings', 'Client Visits'],
    servingCapacity: 'Min 20 Guests',
    menuItems: [
      'Chicken Karahi',
      'Mutton Pulao',
      'Fresh Naan',
      'Garden Salad',
      'Kheer',
      'Green Tea',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
  );

  static final corpSeminar1 = PackageTier(
    id: 'corp_seminar_1',
    name: 'Seminar Package',
    subtitle: 'Full Day Event',
    description: 'Complete catering for seminars and conferences.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 2200},
    featuresLegacy: ['Full Day', 'Multiple Meals', 'Refreshments'],
    idealFor: ['Conferences', 'Training Sessions'],
    servingCapacity: 'Min 50 Guests',
    menuItems: [
      'Morning Tea & Snacks',
      'Lunch Buffet (3 Items)',
      'Evening Tea',
      'Refreshments Throughout',
    ],
    tags: ['⭐ Popular'],
    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
  );

  static final corpSeminar2 = PackageTier(
    id: 'corp_seminar_2',
    name: 'Training Day Package',
    subtitle: 'Productive Day',
    description: 'Keep your team energized throughout training.',
    tierLevel: 2,
    basePriceByRegion: {'PK': 1800},
    featuresLegacy: ['Energizing', 'Continuous Service', 'Healthy Options'],
    idealFor: ['Workshops', 'Team Training'],
    servingCapacity: 'Min 30 Guests',
    menuItems: [
      'Healthy Breakfast',
      'Sandwich Lunch',
      'Fresh Fruits',
      'Tea/Coffee All Day',
      'Energy Snacks',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800&q=80',
  );

  static final corpGala1 = PackageTier(
    id: 'corp_gala_1',
    name: 'Corporate Gala Dinner',
    subtitle: 'Elegance & Class',
    description: 'Elegant dinner for corporate galas and awards.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 3500},
    featuresLegacy: ['Formal Service', 'Premium Menu', 'Elegant Setup'],
    idealFor: ['Award Ceremonies', 'Annual Dinners'],
    servingCapacity: 'Min 100 Guests',
    menuItems: [
      'Welcome Drinks & Canapes',
      'Continental Soup',
      'Main Course (2 proteins)',
      'Premium Rice',
      'Dessert Selection',
      'Coffee Service',
    ],
    tags: ['🏆 Gala'],
    imageUrl: 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&q=80',
  );

  static final corpGala2 = PackageTier(
    id: 'corp_gala_2',
    name: 'Product Launch Event',
    subtitle: 'Impressive Presentation',
    description: 'Make an impression at your product launch.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 4000},
    featuresLegacy: ['Themed Setup', 'Cocktail Style', 'Impressive'],
    idealFor: ['Product Launches', 'Media Events'],
    servingCapacity: 'Min 80 Guests',
    menuItems: [
      'Signature Mocktails',
      'Premium Canapes Selection',
      'Live Food Stations (2)',
      'Dessert Counter',
      'Branded Refreshments',
    ],
    tags: ['🚀 Launch'],
    imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800&q=80',
  );

  static final officeLunchSubCategory = EventSubCategory(
    id: 'office_lunches',
    name: 'Office Lunches',
    description: 'Quick and professional catering for daily office needs',
    icon: '💼',
    packages: [corpLunch1, corpLunch2],
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
  );

  static final seminarsSubCategory = EventSubCategory(
    id: 'seminars',
    name: 'Seminars & Meetings',
    description: 'Full-day catering for conferences and training',
    icon: '📊',
    packages: [corpSeminar1, corpSeminar2],
    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
  );

  static final galasSubCategory = EventSubCategory(
    id: 'galas',
    name: 'Galas & Launches',
    description: 'Impressive catering for special corporate events',
    icon: '🏆',
    packages: [corpGala1, corpGala2],
    imageUrl: 'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=800&q=80',
  );

  static final corporateCategory = EventCategory(
    id: 'corporate',
    name: 'Corporate Events',
    description: 'Professional Meetings, Seminars & Gala Dinners',
    icon: Icons.business,
    color: const Color(0xFF1976D2), // Blue for corporate
    order: 2, // Corporate Second
    subCategories: [officeLunchSubCategory, seminarsSubCategory, galasSubCategory],
    imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1920&q=80',
  );

  // ===========================================================================
  // BIRTHDAY PACKAGES
  // ===========================================================================

  static final kidsParty1 = PackageTier(
    id: 'kids_party_1',
    name: 'Fun Party Basic',
    subtitle: 'Simple & Fun',
    description: 'Basic kids party with favorite foods.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1200},
    featuresLegacy: ['Kid Favorites', 'Fun', 'Colorful'],
    idealFor: ['Small Parties', 'Home Events'],
    servingCapacity: 'Min 20 Kids',
    menuItems: [
      'Chicken Nuggets',
      'French Fries',
      'Mini Burgers',
      'Juice Boxes',
      'Birthday Cake',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&q=80',
  );

  static final kidsParty2 = PackageTier(
    id: 'kids_party_2',
    name: 'Pizza Party',
    subtitle: 'Kids Love It',
    description: 'Pizza-themed party for pizza lovers.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1400},
    featuresLegacy: ['Pizza', 'Popular', 'Easy'],
    idealFor: ['School Friends', 'Pizza Lovers'],
    servingCapacity: 'Min 25 Kids',
    menuItems: [
      'Assorted Pizza (3 flavors)',
      'Garlic Bread',
      'Pasta',
      'Soft Drinks',
      'Ice Cream',
      'Birthday Cake',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&q=80',
  );

  static final kidsParty3 = PackageTier(
    id: 'kids_party_3',
    name: 'Carnival Party',
    subtitle: 'Theme Park Vibes',
    description: 'Carnival-themed party with live counters.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 2200},
    featuresLegacy: ['Theme', 'Live Counters', 'Entertainment'],
    idealFor: ['Grand Parties', 'Outdoor Events'],
    servingCapacity: 'Min 40 Kids',
    menuItems: [
      'Cotton Candy Station',
      'Popcorn Bar',
      'Hot Dogs',
      'Pizza Slices',
      'Ice Cream Sundae Bar',
      'Themed Cake',
    ],
    tags: ['⭐ Popular', '🎪 Carnival'],
    imageUrl: 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=800&q=80',
  );

  static final adultParty1 = PackageTier(
    id: 'adult_party_1',
    name: 'Casual Celebration',
    subtitle: 'Relaxed Vibes',
    description: 'Casual birthday dinner with friends.',
    tierLevel: 1,
    basePriceByRegion: {'PK': 1800},
    featuresLegacy: ['Casual', 'Flexible', 'Social'],
    idealFor: ['Friends Gatherings', 'Home Parties'],
    servingCapacity: 'Min 20 Adults',
    menuItems: [
      'BBQ Platter',
      'Biryani',
      'Naan',
      'Salads',
      'Birthday Cake',
      'Soft Drinks',
    ],
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
  );

  static final adultParty2 = PackageTier(
    id: 'adult_party_2',
    name: 'Elegant Dinner Party',
    subtitle: 'Sophisticated Celebration',
    description: 'Elegant dinner party for milestone birthdays.',
    tierLevel: 2,
    isMostPopular: true,
    basePriceByRegion: {'PK': 2800},
    featuresLegacy: ['Elegant', 'Premium', 'Milestone'],
    idealFor: ['40th/50th Birthdays', 'Special Occasions'],
    servingCapacity: 'Min 30 Adults',
    menuItems: [
      'Welcome Drinks',
      'Continental Appetizers',
      'Main Course (2 options)',
      'Premium Rice',
      'Dessert Selection',
      'Designer Cake',
    ],
    tags: ['⭐ Popular'],
    imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
  );

  static final adultParty3 = PackageTier(
    id: 'adult_party_3',
    name: 'Grand Celebration',
    subtitle: 'Luxury Party',
    description: 'Grand celebration with premium everything.',
    tierLevel: 3,
    basePriceByRegion: {'PK': 4000},
    featuresLegacy: ['Luxury', 'Premium', 'Unforgettable'],
    idealFor: ['Grand Celebrations', 'VIP Events'],
    servingCapacity: 'Min 50 Adults',
    menuItems: [
      'Signature Mocktails',
      'Premium Appetizer Selection',
      'Live BBQ Station',
      'Multiple Main Courses',
      'Live Dessert Counter',
      'Premium Cake',
      'Coffee Bar',
    ],
    tags: ['👑 Grand'],
    imageUrl: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&q=80',
  );

  static final kidsSubCategory = EventSubCategory(
    id: 'kids_parties',
    name: 'Kids Parties',
    description: 'Fun and colorful parties for children',
    icon: '🎈',
    packages: [kidsParty1, kidsParty2, kidsParty3],
    imageUrl: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&q=80',
  );

  static final adultsSubCategory = EventSubCategory(
    id: 'adult_parties',
    name: 'Adult Celebrations',
    description: 'Elegant parties for milestone birthdays',
    icon: '🥂',
    packages: [adultParty1, adultParty2, adultParty3],
    imageUrl: 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?w=800&q=80',
  );

  static final birthdayCategory = EventCategory(
    id: 'birthday',
    name: 'Birthday Parties',
    description: 'Kids & Adults Birthday Celebrations',
    icon: Icons.cake,
    color: const Color(0xFF9C27B0), // Purple for birthdays
    order: 3, // Birthday Third
    subCategories: [kidsSubCategory, adultsSubCategory],
    imageUrl: 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?w=1920&q=80',
  );

  // ===========================================================================
  // ALL CATEGORIES
  // ===========================================================================

  static List<EventCategory> getAllEventCategories() {
    return [weddingCategory, corporateCategory, birthdayCategory];
  }
}
