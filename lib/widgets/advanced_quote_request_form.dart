import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_config_provider.dart';
import '../core/services/database_service.dart';
import '../config/theme/colors.dart';

/// Advanced Multi-Step Quote Request Form
/// Professional UX with step-by-step wizard
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
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Step 1: Service Details
  String? _selectedServiceType;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  String? _serviceFrequency;
  DateTime? _serviceDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Step 2: Your Info
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Step 3: Preferences
  String? _budgetRange;
  Set<String> _selectedServiceStyles = {};
  final TextEditingController _additionalDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.packageName != null) {
      // Auto-set the related service type or 'Other' if not exact match
      // For now just defaulting to relevant one if possible, or keeping it open
      // Actually, if we have a package name, we should probably display it distinctly
    }
    _guestsController.addListener(_updateEstimate);
  }

  void _updateEstimate() {
    setState(() {});
  }

  @override
  void dispose() {
    _guestsController.removeListener(_updateEstimate);
    _locationController.dispose();
    _guestsController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _additionalDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Content
                  if (_currentStep == 0) _buildServiceDetailsStep(),
                  if (_currentStep == 1) _buildYourInfoStep(),
                  if (_currentStep == 2) _buildPreferencesStep(),
                  
                  const SizedBox(height: 32),
                  
                  // Navigation
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailsStep() {
    final serviceTypes = [
      'Corporate Events',
      'Wedding Catering',
      'Office Catering',
      'Sandwich Catering',
      'Contract Catering',
      'Meal Prep',
      'F&B Manufacturing',
      'Other',
    ];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.packageName != null)
             Container(
               padding: const EdgeInsets.all(16),
               margin: const EdgeInsets.only(bottom: 24),
               decoration: BoxDecoration(
                 color: const Color(0xFFD4AF37).withOpacity(0.1),
                 border: Border.all(color: const Color(0xFFD4AF37)),
                 borderRadius: BorderRadius.circular(12),
               ),
               child: Row(
                 children: [
                   const Icon(Icons.star, color: Color(0xFFD4AF37)),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Text(
                       'Your Quote for: ${widget.packageName}',
                       style: GoogleFonts.inter(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color: const Color(0xFF212121),
                       ),
                     ),
                   ),
                 ],
               ),
             ),

          Text(
            'What do you need?',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 32),
          
          // Service Type
          _buildLabel('Service Type', required: true),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: serviceTypes.map((type) {
              final isSelected = _selectedServiceType == type;
              return InkWell(
                onTap: () => setState(() => _selectedServiceType = type),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 120) / 2,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF212121) : const Color(0xFFE0E0E0),
                      width: isSelected ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Event Location
          _buildLabel('Event Location', required: true),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _locationController,
            hint: 'Add Location (e.g. Model Town, Lahore)',
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          
          const SizedBox(height: 24),
          
          // Number of Guests + Live Estimate
          Row(
            crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom to match estimate box
            children: [
              Expanded(
                flex: 1,
                child: _buildPremiumGuestCounter(),
              ),
              if (widget.basePricePerHead != null && widget.basePricePerHead! > 0) ...[
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildLiveEstimate(),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Service Frequency
          _buildLabel('Service Frequency', required: true),
          const SizedBox(height: 12),
          Row(
            children: ['One-off', 'Multi-date', 'Ongoing'].map((freq) {
              final isSelected = _serviceFrequency == freq;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => setState(() => _serviceFrequency = freq),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF212121) : const Color(0xFFE0E0E0),
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        freq,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Date of First Service
          _buildLabel('Date of First Service', required: true),
          const SizedBox(height: 12),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.event_note, color: AppColors.primaryGold),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _serviceDate != null ? 'Event Date Selected' : 'Choose Event Date',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primaryGold.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _serviceDate != null
                            ? DateFormat('EEEE, d MMMM yyyy').format(_serviceDate!)
                            : 'Select preferred date',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _serviceDate != null ? AppColors.logoDeepBlack : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Service Times
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Service Start Time', required: true),
                    const SizedBox(height: 12),
                    _buildTimePicker(
                      value: _startTime,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
                        );
                        if (picked != null) setState(() => _startTime = picked);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Service End Time', required: true),
                    const SizedBox(height: 12),
                    _buildTimePicker(
                      value: _endTime,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _endTime ?? const TimeOfDay(hour: 17, minute: 0),
                        );
                        if (picked != null) setState(() => _endTime = picked);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveEstimate() {
    final guests = int.tryParse(_guestsController.text) ?? 0;
    if (guests <= 0) return const SizedBox.shrink();

    final basePrice = widget.basePricePerHead ?? 0;
    final subTotal = guests * basePrice;
    // Assuming 0% tax for now as per user previous logic "PKR taxes" - usually included or separate?
    // User asked for "standard common Pakistani catering standards". Usually prices are net, or tax is +16% GST.
    // I will add a small note "Exclusive of Taxes" or just show Subtotal.
    // Let's keep it simple: "Estimated Total".
    
    final formatter = NumberFormat('#,###', 'en_US');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.logoDeepBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
             color: AppColors.primaryGold.withOpacity(0.1),
             blurRadius: 15,
             offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_outlined, color: AppColors.primaryGold, size: 16),
              const SizedBox(width: 8),
              Text(
                'ESTIMATED TOTAL',
                style: GoogleFonts.inter(
                  color: AppColors.primaryGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'PKR ${formatter.format(subTotal)}',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '@ PKR ${formatter.format(basePrice)} / per guest',
              style: GoogleFonts.inter(
                color: AppColors.primaryGold,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your contact details',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 32),
        
        _buildLabel('Your Name', required: true),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _nameController,
          hint: 'John Smith',
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        
        const SizedBox(height: 24),
        
        _buildLabel('Email Address', required: true),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _emailController,
          hint: 'john@example.com',
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (!v!.contains('@')) return 'Invalid email';
            return null;
          },
        ),
        
        const SizedBox(height: 24),
        
        _buildLabel('Phone Number', required: true),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          hint: '0300 1234567 or +92 300...',
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            // Allow +92 or 03 followed by 9 digits (approx) - basic loose validation or strict
            final clean = v!.replaceAll(RegExp(r'[\s-]'), '');
            if (!RegExp(r'^((\+92)|(92)|(0092)|(0))?3[0-9]{9}$').hasMatch(clean)) {
              return 'Enter valid PK number (e.g. 03001234567)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPremiumGuestCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Number of Guests', required: true),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              // Minus Button
              _buildCounterBtn(
                icon: Icons.remove, 
                onTap: () {
                  final current = int.tryParse(_guestsController.text) ?? 0;
                  if (current > 0) {
                    _guestsController.text = (current - 1).toString();
                  }
                }
              ),
              
              // Text Field
              Expanded(
                child: TextFormField(
                  controller: _guestsController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.logoDeepBlack,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              
              // Plus Button
              _buildCounterBtn(
                icon: Icons.add, 
                onTap: () {
                  final current = int.tryParse(_guestsController.text) ?? 0;
                  _guestsController.text = (current + 1).toString();
                }
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterBtn({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: AppColors.primaryGold, size: 20),
        ),
      ),
    );
  }

  Widget _buildPreferencesStep() {
    // Get current region from provider to show correct currency
    final config = context.watch<AppConfigProvider>().config;
    final currency = 'PKR';
    final multiplier = 1;
    
    final budgetRanges = [
      '< ${5000 * multiplier} $currency',
      '${5000 * multiplier}K - ${10000 * multiplier}K $currency',
      '${10000 * multiplier}K - ${25000 * multiplier}K $currency',
      '${25000 * multiplier}K+ $currency',
    ];
    final serviceStyles = [
      'Buffet', 'Breakfast', 'BBQ', 'Mix', 'Hogs Meal', 'Live Stations',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us your preferences',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 32),
        
        _buildLabel('Budget Range (Optional)'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: budgetRanges.map((budget) {
            final isSelected = _budgetRange == budget;
            return InkWell(
              onTap: () => setState(() => _budgetRange = budget),
              child: Container(
                width: (MediaQuery.of(context).size.width - 120) / 2,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF212121) : const Color(0xFFE0E0E0),
                    width: isSelected ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  budget,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 32),
        
        _buildLabel('Preferred Service Styles (Select all that apply)'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: serviceStyles.map((style) {
            final isSelected = _selectedServiceStyles.contains(style);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedServiceStyles.remove(style);
                  } else {
                    _selectedServiceStyles.add(style);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF212121) : const Color(0xFFE0E0E0),
                    width: isSelected ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  style,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 32),
        
        _buildLabel('Additional Details'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _additionalDetailsController,
          hint: 'Any special requests or additional information...',
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildTimePicker({TimeOfDay? value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null ? value.format(context) : '--:-- --',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: value != null ? const Color(0xFF212121) : const Color(0xFF9E9E9E),
              ),
            ),
            const Icon(Icons.access_time, color: Color(0xFF616161)),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF212121),
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF9E9E9E),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF212121), width: 2),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back, color: Color(0xFF616161)),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        if (_currentStep > 0) const SizedBox(width: 16),
        
        Expanded(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF212121),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == 2 ? 'Get Your Free Quote' : 'Continue',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleContinue() async {
    if (_currentStep < 2) {
      // Validate current step
      if (_currentStep == 0) {
        if (_selectedServiceType == null ||
            _locationController.text.isEmpty ||
            _guestsController.text.isEmpty ||
            _serviceFrequency == null ||
            _serviceDate == null ||
            _startTime == null ||
            _endTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill all required fields')),
          );
          return;
        }
      } else if (_currentStep == 1) {
        // Validate Step 2: Your Info
        if (_nameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your name')),
          );
          return;
        }
        if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid email address')),
          );
          return;
        }
        if (_phoneController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your phone number')),
          );
          return;
        }
      }
      
      setState(() => _currentStep++);
    } else {
      // Submit form
      await _submitQuote();
    }
  }

  Future<void> _submitQuote() async {
    setState(() => _isSubmitting = true);

    try {
      final config = context.read<AppConfigProvider>().config;
      final quoteId = 'ADV-${config.region.code}-${DateTime.now().millisecondsSinceEpoch}';

      // Calculate final Estimate to save
      double estimatedTotal = 0;
      double basePrice = widget.basePricePerHead ?? 0;
      int guests = int.tryParse(_guestsController.text) ?? 0;
      if (basePrice > 0 && guests > 0) {
        estimatedTotal = basePrice * guests;
      }

      await DatabaseService().submitQuote({
        'quoteId': quoteId,
        'serviceType': _selectedServiceType,
        'packageName': widget.packageName, // Save package name if linked
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
        
        // 💰 Financials
        'basePricePerHead': basePrice,
        'estimatedTotal': estimatedTotal,
        'currency': 'PKR',
        
        'createdAt': ServerValue.timestamp,
      });

      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting quote: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

}
