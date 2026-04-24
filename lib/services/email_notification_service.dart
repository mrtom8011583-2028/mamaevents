import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Service for sending email notifications via EmailJS
/// Uses info@mamaevents.pk Gmail service (service_hdctx38)
class EmailNotificationService {
  // ─────────────────────────────────────────────────────────────
  // EmailJS Configuration  ← UPDATE template_id after you create
  //                          the template on emailjs.com
  // ─────────────────────────────────────────────────────────────
  static const String _serviceId  = 'service_hdctx38';    // info@mamaevents.pk service
  static const String _quoteTemplateId = 'template_t1bbuug';  // Quote notification template
  static const String _verifyTemplateId = 'template_mzjxaux';     // existing verify template
  static const String _publicKey  = 'gIOKi2IQ4SuGcy5Se';  // your public key

  static const String _emailJsApiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  // Admin email – receives every quote
  static const String _adminEmail = 'info@mamaevents.pk';

  // ─────────────────────────────────────────────────────────────
  // 1. QUOTE NOTIFICATION  ← new method
  // ─────────────────────────────────────────────────────────────
  /// Called when a quote form is submitted.
  /// Sends full quote details to info@mamaevents.pk
  static Future<void> sendQuoteNotification({
    required String quoteId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String serviceType,
    String? packageName,
    required int guestCount,
    required String eventDate,
    required String eventTime,
    required String location,
    required String frequency,
    String? budgetRange,
    String serviceStyles = '',
    String notes = '',
    double estimatedTotal = 0,
  }) async {
    try {
      await _sendViaEmailJS(
        templateId: _quoteTemplateId,
        templateParams: {
          'to_name':        'Admin',
          'to_email':       _adminEmail,
          'quote_id':       quoteId,
          'from_name':      customerName,
          'from_email':     customerEmail,
          'phone':          customerPhone,
          'service_type':   serviceType,
          'package_name':   packageName ?? 'Custom',
          'guest_count':    guestCount.toString(),
          'event_date':     eventDate,
          'event_time':     eventTime,
          'location':       location,
          'frequency':      frequency,
          'budget':         budgetRange ?? 'Not specified',
          'service_styles': serviceStyles,
          'notes':          notes.isEmpty ? 'None' : notes,
          'estimated_total': estimatedTotal > 0
              ? estimatedTotal.toStringAsFixed(0)
              : 'TBD',
          'type': 'New Quote Request',
        },
      );
      if (kDebugMode) print('✅ Quote email sent to $_adminEmail');
    } catch (e) {
      // Non-fatal – never block quote submission
      if (kDebugMode) print('❌ Error sending quote notification email: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 2. CONTACT FORM NOTIFICATION
  // ─────────────────────────────────────────────────────────────
  static Future<void> sendContactFormNotification({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String region,
  }) async {
    try {
      await _sendViaEmailJS(
        templateId: _quoteTemplateId,
        templateParams: {
          'to_name':    'Admin',
          'to_email':   _adminEmail,
          'from_name':  name,
          'from_email': email,
          'phone':      phone,
          'message':    message,
          'region':     region,
          'type':       'Contact Form',
          'reply_to':   email,
        },
      );
    } catch (e) {
      if (kDebugMode) print('❌ Error sending contact notification: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 3. VERIFICATION CODE EMAIL
  // ─────────────────────────────────────────────────────────────
  static Future<void> sendVerificationEmail({
    required String name,
    required String email,
    required String code,
    required String quoteId,
  }) async {
    try {
      await _sendViaEmailJS(
        templateId: _verifyTemplateId,
        templateParams: {
          'to_name':  name,
          'to_email': email,
          'code':     code,
          'quote_id': quoteId,
          'message':  'Your verification code is: $code',
          'type':     'Verification',
        },
      );
      if (kDebugMode) print('✅ Verification email sent to $email');
    } catch (e) {
      if (kDebugMode) print('❌ Error sending verification email: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // CORE SENDER
  // ─────────────────────────────────────────────────────────────
  static Future<void> _sendViaEmailJS({
    required String templateId,
    required Map<String, dynamic> templateParams,
  }) async {
    final response = await http.post(
      Uri.parse(_emailJsApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'origin': 'https://mamaevents.pk',
      },
      body: jsonEncode({
        'service_id':      _serviceId,
        'template_id':     templateId,
        'user_id':         _publicKey,
        'template_params': templateParams,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('EmailJS Error ${response.statusCode}: ${response.body}');
    }
  }
}
