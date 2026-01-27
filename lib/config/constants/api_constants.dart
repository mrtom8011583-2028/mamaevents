/// API endpoint constants
class ApiConstants {
  // Base URL - Update with your actual API URL
  static const String baseUrl = 'https://your-api-domain.com/api';
  
  // Firebase endpoints
  static const String menusCollection = 'menus';
  static const String servicesCollection = 'services';
  static const String quotesCollection = 'quotes';
  static const String testimonialsCollection = 'testimonials';
  static const String locationsCollection = 'locations';
  static const String galleryCollection = 'gallery';
  
  // API timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
