import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote_request.dart';
import '../../config/constants/api_constants.dart';
import '../../admin/services/activity_log_service.dart';
import '../../admin/models/activity_log_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for handling quote/inquiry submissions
class QuoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ActivityLogService _activityLog = ActivityLogService();

  /// Submit a new quote request
  Future<bool> submitQuote(QuoteRequest quote) async {
    try {
      await _firestore
          .collection(ApiConstants.quotesCollection)
          .add(quote.toJson());
      
      // Log as system action since it's guest initiated
      await _activityLog.log(ActivityLog.create(
        action: ActivityAction.quoteCreated,
        performedBy: 'guest',
        performedByName: 'Guest Customer',
        entityType: 'quote',
        entityId: quote.id,
        entityName: '${quote.name} - ${quote.serviceType}',
        note: 'New quote submitted from website',
      ));

      return true;
    } catch (e) {
      print('Error submitting quote: $e');
      return false;
    }
  }

  /// Get all quotes for admin dashboard
  Future<List<QuoteRequest>> getAllQuotes() async {
    try {
      final snapshot = await _firestore
          .collection(ApiConstants.quotesCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return QuoteRequest.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching quotes: $e');
      return [];
    }
  }

  /// Get quotes by region
  Future<List<QuoteRequest>> getQuotesByRegion(String region) async {
    try {
      final snapshot = await _firestore
          .collection(ApiConstants.quotesCollection)
          .where('region', isEqualTo: region)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return QuoteRequest.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching quotes by region: $e');
      return [];
    }
  }

  /// Get quotes by status
  Future<List<QuoteRequest>> getQuotesByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection(ApiConstants.quotesCollection)
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return QuoteRequest.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Error fetching quotes by status: $e');
      return [];
    }
  }

  /// Update quote status
  Future<bool> updateQuoteStatus(String quoteId, String newStatus) async {
    try {
      final doc = await _firestore
          .collection(ApiConstants.quotesCollection)
          .doc(quoteId)
          .get();
      
      final before = doc.data();

      await _firestore
          .collection(ApiConstants.quotesCollection)
          .doc(quoteId)
          .update({'status': newStatus});

      final user = FirebaseAuth.instance.currentUser;
      await _activityLog.log(ActivityLog.create(
        action: ActivityAction.statusChanged,
        performedBy: user?.uid ?? 'system',
        performedByName: user?.email ?? 'System',
        entityType: 'quote',
        entityId: quoteId,
        entityName: before?['customerName'] ?? quoteId,
        changesBefore: {'status': before?['status']},
        changesAfter: {'status': newStatus},
      ));

      return true;
    } catch (e) {
      print('Error updating quote status: $e');
      return false;
    }
  }

  /// Stream quotes (for real-time updates)
  Stream<List<QuoteRequest>> streamQuotes() {
    return _firestore
        .collection(ApiConstants.quotesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return QuoteRequest.fromFirestore(doc);
      }).toList();
    });
  }
}
