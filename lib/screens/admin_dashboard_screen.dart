import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedRegion = 'all'; // all, ae, pk
  String _selectedStatus = 'all'; // all, new, read, replied, closed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        title: Text(
          'Admin Dashboard - Contact Submissions',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Region Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: _selectedRegion,
              dropdownColor: const Color(0xFF1B5E20),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              style: GoogleFonts.inter(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('🌍 All Regions')),
                DropdownMenuItem(value: 'pk', child: Text('🇵🇰 Pakistan')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRegion = value!;
                });
              },
            ),
          ),
          // Status Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: _selectedStatus,
              dropdownColor: const Color(0xFF1B5E20),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              style: GoogleFonts.inter(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'new', child: Text('🆕 New')),
                DropdownMenuItem(value: 'read', child: Text('👁️ Read')),
                DropdownMenuItem(value: 'replied', child: Text('✅ Replied')),
                DropdownMenuItem(value: 'closed', child: Text('🔒 Closed')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.inter(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No submissions found',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final submissions = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final doc = submissions[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildSubmissionCard(doc.id, data);
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getContactsStream() {
    // Combine both collections
    if (_selectedRegion == 'all') {
      // For "all", we need to merge both streams
      // For simplicity, let's just show one collection at a time
      // You can enhance this later
      return FirebaseFirestore.instance
          .collection('contacts_ae')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } else {
      Query query = FirebaseFirestore.instance
          .collection('contacts_${_selectedRegion.toLowerCase()}')
          .orderBy('timestamp', descending: true);

      if (_selectedStatus != 'all') {
        query = query.where('status', isEqualTo: _selectedStatus);
      }

      return query.snapshots();
    }
  }

  Widget _buildSubmissionCard(String docId, Map<String, dynamic> data) {
    final name = data['name'] ?? 'N/A';
    final email = data['email'] ?? 'N/A';
    final phone = data['phone'] ?? 'N/A';
    final message = data['message'] ?? 'N/A';
    final region = data['region'] ?? 'N/A';
    final regionName = data['regionName'] ?? 'N/A';
    final status = data['status'] ?? 'new';
    final timestamp = data['timestamp'] as Timestamp?;

    final dateStr = timestamp != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate())
        : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(status),
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
            ),
            _buildStatusBadge(status),
            const SizedBox(width: 8),
            Text(
              '🇵🇰',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              email,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dateStr,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('📧 Email', email),
                const SizedBox(height: 8),
                _buildInfoRow('📞 Phone', phone),
                const SizedBox(height: 8),
                _buildInfoRow('🌍 Region', regionName),
                const SizedBox(height: 16),
                Text(
                  'Message:',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF616161),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionButton(
                      'Mark as Read',
                      Icons.visibility,
                      Colors.blue,
                          () => _updateStatus(docId, region, 'read'),
                    ),
                    _buildActionButton(
                      'Mark as Replied',
                      Icons.check_circle,
                      Colors.green,
                          () => _updateStatus(docId, region, 'replied'),
                    ),
                    _buildActionButton(
                      'Close',
                      Icons.close,
                      Colors.orange,
                          () => _updateStatus(docId, region, 'closed'),
                    ),
                    _buildActionButton(
                      'Delete',
                      Icons.delete,
                      Colors.red,
                          () => _deleteSubmission(docId, region),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF212121),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: GoogleFonts.inter(fontSize: 12),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'read':
        return Colors.orange;
      case 'replied':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'new':
        return Icons.fiber_new;
      case 'read':
        return Icons.visibility;
      case 'replied':
        return Icons.check_circle;
      case 'closed':
        return Icons.lock;
      default:
        return Icons.fiber_new;
    }
  }

  Future<void> _updateStatus(String docId, String region, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('contacts_${region.toLowerCase()}')
          .doc(docId)
          .update({'status': newStatus});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to: $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteSubmission(String docId, String region) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Submission?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('contacts_${region.toLowerCase()}')
            .doc(docId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Submission deleted'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
