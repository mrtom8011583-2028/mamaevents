import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service for sending email notifications
/// This uses a simple HTTP API approach
/// For production, you should use Firebase Cloud Functions or a dedicated email service
class EmailNotificationService {
  // Email configuration
  // TODO: Replace with your actual email service credentials
  static const String _emailApiUrl = 'YOUR_EMAIL_API_ENDPOINT';
  static const String _apiKey = 'YOUR_API_KEY';

  // Admin email addresses (where notifications will be sent)
  static const Map<String, String> _adminEmails = {
    'pk': 'admin.pakistan@freshcatering.com',  // Pakistan admin email
  };

  /// Send email notification when contact form is submitted
  static Future<void> sendContactFormNotification({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String region,
  }) async {
    try {
      final adminEmail = _adminEmails['pk'];

      // Email subject
      final subject = '🔔 New Contact Form Submission - ${region.toUpperCase()}';

      // Email body (HTML format)
      final htmlBody = '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #212121; color: white; padding: 20px; text-align: center; }
    .content { background-color: #f5f5f5; padding: 20px; margin-top: 20px; }
    .field { margin-bottom: 15px; }
    .label { font-weight: bold; color: #212121; }
    .value { margin-top: 5px; padding: 10px; background-color: white; border-left: 3px solid #212121; }
    .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>MAMA EVENTS</h1>
      <p>New Contact Form Submission</p>
    </div>
    
    <div class="content">
      <div class="field">
        <div class="label">📍 Region:</div>
        <div class="value">$region</div>
      </div>
      
      <div class="field">
        <div class="label">👤 Name:</div>
        <div class="value">$name</div>
      </div>
      
      <div class="field">
        <div class="label">📧 Email:</div>
        <div class="value">$email</div>
      </div>
      
      <div class="field">
        <div class="label">📞 Phone:</div>
        <div class="value">$phone</div>
      </div>
      
      <div class="field">
        <div class="label">💬 Message:</div>
        <div class="value">$message</div>
      </div>
    </div>
    
    <div class="footer">
      <p>This is an automated notification from MAMA EVENTS contact form.</p>
      <p>Please log in to the admin dashboard to manage this submission.</p>
    </div>
  </div>
</body>
</html>
''';

      // Plain text version
      final textBody = '''
New Contact Form Submission - MAMA EVENTS

Region: $region
Name: $name
Email: $email
Phone: $phone
Message: $message

---
This is an automated notification.
Please log in to the admin dashboard to manage this submission.
''';

      // Send email using your preferred method
      // Option 1: Using a simple HTTP API (e.g., SendGrid, Mailgun, etc.)
      await _sendViaHttpApi(
        to: adminEmail!,
        subject: subject,
        htmlBody: htmlBody,
        textBody: textBody,
      );

      print('✅ Email notification sent successfully to $adminEmail');
    } catch (e) {
      print('❌ Error sending email notification: $e');
      // Don't throw error - we don't want to fail the form submission if email fails
    }
  }

  /// Send email via HTTP API
  /// This is a template - replace with your actual email service
  static Future<void> _sendViaHttpApi({
    required String to,
    required String subject,
    required String htmlBody,
    required String textBody,
  }) async {
    // Example using a generic email API
    // Replace this with your actual email service (SendGrid, Mailgun, etc.)

    /* EXAMPLE FOR SENDGRID:
    final response = await http.post(
      Uri.parse('https://api.sendgrid.com/v3/mail/send'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'personalizations': [
          {
            'to': [{'email': to}],
            'subject': subject,
          }
        ],
        'from': {'email': 'noreply@mamaevents.com', 'name': 'MAMA EVENTS'},
        'content': [
          {'type': 'text/plain', 'value': textBody},
          {'type': 'text/html', 'value': htmlBody},
        ],
      }),
    );

    if (response.statusCode != 202) {
      throw Exception('Failed to send email: ${response.body}');
    }
    */

    // For now, just log (you'll implement actual sending later)
    print('📧 Email would be sent to: $to');
    print('Subject: $subject');
  }

  /// Alternative: Send email using Firebase Cloud Functions
  /// This is the recommended approach for production
  static Future<void> sendViaCloudFunction({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String region,
  }) async {
    try {
      // Call Firebase Cloud Function
      // You'll need to create a Cloud Function that sends emails

      /* EXAMPLE:
      final response = await http.post(
        Uri.parse('https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/sendContactEmail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'message': message,
          'region': region,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Cloud function failed: ${response.body}');
      }
      */

      print('📧 Cloud function would be called for: $email');
    } catch (e) {
      print('❌ Error calling cloud function: $e');
    }
  }
}
