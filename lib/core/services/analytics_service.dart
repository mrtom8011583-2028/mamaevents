import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/region.dart';

/// Analytics service for tracking user behavior
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Track screen view
  Future<void> trackScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  /// Track region change
  Future<void> trackRegionChange(Region region) async {
    await _analytics.logEvent(
      name: 'region_changed',
      parameters: {
        'region_code': region.code,
        'region_name': region.name,
      },
    );
  }

  /// Track quote submission
  Future<void> trackQuoteSubmission({
    required String serviceType,
    required Region region,
    required int guests,
  }) async {
    await _analytics.logEvent(
      name: 'quote_submitted',
      parameters: {
        'service_type': serviceType,
        'region': region.code,
        'guests': guests,
      },
    );
  }

  /// Track menu item view
  Future<void> trackMenuItemView({
    required String itemId,
    required String itemName,
    required String category,
  }) async {
    await _analytics.logEvent(
      name: 'menu_item_viewed',
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
        'category': category,
      },
    );
  }

  /// Track WhatsApp click
  Future<void> trackWhatsAppClick(Region region) async {
    await _analytics.logEvent(
      name: 'whatsapp_clicked',
      parameters: {
        'region': region.code,
        'phone_number': region.whatsappNumber,
      },
    );
  }

  /// Track email click
  Future<void> trackEmailClick(String emailAddress) async {
    await _analytics.logEvent(
      name: 'email_clicked',
      parameters: {
        'email': emailAddress,
      },
    );
  }

  /// Track service view
  Future<void> trackServiceView(String serviceName) async {
    await _analytics.logEvent(
      name: 'service_viewed',
      parameters: {
        'service_name': serviceName,
      },
    );
  }

  /// Track gallery image view
  Future<void> trackGalleryImageView(String imageId) async {
    await _analytics.logEvent(
      name: 'gallery_image_viewed',
      parameters: {
        'image_id': imageId,
      },
    );
  }

  /// Track user engagement
  Future<void> trackEngagement(String engagementType) async {
    await _analytics.logEvent(
      name: 'user_engagement',
      parameters: {
        'engagement_type': engagementType,
      },
    );
  }

  /// Set user properties
  Future<void> setUserRegion(Region region) async {
    await _analytics.setUserProperty(
      name: 'user_region',
      value: region.code,
    );
  }
}
