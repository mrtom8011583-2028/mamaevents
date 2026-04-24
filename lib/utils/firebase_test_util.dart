import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase Connection Test Utility
/// Use this to verify Firebase is working correctly
class FirebaseTestUtil {
  static Future<Map<String, dynamic>> testConnection() async {
    final results = <String, dynamic>{
      'initialized': false,
      'firestoreConnected': false,
      'canWrite': false,
      'canRead': false,
      'errors': <String>[],
    };

    try {
      // Check if Firebase is initialized
      Firebase.app();
      results['initialized'] = true;
      debugPrint('✅ Firebase is initialized');
    } catch (e) {
      results['errors'].add('Firebase not initialized: $e');
      debugPrint('❌ Firebase not initialized: $e');
      return results;
    }

    try {
      // Test Firestore connection by writing a test document
      final testDoc = FirebaseFirestore.instance
          .collection('_connection_test')
          .doc('test_${DateTime.now().millisecondsSinceEpoch}');

      await testDoc.set({
        'timestamp': FieldValue.serverTimestamp(),
        'test': true,
        'message': 'Connection test successful',
      });

      results['canWrite'] = true;
      debugPrint('✅ Firestore write successful');

      // Test reading the document
      final snapshot = await testDoc.get();
      if (snapshot.exists) {
        results['canRead'] = true;
        results['firestoreConnected'] = true;
        debugPrint('✅ Firestore read successful');
        debugPrint('✅ Firebase connection is fully operational!');
      }

      // Clean up test document
      await testDoc.delete();
      debugPrint('✅ Test document cleaned up');
    } catch (e) {
      results['errors'].add('Firestore operation failed: $e');
      debugPrint('❌ Firestore operation failed: $e');
    }

    return results;
  }

  /// Test quote submission
  static Future<bool> testQuoteSubmission() async {
    try {
      final testQuote = {
        'quoteId': 'TEST-${DateTime.now().millisecondsSinceEpoch}',
        'name': 'Test Customer',
        'phone': '+92 300 0000000',
        'email': 'info@mamaevents.pk',
        'guestCount': 100,
        'eventDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
        'region': 'PK',
        'regionName': 'Pakistan',
        'status': 'test',
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'connection_test',
      };

      final docRef = await FirebaseFirestore.instance
          .collection('quote_requests')
          .add(testQuote);

      debugPrint('✅ Test quote created with ID: ${docRef.id}');

      // Clean up
      await docRef.delete();
      debugPrint('✅ Test quote cleaned up');

      return true;
    } catch (e) {
      debugPrint('❌ Quote submission test failed: $e');
      return false;
    }
  }

  /// Print Firebase configuration info
  static void printFirebaseInfo() {
    try {
      final app = Firebase.app();
      debugPrint('🔥 Firebase App Name: ${app.name}');
      debugPrint('🔥 Firebase Options:');
      debugPrint('   - Project ID: ${app.options.projectId}');
      debugPrint('   - App ID: ${app.options.appId}');
      debugPrint('   - API Key: ${app.options.apiKey.substring(0, 10)}...');
      debugPrint('   - Storage Bucket: ${app.options.storageBucket}');
    } catch (e) {
      debugPrint('❌ Could not print Firebase info: $e');
    }
  }
}
