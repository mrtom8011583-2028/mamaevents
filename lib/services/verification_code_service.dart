import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../admin/services/notification_service.dart';
import '../admin/models/notification_model.dart';
import 'email_notification_service.dart';

class VerificationCodeService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final NotificationService _notificationService = NotificationService();

  /// Generate a random 6-digit code
  String _generateCode() {
    final random = Random();
    final code = random.nextInt(900000) + 100000;
    return code.toString();
  }

  /// Create and distribute verification code
  /// Returns the generated code so it can be used in the WhatsApp message
  Future<String> createAndDistributeCode({
    required String quoteId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String serviceType,
  }) async {
    try {
      final code = _generateCode();
      final expiresAt = DateTime.now().add(const Duration(minutes: 30));

      // 1. Store in Realtime Database
      final ref = _db.ref('verification_codes').push();
      await ref.set({
        'quoteId': quoteId,
        'code': code,
        'createdAt': ServerValue.timestamp,
        'expiresAt': expiresAt.millisecondsSinceEpoch,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'isVerified': false,
      });

      // 2. Send to Admin Panel
      await _notificationService.createNotification(
        title: '🔐 Verification Code: $code',
        message: 'New code generated for $customerName. Quote ID: $quoteId',
        type: NotificationType.info,
        actionUrl: '/admin/quotes?id=$quoteId',
        metadata: {
          'code': code,
          'quoteId': quoteId,
          'type': 'verification_code'
        },
      );

      // 3. Send to Email
      await EmailNotificationService.sendVerificationEmail(
        name: customerName,
        email: customerEmail,
        code: code,
        quoteId: quoteId,
      );

      return code;
    } catch (e) {
      if (kDebugMode) {
        print('Error generating verification code: $e');
      }
      rethrow;
    }
  }

  /// Verify a code
  Future<bool> verifyCode(String quoteId, String code) async {
    try {
      final snapshot = await _db.ref('verification_codes')
          .orderByChild('quoteId')
          .equalTo(quoteId)
          .get();

      if (!snapshot.exists) return false;

      // Iterate through results to find matching code
      // (Since query is only on quoteId, we filter results manually or could double query)
      // RTDB complex queries are limited, so finding the session by quoteId is usually enough
      
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      
      String? matchedKey;
      Map<String, dynamic>? matchedData;

      data.forEach((key, value) {
        final entry = Map<String, dynamic>.from(value as Map);
        if (entry['code'].toString() == code && entry['isVerified'] == false) {
          matchedKey = key;
          matchedData = entry;
        }
      });

      if (matchedKey == null || matchedData == null) return false;

      final expiresAt = matchedData!['expiresAt'] as int;
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        return false;
      }

      // Mark as verified
      await _db.ref('verification_codes/$matchedKey').update({
        'isVerified': true,
        'verifiedAt': ServerValue.timestamp,
      });

      return true;
    } catch (e) {
      print('Error verifying code: $e');
      return false;
    }
  }
}
