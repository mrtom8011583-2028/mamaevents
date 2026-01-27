import '../core/models/live_station_add_on.dart';

class LiveStationData {
  static const List<LiveStationAddOn> allStations = [
    LiveStationAddOn(
      id: 'gol_gappa',
      name: 'Gol Gappa Station',
      description: 'Review: "The most hygienic and spicy Gol Gappas inside the wedding hall."',
      price: 25000, // Estimated lump sum for setup
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&q=80',
    ),
    LiveStationAddOn(
      id: 'jalebi',
      name: 'Live Jalebi Station',
      description: 'Hot, crispy Jalebis fried right in front of your guests.',
      price: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1515546252445-42bf750a905f?w=800&q=80', // Sweet/Dessert placeholder
    ),
    LiveStationAddOn(
      id: 'pink_tea',
      name: 'Pink Tea (Kashmiri Chai)',
      description: 'Authentic Kashmiri Tea topped with crushed pistachios & almonds.',
      price: 15000,
      imageUrl: 'https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?w=800&q=80', // Tea placeholder
    ),
    LiveStationAddOn(
      id: 'tawa_chicken',
      name: 'Live Tawa Chicken',
      description: 'Spicy chicken cooked on a large tawa with fresh green chilies.',
      price: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1606756790138-7c13da2e9149?w=800&q=80', // Chicken/Spicy food
    ),
    LiveStationAddOn(
      id: 'papri_chaat',
      name: 'Papri Chaat Station',
      description: 'Traditional Lahori Chaat with yogurt, chutney, and spices.',
      price: 20000,
      imageUrl: 'https://images.unsplash.com/photo-1606471191009-63994c53433b?w=800&q=80', // Chaat placeholder matching gol gappa style
    ),
    LiveStationAddOn(
      id: 'dahi_baray',
      name: 'Dahi Baray Station',
      description: 'Soft lentil dumplings soaked in yogurt and topped with chutneys.',
      price: 18000,
      imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f5816029bd?w=800&q=80', // General food placeholder
    ),
    LiveStationAddOn(
      id: 'bun_kabab',
      name: 'Live Bun Kabab',
      description: 'Karachi street style Bun Kababs made fresh.',
      price: 22000,
      imageUrl: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=800&q=80', // Burger/sandwich placeholder
    ),
    LiveStationAddOn(
      id: 'halwa_puri',
      name: 'Halwa Puri Stand',
      description: 'Fresh Puris with Halwa and Chana.',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1616035900593-78ccdf3a67d0?w=800&q=80', // Fried dough/food
    ),
    
    // Corporate Specific Add-Ons
    LiveStationAddOn(
      id: 'coffee_bar',
      name: 'Premium Coffee Bar',
      description: 'Espresso, Latte, Cappuccino made by professional baristas.',
      price: 50000,
      imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80', // Coffee
    ),
    LiveStationAddOn(
      id: 'pasta_station',
      name: 'Live Pasta Station',
      description: 'Gourmet pasta made to order with White & Red sauces.',
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800&q=80', // Pasta
    ),
    LiveStationAddOn(
      id: 'mocktail_bar',
      name: 'Mocktail Bar',
      description: 'Refreshing non-alcoholic drinks: Blue Lagoon, Mojito, etc.',
      price: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=800&q=80', // Mocktails
    ),
    LiveStationAddOn(
      id: 'chocolate_fountain',
      name: 'Chocolate Fountain',
      description: 'Flowing chocolate with fresh fruit & marshmallow skewers.',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1544158674-c8121f109015?w=800&q=80', // Chocolate
    ),
    
    // Kids Specific Add-Ons
    LiveStationAddOn(
      id: 'magic_cotton_candy',
      name: 'Magic Cotton Candy',
      description: 'Artistic shapes like flowers and characters.',
      price: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1532635293-a7e0a97c9b13?w=800&q=80', // Cotton candy
    ),
    LiveStationAddOn(
      id: 'popcorn_cart',
      name: 'Vintage Popcorn Cart',
      description: 'Fresh warm popcorn in a vintage style cart.',
      price: 20000,
      imageUrl: 'https://images.unsplash.com/photo-1578849278619-e73505e9610f?w=800&q=80', // Popcorn
    ),
    LiveStationAddOn(
      id: 'slush_machine',
      name: 'Double Barrel Slush',
      description: 'Two flavors of icy cold slush (Blueberry/Strawberry).',
      price: 22000,
      imageUrl: 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=800&q=80', // Slush/Drink placeholder
    ),
  ];
}
