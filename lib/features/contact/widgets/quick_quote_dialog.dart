import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/menu_item.dart';
import '../../../providers/app_config_provider.dart';
import '../../../core/services/database_service.dart';

class QuickQuoteDialog extends StatefulWidget {
  final MenuItem? preSelectedItem;

  const QuickQuoteDialog({
    super.key,
    this.preSelectedItem,
  });

  @override
  State<QuickQuoteDialog> createState() => _QuickQuoteDialogState();
}

class _QuickQuoteDialogState extends State<QuickQuoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _guestCountController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  bool _isSubmitting = false;
  bool _submitted = false;
  String? _quoteId;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _guestCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1B5E20),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitQuote() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an event date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final config = context.read<AppConfigProvider>().config;
      
      // Generate quote ID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final quoteId = 'QTE-${config.region.code}-$timestamp';

      // Prepare quote data
      final quoteData = {
        'quoteId': quoteId,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
        'guestCount': int.tryParse(_guestCountController.text.trim()) ?? 0,
        'eventDate': Timestamp.fromDate(_selectedDate!),
        'region': config.region.code,
        'regionName': config.region.name,
        'menuItem': widget.preSelectedItem != null
            ? {
                'id': widget.preSelectedItem!.id,
                'name': widget.preSelectedItem!.name,
                'category': widget.preSelectedItem!.category,
                'price': widget.preSelectedItem!.getPrice(config.region),
              }
            : null,
        'notes': _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'menu_quick_quote',
      };

      // Submit to RTDB
      await DatabaseService().submitQuote(quoteData);

      // ✅ BUILD WHATSAPP MESSAGE WITH ALL QUOTE DETAILS
      final dateStr = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      
      String whatsappMessage = '''
🎉 *New Quote Request from MAMA EVENTS*

📋 *Quote ID:* $quoteId
━━━━━━━━━━━━━━━━━━━━

👤 *Customer Information:*
• Name: ${_nameController.text.trim()}
• Phone: ${_phoneController.text.trim()}''';

      if (_emailController.text.trim().isNotEmpty) {
        whatsappMessage += '\n• Email: ${_emailController.text.trim()}';
      }

      whatsappMessage += '''

📅 *Event Details:*
• Date: $dateStr
• Guests: ${_guestCountController.text.trim()} people
• Region: ${config.region.name} ${config.region.flag}''';

      if (widget.preSelectedItem != null) {
        whatsappMessage += '''

🍽️ *Selected Menu:*
• ${widget.preSelectedItem!.name}
• Price: ${widget.preSelectedItem!.getFormattedPrice(config.region)}''';
      }

      if (_notesController.text.trim().isNotEmpty) {
        whatsappMessage += '''

📝 *Additional Notes:*
${_notesController.text.trim()}''';
      }

      whatsappMessage += '''

━━━━━━━━━━━━━━━━━━━━
Please provide a detailed quote for this event.
Thank you! 🙏''';

      // ✅ IMMEDIATELY OPEN WHATSAPP WITH THE QUOTE DATA
      final whatsappUrl = Uri.parse(
        config.getWhatsAppLink(message: whatsappMessage),
      );

      // Debug: Print the WhatsApp details
      debugPrint('🔍 Region: ${config.region.name}');
      debugPrint('📱 WhatsApp Number: ${config.region.whatsappNumber}');
      debugPrint('🔗 WhatsApp URL: $whatsappUrl');

      // Import url_launcher at the top if not already imported
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('❌ Cannot launch WhatsApp URL');
      }

      setState(() {
        _isSubmitting = false;
      });

      // Close the dialog after opening WhatsApp
      if (mounted) {
        Navigator.of(context).pop();
        
        // Show brief success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quote sent to WhatsApp! Reference: $quoteId'),
            backgroundColor: const Color(0xFF1B5E20),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting quote: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: _submitted ? _buildSuccessView(config) : _buildFormView(config),
      ),
    );
  }

  Widget _buildFormView(config) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GET A QUOTE',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B5E20),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Quick Quote Request',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Pre-selected item (if any)
              if (widget.preSelectedItem != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.restaurant, color: Color(0xFF1B5E20), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.preSelectedItem!.name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.preSelectedItem!.getFormattedPrice(config.region),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF1B5E20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Your full name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: config.region.isPakistan ? '+92 300 1234567' : '+971 50 1234567',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field (Optional)
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  hintText: 'your@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Guest Count
              TextFormField(
                controller: _guestCountController,
                decoration: InputDecoration(
                  labelText: 'Number of Guests *',
                  hintText: 'e.g., 50',
                  prefixIcon: const Icon(Icons.group_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Guest count is required';
                  }
                  final count = int.tryParse(value.trim());
                  if (count == null || count <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Event Date
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Color(0xFF616161)),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Select Event Date *'
                            : 'Event Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: _selectedDate == null
                              ? const Color(0xFF9E9E9E)
                              : const Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes (Optional)
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  hintText: 'Any special requirements or preferences...',
                  prefixIcon: const Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'SUBMIT QUOTE REQUEST',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(config) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF1B5E20),
              size: 50,
            ),
          ),
          const SizedBox(height: 24),
          
          // Success Message
          Text(
            'Quote Request Received!',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Quote ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'Reference Number',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _quoteId ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B5E20),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Info Text
          Text(
            'We\'ll review your request and get back to you within 24 hours with a detailed quote.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF616161),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final whatsappUrl = Uri.parse(
                      config.getWhatsAppLink(
                        message: 'Hi! I just submitted a quote request (${_quoteId}). Can you help me with more details?',
                      ),
                    );
                    Navigator.of(context).pop();
                    // In production: await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF25D366),
                    side: const BorderSide(color: Color(0xFF25D366), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.chat),
                  label: const Text('WHATSAPP US'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('CLOSE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
