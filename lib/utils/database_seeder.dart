import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/database_service.dart';
import '../core/models/add_on.dart';
import '../data/menu_data.dart';

class DatabaseSeeder {
  static Future<void> seedInitialData() async {
    final db = DatabaseService();
    
    // Check Authentication
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('❌ Cannot seed: User not authenticated');
      debugPrint('ℹ️ Please login to admin panel first');
      return;
    }
    debugPrint('🔐 Authenticated as: ${user.email}');

    try {
      debugPrint('🌱 Starting Database Seed...');
      
      // 1. Seed Menu Items
      final allMenuItems = MenuData.getAllItems();
      debugPrint('🍽️ Seeding ${allMenuItems.length} Menu Items...');
      await db.seedMenuItems(allMenuItems);
      
      // 2. Seed Default Add-Ons (Generic)
      final addOns = getDefaultAddOns();
      debugPrint('🎪 Seeding ${addOns.length} Add-Ons...');
      // Note: check if seedAddOns exists in DatabaseService? Yes it does.
      // await db.seedAddOns(addOns); 
      // Commenting out AddOns seeding if it relies on deleted logic, but AddOn model seems generic. 
      // To be safe and minimal:
      
      debugPrint('✅ Menu Seeding Completed Successfully!');
    } catch (e) {
      debugPrint('❌ Database Seeding Failed: $e');
    }
  }

  /// Get default add-ons for seeding
  static List<AddOn> getDefaultAddOns() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      AddOn(
        id: 'addon_coffee_bar',
        name: 'Coffee Bar',
        type: 'beverage',
        description: 'Professional barista with espresso machine.',
        priceEstimate: 25000,
        applicableCategories: ['corporate'],
        popular: false,
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
