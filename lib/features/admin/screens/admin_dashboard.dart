import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/database_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            _buildAdminCard(
              context,
              title: 'Manage Menu',
              icon: Icons.restaurant_menu,
              color: Colors.orange,
              onTap: () => context.go('/admin/menu'),
            ),
            _buildAdminCard(
              context,
              title: 'Live Stations',
              icon: Icons.storefront,
              color: Colors.purple,
              onTap: () => context.go('/admin/live-stations'),
            ),
            _buildAdminCard(
              context,
              title: 'Event Packages',
              icon: Icons.card_giftcard,
              color: const Color(0xFFC9B037), // Gold
              onTap: () => context.go('/admin/packages'),
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: DatabaseService().getPendingOrdersStream(),
              builder: (context, snapshot) {
                final count = snapshot.hasData ? snapshot.data!.length : 0;
                return _buildAdminCard(
                  context,
                  title: 'Booking Requests',
                  icon: Icons.inbox,
                  color: Colors.blue,
                  count: count,
                  onTap: () => context.go('/admin/orders'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int? count,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (count != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count New',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
