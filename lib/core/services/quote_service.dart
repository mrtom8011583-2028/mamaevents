import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote_request.dart';
import '../../config/constants/api_constants.dart';

/// Service for handling quote/inquiry submissions
class QuoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Submit a new quote request
  Future<bool> submitQuote(QuoteRequest quote) async {
    try {
      await _firestore
          .collection(ApiConstants.quotesCollection)
          .add(quote.toJson());
      
      // TODO: Trigger email notification via Cloud Function
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
      await _firestore
          .collection(ApiConstants.quotesCollection)
          .doc(quoteId)
          .update({'status': newStatus});
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
