import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import '../admin/widgets/notification_bell.dart';
import '../core/services/database_service.dart';

class QuoteManagementDashboard extends StatefulWidget {
  const QuoteManagementDashboard({super.key});

  @override
  State<QuoteManagementDashboard> createState() => _QuoteManagementDashboardState();
}

class _QuoteManagementDashboardState extends State<QuoteManagementDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRegion = 'all';
  String _selectedStatus = 'all';
  DateTimeRange? _dateRange;
  
  // New features
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Set<String> _selectedQuotes = {};
  bool _isSelectMode = false;
  
  /// Safely converts dynamic data from DB to DateTime
  DateTime? _getDateTime(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    
    // Fallback for Firestore Timestamp if it somehow arrives without import
    try {
      if (value.runtimeType.toString().contains('Timestamp')) {
        return (value as dynamic).toDate();
      }
    } catch (_) {}
    
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         // Tab Bar Header
         Container(
           color: Colors.black,
           width: double.infinity,
           child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'QUOTE REQUESTS'),
                Tab(text: 'CONTACT FORMS'),
              ],
            ),
         ),
        
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildQuotesTab(),
              _buildContactsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuotesTab() {
    return Column(
      children: [
        // Filters & Stats
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Statistics Row
              _buildStatsRow(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              // Filters
              _buildFilters(),
            ],
          ),
        ),
        // Quote List
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: DatabaseService().getQuotesStream(),
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
                        'Error loading quotes',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: GoogleFonts.inter(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final allQuotes = snapshot.data ?? [];

              if (allQuotes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No quote requests found',
                        style: GoogleFonts.inter(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quotes will appear here once customers submit them',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              // CLIENT-SIDE FILTERING
              var quotes = allQuotes.where((data) {
                // Filter by region
                if (_selectedRegion != 'all') {
                  final region = data['region']?.toString().toLowerCase() ?? '';
                  if (region != _selectedRegion.toLowerCase()) return false;
                }
                
                // Filter by status
                if (_selectedStatus != 'all') {
                  final status = data['status']?.toString().toLowerCase() ?? '';
                  if (status != _selectedStatus.toLowerCase()) return false;
                }
                
                // Filter by date range
                if (_dateRange != null) {
                  // Handle both Timestamp (if passing legacy data) and int (RTDB)
                  DateTime? date = _getDateTime(data['createdAt']);
                  
                  if (date != null) {
                    if (date.isBefore(_dateRange!.start) || 
                        date.isAfter(_dateRange!.end.add(const Duration(days: 1)))) {
                      return false;
                    }
                  }
                }
                
                // Filter by search query
                if (_searchQuery.isNotEmpty) {
                  final searchLower = _searchQuery.toLowerCase();
                  final userDetails = data['user_details'] != null 
                      ? Map<String, dynamic>.from(data['user_details'] as Map) 
                      : null;
                  final name = (userDetails?['name'] ?? data['name'] ?? '').toString().toLowerCase();
                  final email = (userDetails?['email'] ?? data['email'] ?? '').toString().toLowerCase();
                  final phone = (userDetails?['phone'] ?? data['phone'] ?? '').toString().toLowerCase();
                  final quoteId = data['quoteId']?.toString().toLowerCase() ?? '';
                  
                  if (!name.contains(searchLower) &&
                      !email.contains(searchLower) &&
                      !phone.contains(searchLower) &&
                      !quoteId.contains(searchLower)) {
                    return false;
                  }
                }
                
                return true;
              }).toList();
              
              // If no quotes after filtering, show empty state
              if (quotes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.filter_alt_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No quotes match your filters',
                        style: GoogleFonts.inter(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedRegion = 'all';
                            _selectedStatus = 'all';
                            _dateRange = null;
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        child: const Text('Clear all filters'),
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                children: [
                  // Export Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${quotes.length} ${quotes.length == 1 ? 'quote' : 'quotes'} found',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF616161),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _exportToCSV(quotes),
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('EXPORT CSV'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF212121),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Quote Cards
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        final data = quotes[index];
                        return _buildQuoteCard(data['quoteId'] ?? 'unknown', data);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().getQuotesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 80);
        }

        final allQuotes = snapshot.data!;
        final pendingCount = allQuotes.where((d) => d['status'] == 'pending').length;
        final quotedCount = allQuotes.where((d) => d['status'] == 'quoted').length;
        final closedCount = allQuotes.where((d) => d['status'] == 'closed').length;

        return Row(
          children: [
            _buildStatCard('Total Quotes', allQuotes.length.toString(), Icons.receipt_long, const Color(0xFF212121)),
            const SizedBox(width: 16),
            _buildStatCard('Pending', pendingCount.toString(), Icons.pending, Colors.orange),
            const SizedBox(width: 16),
            _buildStatCard('Quoted', quotedCount.toString(), Icons.check_circle, Colors.blue),
            const SizedBox(width: 16),
            _buildStatCard('Closed', closedCount.toString(), Icons.lock, Colors.grey),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF616161),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Region Filter
        DropdownButton<String>(
          value: _selectedRegion,
          icon: const Icon(Icons.arrow_drop_down),
          underline: Container(height: 1, color: Colors.grey.shade300),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('🌍 All Regions')),
            DropdownMenuItem(value: 'PK', child: Text('🇵🇰 Pakistan')),
          ],
          onChanged: (value) => setState(() => _selectedRegion = value!),
        ),
        
        // Status Filter
        DropdownButton<String>(
          value: _selectedStatus,
          icon: const Icon(Icons.arrow_drop_down),
          underline: Container(height: 1, color: Colors.grey.shade300),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Status')),
            DropdownMenuItem(value: 'pending', child: Text('⏳ Pending')),
            DropdownMenuItem(value: 'quoted', child: Text('💰 Quoted')),
            DropdownMenuItem(value: 'closed', child: Text('🔒 Closed')),
          ],
          onChanged: (value) => setState(() => _selectedStatus = value!),
        ),

        // Date Range Picker
        OutlinedButton.icon(
          onPressed: _pickDateRange,
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text(
            _dateRange == null
                ? 'Date Range'
                : '${DateFormat('MMM dd').format(_dateRange!.start)} - ${DateFormat('MMM dd').format(_dateRange!.end)}',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF212121),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),

        // Clear Filters
        if (_selectedRegion != 'all' || _selectedStatus != 'all' || _dateRange != null)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedRegion = 'all';
                _selectedStatus = 'all';
                _dateRange = null;
              });
            },
            icon: const Icon(Icons.clear, size: 18),
            label: const Text('Clear Filters'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
      ],
    );
  }



  Widget _buildQuoteCard(String docId, Map<String, dynamic> data) {
    final quoteId = data['quoteId'] ?? 'N/A';
    final region = data['region'] ?? 'N/A';
    final status = data['status'] ?? 'pending';
    final notes = data['notes'] ?? data['additional_details'] ?? '';
    final menuItem = data['menuItem'] != null 
        ? Map<String, dynamic>.from(data['menuItem'] as Map)
        : null;
    final userDetails = data['user_details'] != null
        ? Map<String, dynamic>.from(data['user_details'] as Map)
        : null;
    
    final name = userDetails?['name'] ?? data['name'] ?? 'N/A';
    final email = userDetails?['email'] ?? data['email'] ?? 'N/A';
    final phone = userDetails?['phone'] ?? data['phone'] ?? 'N/A';
    final guestCount = (data['guest_count'] ?? data['guestCount'])?.toString() ?? 'N/A';
    
    final serviceStyles = data['service_styles'] as List<dynamic>?;
    final source = data['source'] ?? 'standard';
    
    final displayLocation = userDetails?['location'] ?? data['eventLocation'] ?? data['location'] ?? 'N/A';
    final displayStyles = serviceStyles?.join(", ") ?? 'None';
    
    final rawCreatedAt = data['createdAt'];
    String dateStr = 'N/A';
    final createdAtDate = _getDateTime(rawCreatedAt);
    if (createdAtDate != null) {
      dateStr = DateFormat('MMM dd, yyyy - hh:mm a').format(createdAtDate);
    }

    final rawEventDate = data['eventDate'] ?? data['serviceDate']; // Handle both keys
    String eventDateStr = 'Not specified';
    final eventDate = _getDateTime(rawEventDate);
    if (eventDate != null) {
      eventDateStr = DateFormat('MMM dd, yyyy').format(eventDate);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '🇵🇰',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quoteId,
                    style: GoogleFonts.robotoMono(
                      fontSize: 12,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            _buildStatusBadge(status),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(Icons.people, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '$guestCount guests',
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF616161)),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                eventDateStr,
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF616161)),
              ),
            ],
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('📧 Email', email),
                const Divider(height: 24),
                _buildDetailRow('📞 Phone', phone),
                const Divider(height: 24),
                _buildDetailRow('📍 Location', displayLocation),
                const Divider(height: 24),
                _buildDetailRow('👥 Guest Count', guestCount),
                const Divider(height: 24),
                _buildDetailRow('✨ Service Styles', displayStyles),
                const Divider(height: 24),
                _buildDetailRow('📅 Event Date', eventDateStr),
                const Divider(height: 24),
                _buildDetailRow('🕒 Submitted', dateStr),
                const Divider(height: 24),
                _buildDetailRow('📱 Source', source.toString().toUpperCase()),
                
                if (menuItem != null) ...[
                  const Divider(height: 24),
                  _buildDetailRow('🍽️ Menu Item', menuItem['name'] ?? 'N/A'),
                  if (menuItem['price'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 24),
                      child: Text(
                        'Price: ${menuItem['price']}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
                
                if (notes.isNotEmpty) ...[
                  const Divider(height: 24),
                  Text(
                    'Additional Notes:',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notes,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF616161),
                      height: 1.5,
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Action Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildActionButton(
                      'Mark as Quoted',
                      Icons.price_check,
                      Colors.blue,
                      () => DatabaseService().updateQuoteStatus(docId, 'quoted'),
                      enabled: status != 'quoted',
                    ),
                    _buildActionButton(
                      'Mark as Closed',
                      Icons.check_circle,
                      Colors.green,
                      () => DatabaseService().updateQuoteStatus(docId, 'closed'),
                      enabled: status != 'closed',
                    ),
                    _buildActionButton(
                      'Reopen',
                      Icons.refresh,
                      Colors.orange,
                      () => DatabaseService().updateQuoteStatus(docId, 'pending'),
                      enabled: status != 'pending',
                    ),
                    _buildActionButton(
                      'Delete',
                      Icons.delete,
                      Colors.red,
                      () => DatabaseService().deleteQuote(docId),
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

  Widget _buildContactsTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().getContactMessagesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final messages = snapshot.data!;
        if (messages.isEmpty) return const Center(child: Text('No Contact Messages Found'));

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (ctx, i) {
            final msg = messages[i];
            final status = msg['status'] ?? 'unread';
            final isUnread = status == 'unread';
            
            final rawTime = msg['createdAt'];
            String timeStr = 'N/A';
            if (rawTime is int) {
               timeStr = DateFormat('MMM dd, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(rawTime));
            }

            return Card(
              color: isUnread ? Colors.blue.shade50 : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isUnread ? Colors.blue : Colors.grey,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(msg['name'] ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msg['email'] ?? ''),
                    Text(msg['phone'] ?? ''),
                    const SizedBox(height: 8),
                    Text(msg['message'] ?? '', style: const TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 8),
                    Text(timeStr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isUnread)
                      IconButton(
                        icon: const Icon(Icons.mark_email_read, color: Colors.blue),
                        tooltip: 'Mark Read',
                        onPressed: () => DatabaseService().updateContactMessageStatus(msg['id'], 'read'),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => DatabaseService().deleteContactMessage(msg['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? color : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'quoted':
        return Colors.blue;
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'quoted':
        return Icons.price_check;
      case 'closed':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  void _exportToCSV(List<Map<String, dynamic>> quotes) {
    // Create CSV content
    final csv = StringBuffer();
    
    // Headers
    csv.writeln('"Quote ID","Name","Email","Phone","Guest Count","Event Date","Region","Status","Created At","Menu Item","Notes"');
    
    // Data rows
    for (final data in quotes) {
                  final userDetails = data['user_details'] != null
                      ? Map<String, dynamic>.from(data['user_details'] as Map)
                      : null;
                  final name = (userDetails?['name'] ?? data['name'])?.toString() ?? '';
                  final email = (userDetails?['email'] ?? data['email'])?.toString() ?? '';
                  final phone = (userDetails?['phone'] ?? data['phone'])?.toString() ?? '';
                  final quoteId = data['quoteId']?.toString() ?? '';
      final guestCount = (data['guest_count'] ?? data['guestCount'])?.toString() ?? '';
      final region = data['region'] ?? '';
      final status = data['status'] ?? '';
      
      final rawEventDate = data['eventDate'] ?? data['serviceDate'];
      String eventDateStr = '';
      final eventDate = _getDateTime(rawEventDate);
      if (eventDate != null) {
          eventDateStr = DateFormat('yyyy-MM-dd').format(eventDate);
      }
      
      final rawCreatedAt = data['createdAt'];
      String createdAtStr = '';
      final createdAtDate = _getDateTime(rawCreatedAt);
      if (createdAtDate != null) {
          createdAtStr = DateFormat('yyyy-MM-dd HH:mm').format(createdAtDate);
      }
      
      final menuItem = data['menuItem'] as Map<String, dynamic>?;
      final menuItemName = menuItem != null ? menuItem['name'] ?? '' : '';
      
      final notes = (data['notes'] ?? '').toString().replaceAll('"', '""');
      
      csv.writeln('"$quoteId","$name","$email","$phone","$guestCount","$eventDateStr","$region","$status","$createdAtStr","$menuItemName","$notes"');
    }

    // Create and download file
    final bytes = utf8.encode(csv.toString());
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'quotes_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv')
      ..click();
    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV file downloaded successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
