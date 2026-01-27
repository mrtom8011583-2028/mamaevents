import 'package:flutter/foundation.dart';
import '../../data/event_packages_data.dart';
import 'event_service.dart';

class SeedDataService {
  final EventService _eventService = EventService();

  Future<void> seedEventPackages() async {
    try {
      debugPrint('🌱 Starting Database Seeding...');
      
      final events = [
        EventPackagesData.weddingCategory,
        EventPackagesData.corporateCategory,
        // Birthday category is not fully defined in the static file (only individual packages shown in snippet),
        // but let's see if we can construct one or if the file ended early.
        // I'll stick to the ones that are complete objects in the static class.
      ];

      await _eventService.seedInitialData(events);
      
      debugPrint('✅ Database Seeding Complete!');
    } catch (e) {
      debugPrint('❌ Database Seeding Failed: $e');
      rethrow;
    }
  }
}
