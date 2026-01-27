import 'package:url_launcher/url_launcher.dart';
import '../models/region.dart';

/// Utility class for launching URLs (WhatsApp, Email, Phone)
class UrlLauncherHelper {
  /// Open WhatsApp with pre-filled message
  static Future<bool> openWhatsApp(Region region, {String? customMessage}) async {
    final url = Uri.parse(region.getWhatsAppLink(message: customMessage));
    
    if (await canLaunchUrl(url)) {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Open email client
  static Future<bool> openEmail({
    required String emailAddress,
    String? subject,
    String? body,
  }) async {
    String emailUrl = 'mailto:$emailAddress';
    
    if (subject != null || body != null) {
      emailUrl += '?';
      if (subject != null) {
        emailUrl += 'subject=${Uri.encodeComponent(subject)}';
      }
      if (body != null) {
        if (subject != null) emailUrl += '&';
        emailUrl += 'body=${Uri.encodeComponent(body)}';
      }
    }
    
    final url = Uri.parse(emailUrl);
    
    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    }
    return false;
  }

  /// Make phone call
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    
    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    }
    return false;
  }

  /// Open any URL (generic helper)
  static Future<bool> openUrl(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Open external website
  static Future<bool> openWebsite(String websiteUrl) async {
    final url = Uri.parse(websiteUrl);
    
    if (await canLaunchUrl(url)) {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Open Google Maps with location
  static Future<bool> openGoogleMaps(double latitude, double longitude) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    
    if (await canLaunchUrl(url)) {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// Share via native share sheet (if available)
  static Future<bool> shareText(String text) async {
    final url = Uri.parse('mailto:?body=${Uri.encodeComponent(text)}');
    
    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    }
    return false;
  }
}
