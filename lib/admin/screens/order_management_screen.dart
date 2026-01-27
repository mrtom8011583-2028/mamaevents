import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../services/activity_log_service.dart';
import '../models/activity_log_model.dart';

/// Order Management Screen - MAMA EVENTS
/// Professional order tracking and management interface
class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final OrderService _orderService = OrderService();
  final ActivityLogService _activityLogService = ActivityLogService();
  
  String _selectedRegion = 'All';
  OrderStatus? _selectedStatus;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: Text(
          'Order Management',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Region Filter
                Expanded(
                  child: _buildFilterChip(
                    label: _selectedRegion,
                    icon: Icons.location_on,
                    onTap: _showRegionFilter,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Status Filter
                Expanded(
                  child: _buildFilterChip(
                    label: _selectedStatus?.label ?? 'All Status',
                    icon: Icons.filter_alt,
                    onTap: _showStatusFilter,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Clear Filters
                if (_selectedStatus != null || _selectedRegion != 'All')
                  IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFDC2626)),
                    onPressed: () {
                      setState(() {
                        _selectedRegion = 'All';
                        _selectedStatus = null;
                      });
                    },
                  ),
              ],
            ),
          ),
          
          // Order List
          Expanded(
            child: StreamBuilder<List<Order>>(
              stream: _orderService.getOrders(
                region: _selectedRegion == 'All' ? null : _selectedRegion,
                status: _selectedStatus,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildError(snapshot.error.toString());
                }
                
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final orders = snapshot.data!;
                
                if (orders.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(orders[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF6B7280)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final isOverdue = order.isOverdue;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue 
          ? const BorderSide(color: Color(0xFFDC2626), width: 2)
          : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderId,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.customerName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              // Order Details Grid
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.event,
                      label: 'Event',
                      value: order.eventType,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: '${order.eventDate.day}/${order.eventDate.month}/${order.eventDate.year}',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.people,
                      label: 'Guests',
                      value: '${order.guestCount}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.location_on,
                      label: 'Region',
                      value: order.region,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              
              // Payment Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.currency} ${order.totalAmount.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  
                  _buildPaymentBadge(order.paymentStatus, order.paymentPercentage),
                ],
              ),
              
              // Progress Bar
              if (order.paymentStatus != PaymentStatus.paid)
                Column(
                  children: [
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: order.paymentPercentage / 100,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        order.paymentPercentage >= 80
                          ? const Color(0xFF059669)
                          : order.paymentPercentage >= 50
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Paid: ${order.currency} ${order.paidAmount.toStringAsFixed(0)} • Balance: ${order.currency} ${order.balanceAmount.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              
              // Quick Actions
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  _buildActionButton(
                    label: 'Update Status',
                    icon: Icons.update,
                    onTap: () => _showStatusUpdate(order),
                  ),
                  _buildActionButton(
                    label: 'Record Payment',
                    icon: Icons.payment,
                    onTap: () => _showPaymentDialog(order),
                  ),
                  _buildActionButton(
                    label: 'View Timeline',
                    icon: Icons.timeline,
                    onTap: () => _showTimeline(order),
                  ),
                ],
              ),
              
              // Overdue Warning
              if (isOverdue)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Color(0xFFDC2626), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'OVERDUE - Event date has passed',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bgColor, textColor;
    
    switch (status) {
      case OrderStatus.pending:
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFF59E0B);
        break;
      case OrderStatus.confirmed:
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF059669);
        break;
      case OrderStatus.preparing:
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF3B82F6);
        break;
      case OrderStatus.completed:
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF10B981);
        break;
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(status.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            status.label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBadge(PaymentStatus status, double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status == PaymentStatus.paid
          ? const Color(0xFFDCFCE7)
          : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status == PaymentStatus.paid
          ? '${status.icon} PAID'
          : '${status.icon} ${percentage.toStringAsFixed(0)}% Paid',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: status == PaymentStatus.paid
            ? const Color(0xFF059669)
            : const Color(0xFFF59E0B),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF374151)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here once created',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
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

  // Dialog Methods
  void _showFilters() {
    // TODO: Implement advanced filters
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced filters coming soon')),
    );
  }

  void _showRegionFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Region'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['All', 'Pakistan'].map((region) {
            return RadioListTile<String>(
              title: Text(region),
              value: region,
              groupValue: _selectedRegion,
              onChanged: (value) {
                setState(() => _selectedRegion = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStatusFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<OrderStatus?>(
              title: const Text('All'),
              value: null,
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() => _selectedStatus = value);
                Navigator.pop(context);
              },
            ),
            ...OrderStatus.values.map((status) {
              return RadioListTile<OrderStatus?>(
                title: Text('${status.icon} ${status.label}'),
                value: status,
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() => _selectedStatus = value);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    // TODO: Navigate to detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order details for ${order.orderId}')),
    );
  }

  void _showStatusUpdate(Order order) async {
    OrderStatus? newStatus = await showDialog<OrderStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderStatus.values.map((status) {
            return ListTile(
              leading: Text(status.icon, style: const TextStyle(fontSize: 24)),
              title: Text(status.label),
              onTap: () => Navigator.pop(context, status),
            );
          }).toList(),
        ),
      ),
    );

    if (newStatus != null && mounted) {
      try {
        await _orderService.updateStatus(
          orderId: order.orderId,
          newStatus: newStatus,
          note: 'Status updated via admin panel',
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status updated successfully'), backgroundColor: Color(0xFF059669)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFDC2626)),
          );
        }
      }
    }
  }

  void _showPaymentDialog(Order order) {
    final amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Balance: ${order.currency} ${order.balanceAmount}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (${order.currency})',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                try {
                  await _orderService.recordPayment(
                    orderId: order.orderId,
                    amount: amount,
                  );
                  
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment recorded'), backgroundColor: Color(0xFF059669)),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  void _showTimeline(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Timeline - ${order.orderId}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: order.timeline.length,
            itemBuilder: (context, index) {
              final item = order.timeline[index];
              return ListTile(
                leading: Text(item.status.icon, style: const TextStyle(fontSize: 24)),
                title: Text(item.status.label),
                subtitle: Text(
                  '${item.performedBy}\n${item.timestamp}${item.note != null ? '\n${item.note}' : ''}',
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
