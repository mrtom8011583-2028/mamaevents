import '../models/region.dart';

/// Utility class for formatting currency values
class CurrencyFormatter {
  /// Format price based on region
  static String formatPrice(double price, Region region) {
    return region.formatPrice(price);
  }

  /// Format price range
  static String formatPriceRange(double minPrice, double maxPrice, Region region) {
    final min = region.formatPrice(minPrice);
    final max = region.formatPrice(maxPrice);
    return '$min - $max';
  }

  /// Parse price string to double
  static double parsePrice(String priceString) {
    // Remove currency symbols and formatting
    final cleaned = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Format with thousand separators
  static String formatWithSeparators(double amount, Region region) {
    if (region == Region.pakistan) {
      // Pakistani numbering system (lakhs, crores)
      if (amount >= 10000000) {
        return '${(amount / 10000000).toStringAsFixed(2)} Cr';
      } else if (amount >= 100000) {
        return '${(amount / 100000).toStringAsFixed(2)} Lac';
      }
    }
    return region.formatPrice(amount);
  }
}
