import 'package:flutter/material.dart';
import '../../../../core/services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'invoice_view.dart';

class BookingDashboardScreen extends StatelessWidget {
  const BookingDashboardScreen({super.key});

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
                      'Order Management',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monitor and process booking requests',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              // Fetch ALL orders
              stream: DatabaseService().getOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('No orders found', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                final orders = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final userMap = order['user_details'] as Map? ?? {};
    final customerName = order['customerName'] ?? order['name'] ?? userMap['name'] ?? 'Guest';
    final customerPhone = order['customerPhone'] ?? order['phone'] ?? userMap['phone'] ?? 'N/A';
    final customerEmail = order['customerEmail'] ?? order['email'] ?? userMap['email'];
    final packageName = order['package_name'] ?? (order['services'] != null ? (order['services'] as List).join(', ') : 'Custom');
    
    // Status Colors
    Color statusColor;
    switch (status) {
      case 'confirmed': statusColor = Colors.blue; break;
      case 'prep': statusColor = Colors.orange; break;
      case 'delivery': statusColor = Colors.purple; break;
      case 'completed': statusColor = Colors.green; break;
      case 'cancelled': statusColor = Colors.red; break;
      default: statusColor = Colors.amber;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       order['orderId'] ?? order['user_code'] ?? 'ORDER #${order['id'].toString().substring(order['id'].toString().length - 4)}',
                       style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                     ),
                     Text(
                        DateFormat('MMM dd, hh:mm a').format(
                           DateTime.fromMillisecondsSinceEpoch(order['createdAt'] ?? DateTime.now().millisecondsSinceEpoch)
                        ),
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                     ),
                   ],
                ),
                // Status Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: status,
                      icon: Icon(Icons.arrow_drop_down, color: statusColor),
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          _updateStatus(context, order['id'], newStatus);
                        }
                      },
                      items: ['pending', 'confirmed', 'prep', 'delivery', 'completed', 'cancelled']
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.toUpperCase()),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Details
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text('Package: $packageName', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text('$customerName ($customerPhone)', style: GoogleFonts.inter()),
              ],
            ),
             const SizedBox(height: 8),
            if (customerEmail != null)
               Padding(
                 padding: const EdgeInsets.only(left: 28),
                 child: Text(customerEmail, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
               ),
               
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                     Navigator.of(context).push(
                       MaterialPageRoute(builder: (_) => InvoicePrintView(order: order)),
                     );
                  },
                  icon: const Icon(Icons.print_outlined, size: 18),
                  label: const Text('Invoice'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 8),
                if (status != 'cancelled')
                  TextButton(
                    onPressed: () => _updateStatus(context, order['id'], 'cancelled'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red[400]),
                    child: const Text('Cancel Order'),
                  ),
                const SizedBox(width: 8),
                if (status != 'confirmed' && status != 'completed')
                ElevatedButton(
                  onPressed: () => _updateStatus(context, order['id'], 'confirmed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC6A869),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('CONFIRM'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String? orderId, String status) async {
    if (orderId == null) return;
    await DatabaseService().updateOrderStatus(orderId, status);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order marked as ${status.toUpperCase()}'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }
}
