import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_config_provider.dart';
import '../core/services/database_service.dart';
import '../config/theme/colors.dart';

/// Advanced Multi-Step Quote Request Form
/// REFACTORED: Single View, Responsive (2-Column Desktop), Compact
class AdvancedQuoteRequestForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  final String? packageName;
  final double? basePricePerHead;

  const AdvancedQuoteRequestForm({
    super.key, 
    this.onSuccess,
    this.packageName,
    this.basePricePerHead,
  });

  @override
  State<AdvancedQuoteRequestForm> createState() => _AdvancedQuoteRequestFormState();
}

class _AdvancedQuoteRequestFormState extends State<AdvancedQuoteRequestForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // -- Event Details --
  String? _selectedServiceType;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  String? _serviceFrequency;
  DateTime? _serviceDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // -- Contact Info --
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // -- Preferences --
  String? _budgetRange;
  final Set<String> _selectedServiceStyles = {};
  final TextEditingController _additionalDetailsController = TextEditingController();

  // Dropdown Options
  final List<String> _serviceTypes = [
    'Corporate Events', 'Wedding Catering', 'Office Catering', 
    'Sandwich Catering', 'Contract Catering', 'Meal Prep', 
    'F&B Manufacturing', 'Other'
  ];
  
  final List<String> _frequencies = ['One-off', 'Multi-date', 'Ongoing'];
  
  final List<String> _budgetRanges = [
    '< 5000 PKR', '5K - 10K PKR', '10K - 25K PKR', '25K+ PKR'
  ];

  final List<String> _serviceStyles = [
    'Buffet', 'Breakfast', 'BBQ', 'Mix', 'Hogs Meal', 'Live Stations'
  ];

  @override
  void initState() {
    super.initState();
    _guestsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _guestsController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _additionalDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive Breakpoint
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Request a Quote', 
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold, 
            color: const Color(0xFFD4AF37)
          )
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 40 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dynamic Layout based on screen size
              if (isDesktop)
                IntrinsicHeight( // Ensures equal height columns if needed
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT COLUMN: Event Details
                      Expanded(
                        child: _buildSection(
                          title: 'Event Details',
                          icon: Icons.event,
                          children: _buildEventFields(),
                        ),
                      ),
                      
                      const SizedBox(width: 40),
                      
                      // VERTICAL DIVIDER
                      Container(
                        width: 1,
                        color: Colors.grey[200],
                      ),
                      
                      const SizedBox(width: 40),

                      // RIGHT COLUMN: Contact & Preferences
                      Expanded(
                        child: Column(
                          children: [
                            _buildSection(
                              title: 'Your Information',
                              icon: Icons.person,
                              children: _buildContactFields(),
                            ),
                            const SizedBox(height: 32),
                            _buildSection(
                              title: 'Preferences',
                              icon: Icons.tune,
                              children: _buildPreferenceFields(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                     _buildSection(
                        title: 'Event Details',
                        icon: Icons.event,
                        children: _buildEventFields(),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),
                      _buildSection(
                        title: 'Your Information',
                        icon: Icons.person,
                        children: _buildContactFields(),
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        title: 'Preferences',
                        icon: Icons.tune,
                        children: _buildPreferenceFields(),
                      ),
                  ],
                ),

              const SizedBox(height: 40),
              
              // Bottom Action
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryGold, size: 20),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.logoDeepBlack,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }

  // --- Field Groups ---

  List<Widget> _buildEventFields() {
    return [
      if (widget.packageName != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
            ),
            child: Row(
               children: [
                 const Icon(Icons.star, size: 16, color: AppColors.primaryGold),
                 const SizedBox(width: 8),
                 Expanded(
                   child: Text(
                     'Package: ${widget.packageName}',
                     style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.logoDeepBlack),
                   ),
                 ),
               ],
            ),
          ),
        ),

      _buildDropdown(
        label: 'Service Type',
        value: _selectedServiceType,
        items: _serviceTypes,
        onChanged: (val) => setState(() => _selectedServiceType = val),
        required: true,
      ),
      const SizedBox(height: 16),
      
      _buildTextField(
        controller: _locationController,
        label: 'Event Location',
        hint: 'e.g. Model Town, Lahore',
        required: true,
      ),
      const SizedBox(height: 16),
      
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _guestsController,
              label: 'Guests',
              hint: '0',
              keyboardType: TextInputType.number,
              required: true,
            ),
          ),
          const SizedBox(width: 16),
           Expanded(
            child: _buildDropdown(
              label: 'Frequency',
              value: _serviceFrequency,
              items: _frequencies,
              onChanged: (val) => setState(() => _serviceFrequency = val),
              required: true,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      _buildDatePicker(),
      const SizedBox(height: 16),
      
      Row(
        children: [
          Expanded(child: _buildTimePicker(label: 'Start Time', value: _startTime, onChanged: (t) => setState(() => _startTime = t))),
          const SizedBox(width: 16),
          Expanded(child: _buildTimePicker(label: 'End Time', value: _endTime, onChanged: (t) => setState(() => _endTime = t))),
        ],
      ),

      // Live Estimate for Desktop mostly
      if (widget.basePricePerHead != null) ...[
         const SizedBox(height: 24),
         _buildEstimateCard(),
      ],
    ];
  }

  List<Widget> _buildContactFields() {
    return [
      _buildTextField(
        controller: _nameController,
        label: 'Full Name',
        hint: 'John Doe',
        required: true,
      ),
      const SizedBox(height: 16),
      
      _buildTextField(
        controller: _emailController,
        label: 'Email Address',
        hint: 'john@example.com',
        keyboardType: TextInputType.emailAddress,
        required: true,
        validator: (v) => (v != null && !v.contains('@')) ? 'Invalid email' : null,
      ),
      const SizedBox(height: 16),
      
      _buildTextField(
        controller: _phoneController,
        label: 'Phone Number',
        hint: '0300 1234567',
        keyboardType: TextInputType.phone,
        required: true,
      ),
    ];
  }

  List<Widget> _buildPreferenceFields() {
    return [
      _buildDropdown(
        label: 'Budget Range',
        value: _budgetRange,
        items: _budgetRanges,
        onChanged: (val) => setState(() => _budgetRange = val),
      ),
      const SizedBox(height: 16),
      
      Text('Service Styles', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _serviceStyles.map((style) {
          final isSelected = _selectedServiceStyles.contains(style);
          return FilterChip(
            label: Text(style),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) _selectedServiceStyles.add(style);
                else _selectedServiceStyles.remove(style);
              });
            },
            selectedColor: AppColors.primaryGold.withOpacity(0.2),
            checkmarkColor: AppColors.primaryGold,
            labelStyle: GoogleFonts.inter(
              color: isSelected ? AppColors.logoDeepBlack : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: isSelected ? AppColors.primaryGold : Colors.grey[300]!),
            ),
          );
        }).toList(),
      ),
      
      const SizedBox(height: 16),
       _buildTextField(
        controller: _additionalDetailsController,
        label: 'Additional Notes',
        hint: 'Any special requests...',
        maxLines: 3,
      ),
    ];
  }

  // --- Widgets ---

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: _inputDecoration(hint),
          validator: (v) {
             if (required && (v == null || v.isEmpty)) return 'Required';
             if (validator != null) return validator(v);
             return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required),
         const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: GoogleFonts.inter(fontSize: 14)),
          )).toList(),
          onChanged: onChanged,
          decoration: _inputDecoration('Select'),
          validator: (v) => required && v == null ? 'Required' : null,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Date', true),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _serviceDate ?? DateTime.now().add(const Duration(days: 7)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _serviceDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50], // Very light background
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(
                  _serviceDate != null ? DateFormat('EEE, d MMM yyyy').format(_serviceDate!) : 'Select Date',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: _serviceDate != null ? Colors.black : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({required String label, required TimeOfDay? value, required Function(TimeOfDay) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, true),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: value ?? const TimeOfDay(hour: 12, minute: 0),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Text(
                  value != null ? value.format(context) : '--:--',
                  style: GoogleFonts.inter(
                     fontSize: 14,
                     color: value != null ? Colors.black : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstimateCard() {
    final guests = int.tryParse(_guestsController.text) ?? 0;
    if (guests <= 0) return const SizedBox.shrink();
    
    final total = guests * (widget.basePricePerHead ?? 0);
    final formatter = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.logoDeepBlack,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryGold),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ESTIMATE',
            style: GoogleFonts.inter(color: AppColors.primaryGold, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'PKR ${formatter.format(total)}',
            style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitQuote,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.logoDeepBlack,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isSubmitting 
           ? const CircularProgressIndicator(color: Colors.white)
           : Text('GET FREE QUOTE', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  Widget _buildLabel(String text, bool required) {
    return RichText(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800]),
        children: required ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red[700]))] : [],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), // Denser
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.logoDeepBlack)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  // --- Logic ---

  Future<void> _submitQuote() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }
    
    // Additional validation
    if (_serviceDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select date and time')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final config = context.read<AppConfigProvider>().config;
      final quoteId = 'ADV-${config.region.code}-${DateTime.now().millisecondsSinceEpoch}';

      double estimatedTotal = 0;
      double basePrice = widget.basePricePerHead ?? 0;
      int guests = int.tryParse(_guestsController.text) ?? 0;
      if (basePrice > 0 && guests > 0) estimatedTotal = basePrice * guests;

      await DatabaseService().submitQuote({
        'quoteId': quoteId,
        'serviceType': _selectedServiceType,
        'packageName': widget.packageName,
        'eventLocation': _locationController.text,
        'guestCount': guests,
        'serviceFrequency': _serviceFrequency,
        'serviceDate': _serviceDate!.millisecondsSinceEpoch,
        'startTime': '${_startTime!.hour}:${_startTime!.minute}',
        'endTime': '${_endTime!.hour}:${_endTime!.minute}',
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'budgetRange': _budgetRange,
        'serviceStyles': _selectedServiceStyles.toList(),
        'additionalDetails': _additionalDetailsController.text,
        'region': config.region.code,
        'status': 'pending',
        'basePricePerHead': basePrice,
        'estimatedTotal': estimatedTotal,
        'currency': 'PKR',
        'createdAt': ServerValue.timestamp,
      });

      // --- WhatsApp Integration ---
      final whatsappUrl = config.region.getWhatsAppLink(
        message: '''
*New Quote Request* 📋
Name: ${_nameController.text}
Phone: ${_phoneController.text}
Event: $_selectedServiceType
Guests: $guests
Date: ${DateFormat('dd MMM yyyy').format(_serviceDate!)}
Time: ${_startTime!.format(context)} - ${_endTime!.format(context)}
Location: ${_locationController.text}
Budget: $_budgetRange
Package: ${widget.packageName ?? 'Custom'}
Notes: ${_additionalDetailsController.text}
'''
      );

      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      // ----------------------------

      if (widget.onSuccess != null) widget.onSuccess!();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
