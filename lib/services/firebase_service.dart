import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static late FirebaseFirestore firestore;
  static late FirebaseAuth auth;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      firestore = FirebaseFirestore.instance;
      auth = FirebaseAuth.instance;

      // Configure Firestore settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }
}