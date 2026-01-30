import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order_model.dart';
import '../models/activity_log_model.dart';
import '../services/order_service.dart';
import '../services/activity_log_service.dart';
import '../widgets/create_order_dialog.dart';
import '../../core/models/event_package.dart';
import '../../core/services/database_service.dart';
import '../../core/services/seed_data_service.dart';
import 'package:firebase_database/firebase_database.dart';

/// Enhanced Admin Dashboard - MAMA EVENTS
/// Professional event management interface - Premium Gold/White Theme
class EnhancedAdminDashboard extends StatefulWidget {
  const EnhancedAdminDashboard({super.key});

  @override
  State<EnhancedAdminDashboard> createState() => _EnhancedAdminDashboardState();
}

class _EnhancedAdminDashboardState extends State<EnhancedAdminDashboard> {
  final OrderService _orderService = OrderService();
  final ActivityLogService _activityLogService = ActivityLogService();
  
  String _selectedRegion = 'All';
  
  // Premium Colors
  final Color _gold = const Color(0xFFC6A869);
  final Color _black = const Color(0xFF1F2937);
  final Color _darkGrey = const Color(0xFF4B5563);
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard Overview',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: _black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Real-time event management & analytics',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _darkGrey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.admin_panel_settings, color: _gold, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Admin Access',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Metrics Cards
            StreamBuilder<List<Order>>(
              stream: _orderService.getOrders(
                region: _selectedRegion == 'All' ? null : _selectedRegion,
              ),
              builder: (context, snapshot) {
                final orders = snapshot.data ?? [];
                final totalOrders = orders.length;
                final activeOrders = orders.where((o) => 
                  o.status != OrderStatus.completed && 
                  o.status != OrderStatus.cancelled
                ).length;
                final totalRevenue = orders.fold<double>(
                  0, (sum, order) => sum + order.totalAmount
                );
                final pendingPayments = orders.fold<double>(
                  0, (sum, order) => sum + order.balanceAmount
                );
                
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: DatabaseService().getQuotesStream(),
                  builder: (context, quoteSnapshot) {
                    final quotes = quoteSnapshot.data ?? [];
                    final totalQuotes = quotes.length;
                    final pendingQuotes = quotes.where((q) => q['status'] == 'pending').length;

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildMetricCard(
                          icon: Icons.monetization_on_outlined,
                          title: 'Total Revenue',
                          value: 'PKR ${_formatNumber(totalRevenue)}',
                          subtitle: 'Gross Revenue',
                          isHighlight: true, // Only highlight revenue
                        ),
                        _buildMetricCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Total Orders',
                          value: totalOrders.toString(),
                          subtitle: '$activeOrders active',
                          isHighlight: false,
                        ),
                        _buildMetricCard(
                          icon: Icons.request_quote_outlined,
                          title: 'Quotes Requests',
                          value: totalQuotes.toString(),
                          subtitle: '$pendingQuotes pending',
                          isHighlight: false,
                        ),
                        _buildMetricCard(
                          icon: Icons.pending_actions_outlined,
                          title: 'Pending Payment',
                          value: 'PKR ${_formatNumber(pendingPayments)}',
                          subtitle: 'Outstanding',
                          isHighlight: false,
                        ),
                        _buildMetricCard(
                          icon: Icons.event_outlined,
                          title: 'Upcoming Events',
                          value: orders.where((o) => 
                            o.eventDate.isAfter(DateTime.now())
                          ).length.toString(),
                          subtitle: 'Next 30 days',
                          isHighlight: false,
                        ),
                        StreamBuilder<List<EventCategory>>(
                          stream: FirebaseDatabase.instance.ref('events').onValue.map((event) {
                             if (event.snapshot.value == null) return [];
                             final data = Map<String, dynamic>.from(event.snapshot.value as Map);
                             return data.values.map((e) => EventCategory.fromJson(Map<String, dynamic>.from(e as Map))).toList();
                          }),
                          builder: (context, eventSnapshot) {
                            final categories = eventSnapshot.data ?? [];
                            int totalPkgs = 0;
                            for (var c in categories) {
                              for (var s in c.subCategories) {
                                totalPkgs += s.packages.length;
                              }
                            }
                            return _buildMetricCard(
                               icon: Icons.inventory_2_outlined,
                               title: 'Package Library',
                               value: '$totalPkgs',
                               subtitle: '${categories.length} Categories',
                               isHighlight: false,
                            );
                          }
                        ),
                      ],
                    );
                  }
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _black,
              ),
            ),
            const SizedBox(height: 20),
            
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildQuickAction(
                  icon: Icons.add_circle_outline,
                  label: 'New Order',
                  onTap: _showCreateOrderDialog,
                  isPrimary: true,
                ),
                _buildQuickAction(
                  icon: Icons.format_list_bulleted,
                  label: 'View Quotes',
                  onTap: () => context.go('/admin/quotes'),
                ),
                _buildQuickAction(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Manage Orders',
                  onTap: () => context.go('/admin/orders'),
                ),
                 _buildQuickAction(
                  icon: Icons.category_outlined,
                  label: 'Manage Events',
                  onTap: () => context.go('/admin/events'),
                ),
                _buildQuickAction(
                  icon: Icons.history,
                  label: 'Activity Log',
                  onTap: () => context.go('/admin/activity'),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Recent Activity Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Activity',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/admin/activity'),
                          style: TextButton.styleFrom(foregroundColor: _gold),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  StreamBuilder<List<ActivityLog>>(
                    stream: _activityLogService.getRecentActivities(limit: 5),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return _buildErrorCard(snapshot.error.toString());
                      if (!snapshot.hasData) return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      
                      final activities = snapshot.data!;
                      if (activities.isEmpty) {
                         return Padding(
                           padding: const EdgeInsets.all(40),
                           child: Text('No recent activity', style: GoogleFonts.inter(color: Colors.grey)),
                         );
                      }
                      
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, indent: 24, endIndent: 24),
                        itemBuilder: (context, index) {
                          return _buildActivityItem(activities[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
             
             // Advanced Options (Seed Data) - Hidden/Small
             const SizedBox(height: 40),
             Center(
               child: TextButton.icon(
                 onPressed: _seedData,
                 icon: Icon(Icons.build_circle_outlined, size: 14, color: Colors.grey[400]),
                 label: Text('Developer Options: Seed Database', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400])),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required bool isHighlight,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isHighlight ? _black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlight ? null : Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: isHighlight ? _black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighlight ? Colors.white.withOpacity(0.1) : _gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isHighlight ? _gold : _gold, size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.white : _black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isHighlight ? Colors.grey[400] : _darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
           Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isHighlight ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isPrimary ? _gold : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary ? null : Border.all(color: Colors.grey[200]!),
          boxShadow: isPrimary 
            ? [BoxShadow(color: _gold.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
            : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
        ),
        child: Column(
          children: [
            Icon(icon, color: isPrimary ? Colors.white : _black, size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isPrimary ? Colors.white : _black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ActivityLog activity) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _gold.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            activity.action.icon,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      title: Text(
        activity.description,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _black,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '${activity.entityName} • ${_formatTime(activity.timestamp)}',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Center(child: Text('Error: $error', style: const TextStyle(color: Colors.red)));
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
  
  Future<void> _showCreateOrderDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateOrderDialog(),
    );
    
    if (result == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _seedData() async {
    // ... same as before
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seed Database?'),
        content: const Text(
          'This will overwrite existing event packages with default data. '
          'This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Seed Data'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await SeedDataService().seedEventPackages();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Database seeded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error seeding data: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
