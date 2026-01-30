import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
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
  ActivityAction? _filterAction;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Log',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track all administrative changes and actions',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _exportLogs,
                  icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFFD4AF37)),
                  label: const Text('Export CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1F2937),
                    elevation: 0,
                    side: BorderSide(color: Colors.grey.shade200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
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
                isDense: true,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Action Filters
          Container(
            color: Colors.white,
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filterAction == null,
                  onSelected: (val) => setState(() => _filterAction = null),
                  selectedColor: const Color(0xFFD4AF37),
                  labelStyle: TextStyle(
                    color: _filterAction == null ? Colors.black : Colors.grey[700],
                    fontWeight: _filterAction == null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                ...[
                  ActivityAction.categoryCreated,
                  ActivityAction.subCategoryCreated,
                  ActivityAction.packageCreated,
                  ActivityAction.orderCreated,
                  ActivityAction.quoteAccepted,
                  ActivityAction.statusChanged,
                ].map((action) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(action.label),
                    selected: _filterAction == action,
                    onSelected: (val) => setState(() => _filterAction = val ? action : null),
                    selectedColor: const Color(0xFFD4AF37),
                    labelStyle: TextStyle(
                      color: _filterAction == action ? Colors.black : Colors.grey[700],
                      fontWeight: _filterAction == action ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                )),
              ],
            ),
          ),
          const Divider(height: 1),
          
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

                // Filter by action
                if (_filterAction != null) {
                  activities = activities.where((a) => a.action == _filterAction).toList();
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
        final bStr = _truncateBase64(beforeValue.toString());
        final aStr = _truncateBase64(afterValue.toString());
        
        chips.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              '$key: $bStr → $aStr',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
    });
    
    return chips;
  }

  String _truncateBase64(String value) {
    if (value.startsWith('data:image') || value.length > 100) {
      if (value.contains('base64,')) {
        return '[Image Data]';
      }
      return '${value.substring(0, 30)}...';
    }
    return value;
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
      case ActivityAction.categoryCreated:
      case ActivityAction.subCategoryCreated:
      case ActivityAction.packageCreated:
        return const Color(0xFF059669); // Green
      case ActivityAction.paymentReceived:
      case ActivityAction.fileUploaded:
        return const Color(0xFF3B82F6); // Blue
      case ActivityAction.statusChanged:
      case ActivityAction.categoryUpdated:
      case ActivityAction.subCategoryUpdated:
      case ActivityAction.packageUpdated:
        return const Color(0xFFF59E0B); // Amber
      case ActivityAction.orderCancelled:
      case ActivityAction.quoteRejected:
      case ActivityAction.categoryDeleted:
      case ActivityAction.subCategoryDeleted:
      case ActivityAction.packageDeleted:
        return const Color(0xFFDC2626); // Red
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
      
      if (mounted) {
        // Create blob and download link
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'activity_log_${DateTime.now().toIso8601String()}.csv';
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

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
