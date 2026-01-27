import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order_model.dart';
import '../models/activity_log_model.dart';
import '../services/order_service.dart';
import '../services/activity_log_service.dart';
import '../widgets/create_order_dialog.dart';
import '../../core/services/database_service.dart';
import '../../core/services/seed_data_service.dart';

/// Enhanced Admin Dashboard - MAMA EVENTS
/// Professional event management interface
class EnhancedAdminDashboard extends StatefulWidget {
  const EnhancedAdminDashboard({super.key});

  @override
  State<EnhancedAdminDashboard> createState() => _EnhancedAdminDashboardState();
}

class _EnhancedAdminDashboardState extends State<EnhancedAdminDashboard> {
  final OrderService _orderService = OrderService();
  final ActivityLogService _activityLogService = ActivityLogService();
  
  String _selectedRegion = 'All';
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.event, color: Color(0xFFC6A869), size: 28),
            const SizedBox(width: 12),
            Text(
              'MAMA EVENTS',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFC6A869).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'ADMIN',
                style: GoogleFonts.inter(
                  color: const Color(0xFFC6A869),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Region Selector
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedRegion,
              dropdownColor: const Color(0xFF212121),
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              items: ['All', 'Pakistan'].map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRegion = value);
                }
              },
            ),
          ),
          
          // User Menu
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: const Color(0xFFC6A869),
              child: Text(
                user?.email?.substring(0, 1).toUpperCase() ?? 'A',
                style: const TextStyle(
                  color: Color(0xFF212121),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 18),
                    const SizedBox(width: 8),
                    Text(user?.email ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  context.go('/admin/login');
                }
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Dashboard Overview',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Real-time event management & analytics',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),
            
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
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildMetricCard(
                          icon: Icons.trending_up,
                          iconColor: const Color(0xFF059669),
                          title: 'Total Revenue',
                          value: 'PKR ${_formatNumber(totalRevenue)}',
                          subtitle: '+12% from last month',
                          isPositive: true,
                        ),
                        _buildMetricCard(
                          icon: Icons.shopping_bag,
                          iconColor: const Color(0xFF3B82F6),
                          title: 'Total Orders',
                          value: totalOrders.toString(),
                          subtitle: '$activeOrders active orders',
                          isPositive: true,
                        ),
                        _buildMetricCard(
                          icon: Icons.format_quote,
                          iconColor: const Color(0xFF6366F1),
                          title: 'Total Quotes',
                          value: totalQuotes.toString(),
                          subtitle: '$pendingQuotes pending requests',
                          isPositive: true,
                        ),
                        _buildMetricCard(
                          icon: Icons.pending_actions,
                          iconColor: const Color(0xFFF59E0B),
                          title: 'Pending Payment',
                          value: 'PKR ${_formatNumber(pendingPayments)}',
                          subtitle: 'Outstanding balance',
                          isPositive: false,
                        ),
                        _buildMetricCard(
                          icon: Icons.event_available,
                          iconColor: const Color(0xFF8B5CF6),
                          title: 'Upcoming Events',
                          value: orders.where((o) => 
                            o.eventDate.isAfter(DateTime.now())
                          ).length.toString(),
                          subtitle: 'Next 30 days',
                          isPositive: true,
                        ),
                      ],
                    );
                  }
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Quick Actions
            Row(
              children: [
                Text(
                  'Quick Actions',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickAction(
                  icon: Icons.add_circle,
                  label: 'New Order',
                  color: const Color(0xFF059669),
                  onTap: _showCreateOrderDialog,
                ),
                _buildQuickAction(
                  icon: Icons.format_quote,
                  label: 'View Quotes',
                  color: const Color(0xFF3B82F6),
                  onTap: () => context.go('/admin/quotes'),
                ),
                _buildQuickAction(
                  icon: Icons.shopping_bag,
                  label: 'Manage Orders',
                  color: const Color(0xFF8B5CF6),
                  onTap: () => context.go('/admin/orders'),
                ),
                 _buildQuickAction(
                  icon: Icons.category,
                  label: 'Manage Events',
                  color: const Color(0xFFEC4899), // Pink
                  onTap: () => context.go('/admin/events'),
                ),
                _buildQuickAction(
                  icon: Icons.history,
                  label: 'Activity Log',
                  color: const Color(0xFF6B7280),
                  onTap: () => context.go('/admin/activity'),
                ),
                _buildQuickAction(
                  icon: Icons.cloud_upload,
                  label: 'Seed Events',
                  color: const Color(0xFF6366F1),
                  onTap: _seedData,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/admin/activity'),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            StreamBuilder<List<ActivityLog>>(
              stream: _activityLogService.getRecentActivities(limit: 5),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorCard(snapshot.error.toString());
                }
                
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final activities = snapshot.data!;
                
                if (activities.isEmpty) {
                  return _buildEmptyState(
                    icon: Icons.history,
                    message: 'No recent activity',
                  );
                }
                
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return _buildActivityItem(activity);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required bool isPositive,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.info_outline,
                size: 14,
                color: isPositive ? const Color(0xFF059669) : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ActivityLog activity) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getActionColor(activity.action).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            activity.action.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      title: Text(
        activity.description,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1F2937),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            activity.entityName,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            '${activity.performedByName} • ${_formatTime(activity.timestamp)}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: const Color(0xFF9CA3AF)),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
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
      // Order created successfully, refresh if needed
      setState(() {});
    }
  }

  Future<void> _seedData() async {
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
