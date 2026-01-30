import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import '../../core/services/database_service.dart';

/// Create Order from Quote Dialog
/// Professional order creation with auto-fill from quote
class CreateOrderDialog extends StatefulWidget {
  final String? preselectedQuoteId;
  
  const CreateOrderDialog({
    super.key,
    this.preselectedQuoteId,
  });

  @override
  State<CreateOrderDialog> createState() => _CreateOrderDialogState();
}

class _CreateOrderDialogState extends State<CreateOrderDialog> {
  final OrderService _orderService = OrderService();
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedQuoteId;
  Map<String, dynamic>? _selectedQuote;
  bool _isLoading = false;
  
  // Form controllers
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.preselectedQuoteId != null) {
      _loadQuote(widget.preselectedQuoteId!);
    }
  }
  
  @override
  void dispose() {
    _totalAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _loadQuote(String quoteId) async {
    setState(() => _isLoading = true);
    
    try {
      final snapshot = await DatabaseService().quotesRef
          .orderByChild('quoteId')
          .equalTo(quoteId)
          .limitToFirst(1)
          .get();
      
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.children.first.value as Map);
        setState(() {
          _selectedQuoteId = quoteId;
          _selectedQuote = data;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading quote: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Create Order from Quote',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quote Selection
                            if (_selectedQuote == null)
                              _buildQuoteSelector()
                            else
                              _buildQuoteDetails(),
                            
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                            
                            // Order Details
                            if (_selectedQuote != null) ...[
                              _buildOrderForm(),
                            ],
                          ],
                        ),
                      ),
                    ),
            ),
            
            // Actions
            if (_selectedQuote != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _createOrder,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Create Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteSelector() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().getQuotesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final quotes = snapshot.data!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Quote',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...quotes.map((data) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.format_quote, color: Color(0xFF1E3A8A)),
                  title: Text(data['quoteId'] ?? 'Unknown'),
                  subtitle: Text('${data['name'] ?? 'Unknown Customer'} • ${data['guestCount'] ?? '?'} guests\n${data['eventLocation'] ?? data['location'] ?? 'No Location'}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _loadQuote(data['quoteId']),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildQuoteDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF059669)),
              const SizedBox(width: 8),
              Text(
                'Quote Selected',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Quote ID', _selectedQuote!['quoteId'] ?? 'Unknown ID'),
          _buildDetailRow('Customer', _selectedQuote!['name'] ?? 'Unknown Customer'),
          _buildDetailRow('Email', _selectedQuote!['email'] ?? 'N/A'),
          _buildDetailRow('Phone', _selectedQuote!['phone'] ?? 'N/A'),
          _buildDetailRow('Guests', '${_selectedQuote!['guestCount'] ?? 0}'),
          _buildDetailRow('Region', _selectedQuote!['region'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Details',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Total Amount
        TextFormField(
          controller: _totalAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Total Amount *',
            hintText: 'Enter total order amount',
            prefixText: 'PKR ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Required';
            if (double.tryParse(v) == null) return 'Invalid amount';
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Notes
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'Add any special instructions or notes',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final totalAmount = double.parse(_totalAmountController.text);
      final region = 'pakistan';
      final currency = 'PKR';
      
      // Get event date from quote or use future date
      DateTime eventDate;
      
      DateTime? parseDate(dynamic date) {
        if (date == null) return null;
        if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
        if (date is Timestamp) return date.toDate();
        return null;
      }

      eventDate = parseDate(_selectedQuote!['eventDate']) ?? 
                  parseDate(_selectedQuote!['serviceDate']) ?? 
                  DateTime.now().add(const Duration(days: 30));
      
      await _orderService.createOrder(
        quoteId: _selectedQuoteId!,
        customerId: _selectedQuote!['email'] ?? 'unknown',
        customerName: _selectedQuote!['name'] ?? 'Unknown',
        customerEmail: _selectedQuote!['email'] ?? 'unknown@example.com',
        customerPhone: _selectedQuote!['phone'] ?? 'N/A',
        eventType: _selectedQuote!['serviceType'] ?? _selectedQuote!['eventType'] ?? 'Event',
        eventLocation: _selectedQuote!['eventLocation'] ?? _selectedQuote!['location'] ?? 'TBD',
        eventDate: eventDate,
        guestCount: _selectedQuote!['guestCount'] ?? 50,
        totalAmount: totalAmount,
        currency: currency,
        region: region,
        services: (_selectedQuote!['serviceStyles'] as List?)?.cast<String>() ?? [],
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order created successfully!'),
            backgroundColor: Color(0xFF059669),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
