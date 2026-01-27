import 'package:firebase_database/firebase_database.dart';
import '../models/activity_log_model.dart';

/// Activity Log Service - Enterprise Audit Trail
/// Automatic logging of all admin actions for compliance and tracking
class ActivityLogService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  
  // Reference
  DatabaseReference get _logsRef => _db.ref('activity_logs');

  /// Log an activity
  Future<void> log(ActivityLog activity) async {
    try {
      final newLogRef = _logsRef.push();
      final data = activity.toJson();
      data['logId'] = newLogRef.key;
      data['timestamp'] = ServerValue.timestamp;
      await newLogRef.set(data);
    } catch (e) {
      // Don't throw - logging should never break the main flow
      print('Failed to log activity: $e');
    }
  }

  /// Get activities (with filters)
  Stream<List<ActivityLog>> getActivities({
    String? entityType,
    String? entityId,
    String? performedBy,
    List<ActivityAction>? actions,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) {
    // Note: Complex filtering in RTDB is limited compared to Firestore.
    // We'll do basic filtering and sorting client-side for now.
    return _logsRef.orderByChild('timestamp').limitToLast(limit * 2).onValue.map((event) {
      if (event.snapshot.value == null) return [];
      
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<ActivityLog> logs = [];
      
      data.forEach((key, value) {
        final log = ActivityLog.fromJson(Map<String, dynamic>.from(value as Map), id: key);
        
        // Apply filters client-side
        bool matches = true;
        if (entityType != null && log.entityType != entityType) matches = false;
        if (entityId != null && log.entityId != entityId) matches = false;
        if (performedBy != null && log.performedBy != performedBy) matches = false;
        if (actions != null && !actions.contains(log.action)) matches = false;
        if (startDate != null && log.timestamp.isBefore(startDate)) matches = false;
        if (endDate != null && log.timestamp.isAfter(endDate)) matches = false;
        
        if (matches) logs.add(log);
      });
      
      // Sort desc
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return logs.take(limit).toList();
    });
  }

  /// Get recent activities (last 24 hours)
  Stream<List<ActivityLog>> getRecentActivities({int limit = 20}) {
    // For simplicity, just get latest logs
    return getActivities(limit: limit);
  }

  /// Get activities for a specific entity
  Stream<List<ActivityLog>> getEntityActivities({
    required String entityType,
    required String entityId,
    int limit = 50,
  }) {
    return getActivities(
      entityType: entityType,
      entityId: entityId,
      limit: limit,
    );
  }

  /// Get user's activities
  Stream<List<ActivityLog>> getUserActivities({
    required String userId,
    int limit = 50,
  }) {
    return getActivities(
      performedBy: userId,
      limit: limit,
    );
  }

  /// Search activities by note/description
  Future<List<ActivityLog>> searchActivities(String searchTerm) async {
    try {
      final snapshot = await _logsRef.limitToLast(100).get();
      if (!snapshot.exists) return [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final logs = data.entries.map((e) => 
        ActivityLog.fromJson(Map<String, dynamic>.from(e.value as Map), id: e.key)
      ).toList();

      final searchLower = searchTerm.toLowerCase();
      return logs.where((log) {
        return log.entityName.toLowerCase().contains(searchLower) ||
               log.description.toLowerCase().contains(searchLower) ||
               (log.note?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search activities: $e');
    }
  }

  /// Get activity statistics
  Future<Map<String, int>> getActivityStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final snapshot = await _logsRef.get();
      if (!snapshot.exists) return {};

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final logs = data.values.map((v) => 
        ActivityLog.fromJson(Map<String, dynamic>.from(v as Map))
      );

      final stats = <String, int>{};
      for (final log in logs) {
        if (startDate != null && log.timestamp.isBefore(startDate)) continue;
        if (endDate != null && log.timestamp.isAfter(endDate)) continue;
        
        final key = log.action.value;
        stats[key] = (stats[key] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to get activity stats: $e');
    }
  }

  /// Export activities to CSV
  Future<String> exportToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final snapshot = await _logsRef.get();
      if (!snapshot.exists) return 'No logs found';

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final logs = data.values.map((v) => 
        ActivityLog.fromJson(Map<String, dynamic>.from(v as Map))
      ).toList();

      logs.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Build CSV
      final csv = StringBuffer();
      csv.writeln('Timestamp,Action,Performed By,Entity Type,Entity Name,Note');

      for (final activity in logs) {
        if (startDate != null && activity.timestamp.isBefore(startDate)) continue;
        if (endDate != null && activity.timestamp.isAfter(endDate)) continue;

        csv.writeln([
          activity.timestamp.toIso8601String(),
          activity.action.label,
          activity.performedByName,
          activity.entityType,
          activity.entityName,
          activity.note?.replaceAll(',', ';') ?? '',
        ].join(','));
      }

      return csv.toString();
    } catch (e) {
      throw Exception('Failed to export activities: $e');
    }
  }

  /// Delete old logs (cleanup)
  Future<void> deleteOldLogs({required int daysToKeep}) async {
    try {
      final cutoff = DateTime.now().subtract(Duration(days: daysToKeep)).millisecondsSinceEpoch;
      final snapshot = await _logsRef.orderByChild('timestamp').endAt(cutoff).get();
      
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final Map<String, dynamic> updates = {};
        for (var key in data.keys) {
          updates[key] = null;
        }
        await _logsRef.update(updates);
      }
    } catch (e) {
      throw Exception('Failed to delete old logs: $e');
    }
  }
}
