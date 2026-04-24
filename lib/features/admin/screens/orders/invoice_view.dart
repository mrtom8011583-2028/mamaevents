import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../../../../config/constants/image_assets.dart';

class InvoicePrintView extends StatefulWidget {
  final Map<String, dynamic> order;

  const InvoicePrintView({super.key, required this.order});

  @override
  State<InvoicePrintView> createState() => _InvoicePrintViewState();
}

class _InvoicePrintViewState extends State<InvoicePrintView> {
  // Optional extra charges state
  bool _showExtraCharge = false;
  bool _isEditingExtra = true;
  final TextEditingController _extraDescController = TextEditingController();
  final TextEditingController _extraAmountController = TextEditingController();
  double _extraAmount = 0;

  @override
  void initState() {
    super.initState();
    _extraAmountController.addListener(() {
      setState(() {
        _extraAmount = double.tryParse(_extraAmountController.text) ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _extraDescController.dispose();
    _extraAmountController.dispose();
    super.dispose();
  }

  Future<void> _printDoc() async {
    final doc = await _generatePdf(PdfPageFormat.a4);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_${widget.order['orderId'] ?? 'Order'}.pdf',
    );
  }

  Future<void> _downloadPdf() async {
    final doc = await _generatePdf(PdfPageFormat.a4);
    await Printing.sharePdf(
        bytes: await doc.save(), 
        filename: 'Invoice_${widget.order['orderId'] ?? 'Order'}.pdf'
    );
  }

  Future<pw.Document> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final order = widget.order;
    final userMap = order['user_details'] as Map? ?? {};
    final name = order['customerName'] ?? order['name'] ?? userMap['name'] ?? 'Valued Customer';
    final email = order['customerEmail'] ?? order['email'] ?? userMap['email'] ?? '';
    final phone = order['customerPhone'] ?? order['phone'] ?? userMap['phone'] ?? '';
    final address = order['eventLocation'] ?? 'Location TBD';
    final guests = order['guestCount'] ?? 0;
    
    final total = (order['totalAmount'] ?? order['estimatedTotal'] ?? 0).toDouble();
    final double basePrice = (order['basePricePerHead'] ?? 0).toDouble();
    final double rate = basePrice > 0 
        ? basePrice 
        : (guests > 0 ? total / guests : 0);

    final finalTotal = total + _extraAmount;

    final packageName = order['packageName'] ?? order['package_name'] ?? (order['services'] != null ? (order['services'] as List).join(', ') : 'Custom Service');
    final serviceType = order['eventType'] ?? order['serviceType'] ?? 'Catering';
    
    final date = order['createdAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(order['createdAt']) 
        : DateTime.now();

    final invoiceId = order['orderId'] ?? order['quoteId'] ?? order['id'] ?? 'INV-0000';
    
    final fontRegular = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();
    final fontMono = await PdfGoogleFonts.robotoMonoBold();


    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format,
          theme: pw.ThemeData.withFont(
            base: fontRegular,
            bold: fontBold,
          ),
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
               // Header
               pw.Container(
                 padding: const pw.EdgeInsets.all(20),
                 decoration: pw.BoxDecoration(
                   color: PdfColors.black,
                   border: pw.Border(bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFC6A869), width: 4)),
                 ),
                 child: pw.Row(
                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                   children: [
                     pw.Row(
                       children: [
                         pw.Container(
                           height: 50,
                           width: 50,
                           decoration: pw.BoxDecoration(
                             border: pw.Border.all(color: PdfColor.fromInt(0xFFC6A869)),
                             borderRadius: pw.BorderRadius.circular(8),
                           ),
                           child: pw.Center(
                             child: pw.Text(
                               'M', 
                               style: pw.TextStyle(
                                 color: PdfColor.fromInt(0xFFC6A869),
                                 fontWeight: pw.FontWeight.bold,
                                 fontSize: 28,
                               )
                             ),
                           ),
                         ),
                         pw.SizedBox(width: 10),
                         pw.Column(
                           crossAxisAlignment: pw.CrossAxisAlignment.start,
                           children: [
                             pw.Text('MAMA EVENTS', style: pw.TextStyle(color: PdfColors.white, fontSize: 20, fontWeight: pw.FontWeight.bold)),
                             pw.Text('PREMIUM CATERING', style: pw.TextStyle(color: PdfColor.fromInt(0xFFC6A869), fontSize: 8)),
                           ],
                         ),
                       ],
                     ),
                     pw.Column(
                       crossAxisAlignment: pw.CrossAxisAlignment.end,
                       children: [
                         pw.Text('INVOICE', style: pw.TextStyle(color: PdfColors.white, fontSize: 24, fontWeight: pw.FontWeight.bold)),
                         pw.Text('#$invoiceId', style: pw.TextStyle(color: PdfColors.white, font: fontMono, fontSize: 12)),
                         pw.Text(DateFormat('MMMM dd, yyyy').format(date), style: pw.TextStyle(color: PdfColors.grey400, fontSize: 10)),
                       ],
                     ),
                   ],
                 ),
               ),

               pw.SizedBox(height: 30),

               // Bill To & Event Details
               pw.Row(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                 children: [
                   pw.Column(
                     crossAxisAlignment: pw.CrossAxisAlignment.start,
                     children: [
                       pw.Text('BILL TO', style: pw.TextStyle(color: PdfColor.fromInt(0xFFC6A869), fontSize: 10, fontWeight: pw.FontWeight.bold)),
                       pw.SizedBox(height: 5),
                       pw.Text(name, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                       if (phone.isNotEmpty) pw.Text(phone, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                       if (email.isNotEmpty) pw.Text(email, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                     ],
                   ),
                   pw.Column(
                     crossAxisAlignment: pw.CrossAxisAlignment.end,
                     children: [
                       pw.Text('EVENT DETAILS', style: pw.TextStyle(color: PdfColor.fromInt(0xFFC6A869), fontSize: 10, fontWeight: pw.FontWeight.bold)),
                       pw.SizedBox(height: 5),
                       pw.Text(serviceType, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                       pw.Text(address, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                       pw.Text('$guests Guests', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                     ],
                   ),
                 ],
               ),

               pw.SizedBox(height: 30),

               // Table
               pw.Container(
                 decoration: pw.BoxDecoration(
                   border: pw.Border.all(color: PdfColors.grey200),
                   borderRadius: pw.BorderRadius.circular(4),
                 ),
                 child: pw.Column(
                   children: [
                     pw.Container(
                       color: PdfColors.black,
                       padding: const pw.EdgeInsets.all(10),
                       child: pw.Row(
                         children: [
                           pw.Expanded(flex: 4, child: pw.Text('DESCRIPTION', style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold))),
                           pw.Expanded(flex: 1, child: pw.Text('QTY', style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                           pw.Expanded(flex: 2, child: pw.Text('RATE', style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                           pw.Expanded(flex: 2, child: pw.Text('AMOUNT', style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                         ],
                       ),
                     ),
                     pw.Padding(
                       padding: const pw.EdgeInsets.all(10),
                       child: pw.Row(
                         children: [
                           pw.Expanded(flex: 4, child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                              pw.Text(packageName, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                              pw.Text(serviceType, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                           ])),
                           pw.Expanded(flex: 1, child: pw.Text('$guests', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10))),
                           pw.Expanded(flex: 2, child: pw.Text(NumberFormat('#,###').format(rate), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
                           pw.Expanded(flex: 2, child: pw.Text(NumberFormat('#,###').format(total), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                         ],
                       ),
                     ),
                     if (_showExtraCharge)
                       pw.Container(
                         color: PdfColor.fromInt(0xFFFFFBE6),
                         padding: const pw.EdgeInsets.all(10),
                         child: pw.Row(
                           children: [
                             pw.Expanded(flex: 4, child: pw.Text(_extraDescController.text.isEmpty ? 'Extra Service' : _extraDescController.text, style: pw.TextStyle(fontSize: 10, color: PdfColor.fromInt(0xFFB45309)))),
                             pw.Expanded(flex: 1, child: pw.Text('1', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10))),
                             pw.Expanded(flex: 2, child: pw.Text(NumberFormat('#,###').format(_extraAmount), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
                             pw.Expanded(flex: 2, child: pw.Text(NumberFormat('#,###').format(_extraAmount), textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFFB45309)))),
                           ],
                         ),
                       ),
                   ],
                 ),
               ),

               pw.SizedBox(height: 20),

               // Totals
               pw.Row(
                 mainAxisAlignment: pw.MainAxisAlignment.end,
                 children: [
                   pw.Column(
                     crossAxisAlignment: pw.CrossAxisAlignment.end,
                     children: [
                       pw.Row(children: [
                         pw.SizedBox(width: 80, child: pw.Text('Subtotal', style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 10))),
                         pw.SizedBox(width: 80, child: pw.Text('Rs ${NumberFormat('#,###').format(total)}', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                       ]),
                       if (_showExtraCharge)
                         pw.Padding(padding: const pw.EdgeInsets.only(top: 5), child: pw.Row(children: [
                           pw.SizedBox(width: 80, child: pw.Text('Adjustments', style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 10))),
                           pw.SizedBox(width: 80, child: pw.Text('Rs ${NumberFormat('#,###').format(_extraAmount)}', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
                         ])),
                       pw.SizedBox(height: 10),
                       pw.Container(height: 1, width: 160, color: PdfColors.grey300),
                       pw.SizedBox(height: 10),
                       pw.Row(children: [
                         pw.SizedBox(width: 80, child: pw.Text('TOTAL', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),
                         pw.SizedBox(width: 80, child: pw.Text('PKR ${NumberFormat('#,###').format(finalTotal)}', textAlign: pw.TextAlign.right, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFFC6A869)))),
                       ]),
                     ],
                   ),
                 ],
               ),
               
               pw.Spacer(),
               
               // Footer
               pw.Container(
                 padding: const pw.EdgeInsets.all(20),
                 color: PdfColors.grey100,
                 child: pw.Column(
                   children: [
                     pw.Text('Thank you for choosing Mama Events!', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                     pw.Text('Please make checks payable to "Mama Events"', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                     pw.Text('For questions, contact us at info@mamaevents.pk', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                   ],
                 ),
               ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final userMap = order['user_details'] as Map? ?? {};
    final name = order['customerName'] ?? order['name'] ?? userMap['name'] ?? 'Valued Customer';
    final email = order['customerEmail'] ?? order['email'] ?? userMap['email'] ?? '';
    final phone = order['customerPhone'] ?? order['phone'] ?? userMap['phone'] ?? '';
    final address = order['eventLocation'] ?? 'Location TBD';
    
    final guests = order['guestCount'] ?? 0;
    
    // Base Calculations
    final total = (order['totalAmount'] ?? order['estimatedTotal'] ?? 0).toDouble();
    final double basePrice = (order['basePricePerHead'] ?? 0).toDouble();
    final double rate = basePrice > 0 
        ? basePrice 
        : (guests > 0 ? total / guests : 0);

    // Final Total with Extras
    final finalTotal = total + _extraAmount;

    final packageName = order['packageName'] ?? order['package_name'] ?? (order['services'] != null ? (order['services'] as List).join(', ') : 'Custom Service');
    final serviceType = order['eventType'] ?? order['serviceType'] ?? 'Catering';
    
    final date = order['createdAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(order['createdAt']) 
        : DateTime.now();

    final invoiceId = order['orderId'] ?? order['quoteId'] ?? order['id'] ?? 'INV-0000';

    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white background for contrast
      appBar: AppBar(
        title: Text('Invoice Preview', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFFC6A869))),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFC6A869)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadPdf,
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printDoc,
            tooltip: 'Print (Ctrl+P)',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Premium Header
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    border: Border(bottom: BorderSide(color: Color(0xFFC6A869), width: 4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo & Brand
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFC6A869), width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              ImageAssets.logo,
                              height: 50,
                              width: 50,
                              color: Colors.white, // Tint logo white for black bg if it's transparent
                              errorBuilder: (c, e, s) => const Icon(Icons.restaurant_menu, color: Color(0xFFC6A869), size: 40),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MAMA EVENTS',
                                style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'PREMIUM CATERING & EVENTS',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFFC6A869),
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Invoice Details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('INVOICE', style: GoogleFonts.inter(fontSize: 32, color: const Color(0xFF333333), fontWeight: FontWeight.bold)), // Subtle dark text on black? No, white.
                          Text('INVOICE', style: GoogleFonts.inter(fontSize: 32, color: Colors.white.withOpacity(0.1), fontWeight: FontWeight.bold)), // Watermark style
                          const SizedBox(height: 4),
                          Text('#$invoiceId', style: GoogleFonts.robotoMono(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(DateFormat('MMMM dd, yyyy').format(date), style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. Client Info Section
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bill To
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('BILL TO', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFC6A869), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            const SizedBox(height: 12),
                            Text(name, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                            if (phone.isNotEmpty) 
                              Padding(padding: const EdgeInsets.only(top: 4), child: Text(phone, style: GoogleFonts.inter(color: Colors.grey[700]))),
                            if (email.isNotEmpty) 
                              Padding(padding: const EdgeInsets.only(top: 4), child: Text(email, style: GoogleFonts.inter(color: Colors.grey[700]))),
                          ],
                        ),
                      ),
                      
                      // Event Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('EVENT DETAILS', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFC6A869), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            const SizedBox(height: 12),
                            Text(serviceType, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(address, style: GoogleFonts.inter(color: Colors.grey[700]), textAlign: TextAlign.right),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('$guests Guests', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Items Table
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text('DESCRIPTION', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                            Expanded(flex: 1, child: Text('QTY', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text('RATE', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                            Expanded(flex: 2, child: Text('AMOUNT', style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                          ],
                        ),
                      ),
                      // Main Item
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4, 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(packageName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(height: 4),
                                  Text(serviceType, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13)),
                                ],
                              )
                            ),
                            Expanded(flex: 1, child: Text(guests.toString(), textAlign: TextAlign.center, style: GoogleFonts.inter())),
                            Expanded(flex: 2, child: Text(rate > 0 ? NumberFormat('#,###').format(rate) : '-', textAlign: TextAlign.right, style: GoogleFonts.inter())),
                            Expanded(flex: 2, child: Text(total > 0 ? NumberFormat('#,###').format(total) : 'TBD', textAlign: TextAlign.right, style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      
                      // Optional Extra Item
                      if (_showExtraCharge)
                        Container(
                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                           decoration: BoxDecoration(
                             color: const Color(0xFFFFFBE6), // Subtle yellow tint
                             border: Border(top: BorderSide(color: Colors.grey[100]!)),
                           ),
                           child: Row(
                            children: [
                              // Description
                              Expanded(
                                flex: 4,
                                child: _isEditingExtra 
                                  ? TextField(
                                      controller: _extraDescController,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter extra service name...',
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFFB45309)),
                                    )
                                  : Text(
                                      _extraDescController.text.isEmpty ? 'Extra Service' : _extraDescController.text,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFFB45309)),
                                    ),
                              ),
                              
                              // Qty (Fixed as 1)
                              Expanded(flex: 1, child: Text('1', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey))),
                              
                              // Rate
                              Expanded(flex: 2, child: Text(NumberFormat('#,###').format(_extraAmount), textAlign: TextAlign.right, style: GoogleFonts.inter(color: Colors.grey))),
                              
                              // Amount (Editable)
                              Expanded(
                                flex: 2, 
                                child: _isEditingExtra
                                  ? TextField(
                                      controller: _extraAmountController,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: '0',
                                        border: InputBorder.none,
                                        isDense: true,
                                        prefixText: 'Rs ',
                                      ),
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFFB45309)),
                                    )
                                  : Text(
                                      'Rs ${NumberFormat('#,###').format(_extraAmount)}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFFB45309)),
                                    ),
                              ),
                              
                              // Actions
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  children: [
                                    if (_isEditingExtra)
                                      IconButton(
                                        icon: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                        onPressed: () => setState(() => _isEditingExtra = false),
                                        tooltip: 'Save',
                                      )
                                    else
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                        onPressed: () => setState(() => _isEditingExtra = true),
                                        tooltip: 'Edit',
                                      ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _showExtraCharge = false;
                                          _extraAmount = 0;
                                          _extraAmountController.clear();
                                          _extraDescController.clear();
                                        });
                                      },
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // 4. Add Line Item Button (For Print View only)
                if (!_showExtraCharge)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, top: 12),
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                             _showExtraCharge = true;
                             _isEditingExtra = true;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 16),
                        label: const Text('Add Adjustment / Extra Service'),
                        style: TextButton.styleFrom(foregroundColor: Colors.grey),
                      ),
                    ),
                  ),

                // 5. Totals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTotalRow('Subtotal', total),
                          if (_showExtraCharge) _buildTotalRow('Adjustments', _extraAmount),
                          const SizedBox(height: 12),
                          Container(height: 1, width: 200, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('TOTAL', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 40),
                              Text(
                                'PKR ${NumberFormat('#,###').format(finalTotal)}',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFC6A869),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                
                // 6. Footer
                Container(
                  color: const Color(0xFFF9F9F9),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text('Thank you for choosing Mama Events!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text('Please make checks payable to "Mama Events"', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('For questions, contact us at info@mamaevents.pk', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 100, child: Text(label, style: GoogleFonts.inter(color: Colors.grey[600]))),
          SizedBox(
            width: 120, 
            child: Text(
              'Rs ${NumberFormat('#,###').format(amount)}', 
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
