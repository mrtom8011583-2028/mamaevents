import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/activity_log_model.dart';
import '../services/activity_log_service.dart';

/// Activity Log Screen - MAMA EVENTS
/// View all admin actions and system activity
class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final ActivityLogService _activityLogService = ActivityLogService();
  final _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: Text(
          'Activity Log',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportLogs,
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Activity List
          Expanded(
            child: StreamBuilder<List<ActivityLog>>(
              stream: _activityLogService.getRecentActivities(limit: 100),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildError(snapshot.error.toString());
                }
                
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                var activities = snapshot.data!;
                
                // Filter by search
                if (_searchController.text.isNotEmpty) {
                  final search = _searchController.text.toLowerCase();
                  activities = activities.where((a) =>
                    a.entityName.toLowerCase().contains(search) ||
                    a.description.toLowerCase().contains(search) ||
                    (a.note?.toLowerCase().contains(search) ?? false)
                  ).toList();
                }
                
                if (activities.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return _buildActivityCard(activities[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(ActivityLog activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getActionColor(activity.action).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  activity.action.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    activity.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Entity Name
                  Text(
                    activity.entityName,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Meta Info
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: const Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        activity.performedByName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time, size: 14, color: const Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(activity.timestamp),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  
                  // Note
                  if (activity.note != null && activity.note!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        activity.note!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                  
                  // Changes
                  if (activity.changesBefore != null && activity.changesAfter != null) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _buildChangeChips(activity.changesBefore!, activity.changesAfter!),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChangeChips(Map<String, dynamic> before, Map<String, dynamic> after) {
    final chips = <Widget>[];
    
    before.forEach((key, beforeValue) {
      final afterValue = after[key];
      if (beforeValue != afterValue) {
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$key: $beforeValue → $afterValue',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF059669),
              ),
            ),
          ),
        );
      }
    });
    
    return chips;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          Text(
            'No activities yet',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(ActivityAction action) {
    switch (action) {
      case ActivityAction.orderCreated:
      case ActivityAction.quoteAccepted:
        return const Color(0xFF059669);
      case ActivityAction.paymentReceived:
        return const Color(0xFF3B82F6);
      case ActivityAction.statusChanged:
        return const Color(0xFFF59E0B);
      case ActivityAction.orderCancelled:
      case ActivityAction.quoteRejected:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _exportLogs() async {
    try {
      final csv = await _activityLogService.exportToCSV();
      
      // TODO: Implement file download for web
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${csv.split('\n').length - 1} activities'),
            backgroundColor: const Color(0xFF059669),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
