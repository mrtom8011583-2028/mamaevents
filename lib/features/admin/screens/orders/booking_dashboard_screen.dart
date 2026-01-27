import 'package:flutter/material.dart';
import '../../../../core/services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'invoice_view.dart';

class BookingDashboardScreen extends StatelessWidget {
  const BookingDashboardScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
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
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final status = order['status'] ?? 'pending';
    final userMap = order['user_details'] as Map? ?? {};
    
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
                       order['user_code'] ?? 'ORDER #${order['id'].toString().substring(order['id'].toString().length - 4)}',
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
                Expanded(child: Text('Package: ${order['package_name'] ?? 'Custom'}', style: GoogleFonts.inter(fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${userMap['name'] ?? 'Guest'} (${userMap['phone'] ?? 'N/A'})', style: GoogleFonts.inter()),
              ],
            ),
             const SizedBox(height: 8),
            if (userMap['email'] != null)
               Padding(
                 padding: const EdgeInsets.only(left: 28),
                 child: Text(userMap['email'], style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
               ),
               
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                 // Print Button
                 IconButton(
                   onPressed: () {
                     Navigator.of(context).push(
                       MaterialPageRoute(builder: (_) => InvoicePrintView(order: order)),
                     );
                   }, 
                   icon: const Icon(Icons.print, color: Color(0xFFC9B037)),
                   tooltip: 'Print Invoice',
                 ),
                 const SizedBox(width: 8),
                 
                 // Reject
                 Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateStatus(context, order['id'], 'cancelled'), // Changed from rejected to cancelled to match enum
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('CANCEL'),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Confirm (Accept)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(context, order['id'], 'confirmed'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text('CONFIRM'),
                  ),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order marked as ${status.toUpperCase()}')));
    }
  }
}
