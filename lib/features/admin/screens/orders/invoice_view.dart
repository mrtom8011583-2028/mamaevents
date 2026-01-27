import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InvoicePrintView extends StatelessWidget {
  final Map<String, dynamic> order;

  const InvoicePrintView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final userMap = order['user_details'] as Map? ?? {}; // Backwards compat if fields were flat
    final name = order['name'] ?? userMap['name'] ?? 'Valued Customer';
    final email = order['email'] ?? userMap['email'] ?? '';
    final phone = order['phone'] ?? userMap['phone'] ?? '';
    final address = order['eventLocation'] ?? 'Location TBD';
    
    final guests = order['guestCount'] ?? 0;
    final basePrice = (order['basePricePerHead'] ?? 0).toDouble();
    final total = (order['estimatedTotal'] ?? 0).toDouble();
    final packageName = order['packageName'] ?? order['package_name'] ?? 'Custom Service';
    final serviceType = order['serviceType'] ?? 'Catering';
    
    final date = order['createdAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(order['createdAt']) 
        : DateTime.now();

    final invoiceId = order['quoteId'] ?? order['id'] ?? 'INV-0000';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Invoice Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Trigger browser print
              // In Flutter Web, this is handled by the browser
              // Use a plugin or just JS interop if needed, but usually Ctrl+P works 
              // nicely on a clean page.
            },
            tooltip: 'Use Browser Print (Ctrl+P)',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'MAMA EVENTS',
                         style: GoogleFonts.inter(
                           fontSize: 28,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                           letterSpacing: 2,
                         ),
                       ),
                       Text('Premium Event Services', style: GoogleFonts.inter(color: Colors.grey)),
                     ],
                   ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Text('INVOICE', style: GoogleFonts.inter(fontSize: 24, color: Colors.grey.shade300, fontWeight: FontWeight.bold)),
                       Text('#$invoiceId', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                       Text(DateFormat('MMM dd, yyyy').format(date), style: GoogleFonts.inter()),
                     ],
                   ),
                ],
              ),
              const SizedBox(height: 48),
              
              // Bill To
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BILL TO:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                        if (phone.isNotEmpty) Text(phone, style: GoogleFonts.inter()),
                        if (email.isNotEmpty) Text(email, style: GoogleFonts.inter()),
                        const SizedBox(height: 8),
                        Text('Event Location:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                        Text(address, style: GoogleFonts.inter()),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Table
              Table(
                border: TableBorder(
                  bottom: BorderSide(color: Colors.grey.shade300),
                  horizontalInside: BorderSide(color: Colors.grey.shade100),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                children: [
                  // Headers
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    children: [
                      _buildHeaderCell('DESCRIPTION'),
                      _buildHeaderCell('GUESTS'),
                      _buildHeaderCell('RATE'),
                      _buildHeaderCell('AMOUNT', align: TextAlign.right),
                    ],
                  ),
                  // Row
                  TableRow(
                    children: [
                      _buildCell(
                        '$packageName\n$serviceType', 
                        isBold: true
                      ),
                      _buildCell(guests.toString()),
                      _buildCell(basePrice > 0 ? 'Rs ${NumberFormat('#,###').format(basePrice)}' : '-'),
                      _buildCell(
                        total > 0 ? 'Rs ${NumberFormat('#,###').format(total)}' : 'TBD', 
                        align: TextAlign.right
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Totals
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (total > 0) ...[
                        Text('TOTAL', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          'PKR ${NumberFormat('#,###').format(total)}',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFC9B037),
                          ),
                        ),
                      ] else 
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                          child: Text('Price To Be Determined', style: GoogleFonts.inter(color: Colors.grey)),
                        ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 80),
              
              // Footer
              Center(
                child: Text(
                  'Thank you for choosing Mama Events!',
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
        textAlign: align,
      ),
    );
  }

  Widget _buildCell(String text, {bool isBold = false, TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }
}
