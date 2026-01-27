// 🍽️ MAMA EVENTS - Complete Menu Data
// This file contains all menu items organized by category
// Images are left as empty strings - uncomment and add your image URLs when ready

import '../core/models/menu_item.dart';

class MenuData {
  // =============================================================================
  // 🥗 APPETIZERS (المقبلات)
  // =============================================================================
  
  static final List<MenuItem> appetizers = [
    // Arabic Mezze
    MenuItem(
      id: 'app_hummus_001',
      name: 'Classic Hummus',
      description: 'Smooth chickpea dip with tahini, olive oil, and a hint of garlic',
      category: 'Appetizers',
      // 📸 IMAGE: Uncomment below and add your image URL
      // imageUrl: 'https://your-domain.com/images/menu/hummus.jpg',
      imageUrl: '', // LEAVE BLANK - Add your image later
      prices: {'PK': 1200},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian', 'Vegan'],
      cuisineType: 'Middle Eastern',
    ),
    
    MenuItem(
      id: 'app_moutabal_002',
      name: 'Moutabal (Baba Ghanoush)',
      description: 'Smoky grilled eggplant mixed with tahini, garlic, and lemon',
      category: 'Appetizers',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 1500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian', 'Vegan'],
      cuisineType: 'Middle Eastern',
    ),
    
    MenuItem(
      id: 'app_vine_leaves_003',
      name: 'Stuffed Vine Leaves (Dolma)',
      description: 'Grape leaves stuffed with rice, herbs, and spices',
      category: 'Appetizers',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 1800},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian', 'Vegan'],
      cuisineType: 'Middle Eastern',
    ),
    
    // International Appetizers
    MenuItem(
      id: 'app_beef_sliders_004',
      name: 'Mini Beef Sliders',
      description: 'Gourmet mini burgers with caramelized onions and special sauce',
      category: 'Appetizers',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 2500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'International',
    ),
    
    MenuItem(
      id: 'app_caprese_005',
      name: 'Caprese Skewers',
      description: 'Fresh mozzarella, cherry tomatoes, and basil drizzled with balsamic',
      category: 'Appetizers',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 1800},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian'],
      cuisineType: 'International',
    ),
    
    // Desi Appetizers
    MenuItem(
      id: 'app_samosas_006',
      name: 'Chicken Samosas',
      description: 'Crispy pastry filled with spiced chicken and herbs',
      category: 'Live Tandoor',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 1000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Desi/South Asian',
    ),
  ];
  
  // =============================================================================
  // 🍖 MAIN COURSES - MIDDLE EASTERN (الأطباق الرئيسية - شرق أوسطي)
  // =============================================================================
  
  static final List<MenuItem> mainCoursesMiddleEastern = [
    MenuItem(
      id: 'main_lamb_ouzi_001',
      name: 'Lamb Ouzi with Oriental Rice',
      description: 'Slow-cooked lamb with aromatic oriental rice, garnished with nuts and raisins',
      category: 'Traditional Rice',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 8500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Middle Eastern',
      servings: '6-8 people',
    ),
    
    MenuItem(
      id: 'main_chicken_machboos_002',
      name: 'Chicken Machboos',
      description: 'Traditional Arabian rice dish with tender chicken and mixed spices',
      category: 'Main Course',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 6500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Middle Eastern',
      servings: '6-8 people',
    ),
    
    MenuItem(
      id: 'main_shish_taouk_003',
      name: 'Shish Taouk',
      description: 'Grilled marinated chicken skewers with garlic sauce and grilled vegetables',
      category: 'BBQ Specials',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 5500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Middle Eastern',
      servings: '4-6 people',
    ),
  ];
  
  // =============================================================================
  // 🍛 MAIN COURSES - DESI/SOUTH ASIAN (هندي باكستاني)
  // =============================================================================
  
  static final List<MenuItem> mainCoursesDesi = [
    MenuItem(
      id: 'main_mutton_biryani_001',
      name: 'Mutton Zafrani Biryani',
      description: 'Aromatic basmati rice layered with tender mutton, saffron, and traditional spices',
      category: 'Traditional Rice',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 7500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Desi/South Asian',
      servings: '6-8 people',
    ),
    
    MenuItem(
      id: 'main_chicken_karahi_002',
      name: 'Chicken Karahi',
      description: 'Traditional Pakistani curry cooked in a wok with tomatoes, ginger, and green chilies',
      category: 'Main Course',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 5500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Desi/South Asian',
      servings: '4-6 people',
    ),
    
    MenuItem(
      id: 'main_afghani_pulao_003',
      name: 'Afghani Pulao',
      description: 'Fragrant rice cooked with meat, carrots, and raisins in traditional Afghan style',
      category: 'Traditional Rice',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 6500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Desi/South Asian',
      servings: '6-8 people',
    ),
  ];
  
  // =============================================================================
  // 🍝 MAIN COURSES - INTERNATIONAL (عالمي)
  // =============================================================================
  
  static final List<MenuItem> mainCoursesInternational = [
    MenuItem(
      id: 'main_herb_salmon_001',
      name: 'Herb-Crusted Salmon',
      description: 'Pan-seared salmon fillet with herb crust, served with roasted vegetables',
      category: 'Main Course',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 9500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Dairy-Free'],
      cuisineType: 'International',
      servings: '1 person',
    ),
    
    MenuItem(
      id: 'main_mushroom_risotto_002',
      name: 'Mushroom Risotto',
      description: 'Creamy arborio rice with wild mushrooms, parmesan, and truffle oil',
      category: 'Main Course',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 4500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian'],
      cuisineType: 'International',
      servings: '1 person',
    ),
    
    MenuItem(
      id: 'main_beef_tenderloin_003',
      name: 'Beef Tenderloin',
      description: 'Premium beef tenderloin with black pepper sauce and seasonal vegetables',
      category: 'Main Course',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 12000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'International',
      servings: '1 person',
    ),
  ];
  
  // =============================================================================
  // 🍰 DESSERTS (الحلويات)
  // =============================================================================
  
  static final List<MenuItem> desserts = [
    MenuItem(
      id: 'dessert_um_ali_001',
      name: 'Um Ali',
      description: 'Traditional Egyptian bread pudding with nuts, raisins, and cream',
      category: 'Desserts',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 2500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian'],
      cuisineType: 'Middle Eastern',
    ),
    
    MenuItem(
      id: 'dessert_shahi_tukray_002',
      name: 'Shahi Tukray',
      description: 'Royal bread pudding soaked in rich milk, garnished with nuts and silver leaf',
      category: 'Desserts',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 2000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian'],
      cuisineType: 'Desi/South Asian',
    ),
    
    MenuItem(
      id: 'dessert_gulab_jamun_003',
      name: 'Gulab Jamun',
      description: 'Soft milk dumplings soaked in rose-flavored sugar syrup',
      category: 'Desserts',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 1500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian'],
      cuisineType: 'Desi/South Asian',
    ),
    
    MenuItem(
      id: 'dessert_chocolate_cremieux_004',
      name: 'Chocolate Cremieux',
      description: 'Rich chocolate mousse with hazelnut praline and gold leaf',
      category: 'Desserts',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 3500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian'],
      cuisineType: 'International',
    ),
  ];
  
  // =============================================================================
  // ☕ BEVERAGES (المشروبات)
  // =============================================================================
  
  static final List<MenuItem> beverages = [
    MenuItem(
      id: 'bev_virgin_mojito_001',
      name: 'Virgin Mojito',
      description: 'Refreshing mint and lime drink with sparkling water',
      category: 'Beverages',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegan'],
      cuisineType: 'International',
    ),
    
    MenuItem(
      id: 'bev_arabic_coffee_002',
      name: 'Arabic Gahwa',
      description: 'Traditional Arabian coffee with cardamom, served with dates',
      category: 'Beverages',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 400},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegan'],
      cuisineType: 'Middle Eastern',
    ),
    
    MenuItem(
      id: 'bev_moroccan_tea_003',
      name: 'Moroccan Mint Tea',
      description: 'Sweet green tea with fresh mint leaves',
      category: 'Beverages',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 450},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegan'],
      cuisineType: 'Middle Eastern',
    ),
  ];
  
  // =============================================================================
  // 👨‍🍳 LIVE INTERACTION STATIONS (محطات الطهي المباشر)
  // =============================================================================
  
  static final List<MenuItem> liveStations = [
    MenuItem(
      id: 'live_shawarma_001',
      name: 'Live Shawarma Station',
      description: 'Fresh shawarma prepared by our expert chefs with your choice of toppings',
      category: 'Live Tandoor',
      // 📸 IMAGE: Add your image URL here
      // 🎥 VIDEO: You can also add a video URL for live stations
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 150000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Middle Eastern',
      servings: '50-75 people',
      liveStation: true,
    ),
    
    MenuItem(
      id: 'live_pasta_002',
      name: 'Live Pasta Station',
      description: 'Interactive pasta bar with multiple sauces and fresh ingredients',
      category: 'Live Stations',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 18000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Vegetarian Option'],
      cuisineType: 'International',
      servings: '50-75 people',
      liveStation: true,
    ),
    
    MenuItem(
      id: 'live_bbq_003',
      name: 'Live BBQ Station',
      description: 'Grilled meats and vegetables prepared fresh at your event',
      category: 'Live Stations',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 200000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'International',
      servings: '50-75 people',
      liveStation: true,
    ),
    
    MenuItem(
      id: 'live_sushi_004',
      name: 'Live Sushi Station',
      description: 'Professional sushi chef preparing fresh rolls and nigiri',
      category: 'Live Stations',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 25000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'International',
      servings: '50-75 people',
      liveStation: true,
    ),
    MenuItem(
      id: 'live_sushi_004',
      name: 'Live Sushi Station',
      description: 'Professional sushi chef preparing fresh rolls and nigiri',
      category: 'Live Stations',
      // 📸 IMAGE: Add your image URL here
      imageUrl: '', // LEAVE BLANK
      prices: {'PK': 25000},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'International',
      servings: '50-75 people',
      liveStation: true,
    ),
  ];

  // =============================================================================
  // 🎂 CAKES ON DEMAND (الكيك عند الطلب)
  // =============================================================================
  
  static final List<MenuItem> cakes = [
    MenuItem(
      id: 'cake_choc_fudge_001',
      name: 'Signature Chocolate Fudge Cake',
      description: 'Rich, moist chocolate layers with Belgian chocolate ganache',
      category: 'Cakes on Demand',
      imageUrl: '', // READY FOR BASE64
      prices: {'PK': 2500}, // Price per pound
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal', 'Contains Eggs'],
      cuisineType: 'Bakery',
    ),
    MenuItem(
      id: 'cake_red_velvet_002',
      name: 'Classic Red Velvet',
      description: 'Velvety red sponge with creamy cream cheese frosting',
      category: 'Cakes on Demand',
      imageUrl: '', // READY FOR BASE64
      prices: {'PK': 2800},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Bakery',
    ),
    MenuItem(
      id: 'cake_lotus_003',
      name: 'Lotus Biscoff Dream',
      description: 'Lotus flavored cake topped with Biscoff spread and crushed cookies',
      category: 'Cakes on Demand',
      imageUrl: '', // READY FOR BASE64
      prices: {'PK': 3500},
      available: true,
      regions: ['PK'],
      dietaryTags: ['Halal'],
      cuisineType: 'Bakery',
    ),
  ];
  
  // =============================================================================
  // 📋 HELPER METHODS
  // =============================================================================
  
  /// Get all menu items
  static List<MenuItem> getAllItems() {
    return [
      ...appetizers,
      ...mainCoursesMiddleEastern,
      ...mainCoursesDesi,
      ...mainCoursesInternational,
      ...desserts,
      ...beverages,
      ...liveStations,
      ...cakes,
    ];
  }
  
  /// Get items by category
  static List<MenuItem> getItemsByCategory(String category) {
    return getAllItems().where((item) => item.category == category).toList();
  }
  
  /// Get live station items
  static List<MenuItem> getLiveStations() {
    return liveStations;
  }
  
  /// Get items by cuisine type
  static List<MenuItem> getItemsByCuisine(String cuisineType) {
    return getAllItems().where((item) => item.cuisineType == cuisineType).toList();
  }
  
  /// Get featured items (for homepage)
  static List<MenuItem> getFeaturedItems() {
    // Return first 6 items from each category
    return [
      ...appetizers.take(2),
      ...mainCoursesMiddleEastern.take(2),
      ...mainCoursesDesi.take(1),
      ...desserts.take(1),
    ];
  }
}
