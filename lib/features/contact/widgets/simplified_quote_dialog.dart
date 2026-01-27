import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../admin/models/activity_log_model.dart';
import '../../../admin/services/activity_log_service.dart';
import '../../../providers/app_config_provider.dart';
import '../../../core/services/database_service.dart';
import '../../../config/theme/colors.dart';

class SimplifiedQuoteDialog extends StatefulWidget {
  const SimplifiedQuoteDialog({super.key});

  @override
  State<SimplifiedQuoteDialog> createState() => _SimplifiedQuoteDialogState();
}

class _SimplifiedQuoteDialogState extends State<SimplifiedQuoteDialog> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  final _guestCountController = TextEditingController(text: '4');
  
  int _guestCount = 4;
  final Set<String> _selectedServiceStyles = {};

  // Main category selection
  String? _selectedMainCategory;
  
  // Sub-category selections (multiple allowed)
  final Set<String> _selectedSubCategories = {};
  
  DateTime? _selectedDate;
  bool _isSubmitting = false;
  
  // Service categories data
  static const Map<String, List<String>> _serviceCategories = {
    'Wedding Events': ['Walima', 'Mehndi', 'Barat', 'Dholak'],
    'Corporate Events': ['Conferences & Seminars', 'Office Lunch', 'Product Launch'],
    'Birthday Parties': ['Kids Birthday', 'Adult Birthday'],
  };
  
  // Icons for main categories
  static const Map<String, IconData> _categoryIcons = {
    'Wedding Events': Icons.favorite,
    'Corporate Events': Icons.business,
    'Birthday Parties': Icons.cake,
  };

  @override
  void initState() {
    super.initState();
    _guestCountController.addListener(() {
      final val = int.tryParse(_guestCountController.text);
      if (val != null && val != _guestCount) {
        setState(() {
          _guestCount = val;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _additionalDetailsController.dispose();
    _guestCountController.dispose();
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
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryGold,
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

    if (_selectedMainCategory == null || _selectedSubCategories.isEmpty || _selectedDate == null || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly.'),
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
      final quoteId = 'QTE-PK-$timestamp';

      // Prepare quote data
      final orderData = {
        'quoteId': quoteId,
        'package_name': '$_selectedMainCategory (${_selectedSubCategories.join(", ")})',
        'status': 'pending',
        'guest_count': _guestCount,
        'event_date': _selectedDate!.millisecondsSinceEpoch,
        'user_details': {
           'name': _nameController.text.trim(),
           'phone': _phoneController.text.trim(),
           'email': _emailController.text.trim(),
           'location': _locationController.text.trim(),
        },
        'notes': _additionalDetailsController.text.trim(),
        'service_styles': _selectedServiceStyles.toList(),
        'source': 'simplified_dialog',
        'createdAt': ServerValue.timestamp,
      };

      // Save to RTDB
      await DatabaseService().submitQuote(orderData);

      await ActivityLogService().log(
        ActivityLog(
          logId: '',
          action: ActivityAction.quoteAccepted, 
          note: 'New quote request submitted via Simplified Dialog',
          entityType: 'quote',
          entityId: quoteId,
          entityName: _nameController.text.trim(),
          performedBy: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
          performedByName: _nameController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );

      // ✅ BUILD WHATSAPP MESSAGE
      final dateStr = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      
      String whatsappMessage = '''
🎉 *New Quote Request from MAMA EVENTS*

📋 *Quote ID:* $quoteId
━━━━━━━━━━━━━━━━━━━━

👤 *Customer Information:*
• Name: ${_nameController.text.trim()}
• Phone: ${_phoneController.text.trim()}
• Email: ${_emailController.text.trim().isEmpty ? 'N/A' : _emailController.text.trim()}
• Location: ${_locationController.text.trim()}

📅 *Event Details:*
• Date: $dateStr
• Guests: $_guestCount people
• Service Type: $_selectedMainCategory
• Sub-Categories: ${_selectedSubCategories.join(", ")}
• Service Styles: ${_selectedServiceStyles.isEmpty ? 'N/A' : _selectedServiceStyles.join(", ")}

📝 *Additional Notes:*
${_additionalDetailsController.text.trim().isEmpty ? 'None' : _additionalDetailsController.text.trim()}

━━━━━━━━━━━━━━━━━━━━
Please provide a detailed quote for this event.
Thank you! 🙏''';

      final whatsappUrl = Uri.parse(
        config.getWhatsAppLink(message: whatsappMessage),
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      }

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        Navigator.of(context).pop(); // Close Form Dialog
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryGold, size: 60),
            const SizedBox(height: 16),
            const Text('Thank You!'),
          ],
        ),
        content: Text(
          'Thanks for requesting a quote!\nMama Events will contact you within 24 hours to discuss your event in ${_locationController.text}.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepIndicator(),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          _buildStepTab('Service Details', 0),
          _buildStepTab('Your Info', 1),
          _buildStepTab('Preferences', 2),
        ],
      ),
    );
  }

  Widget _buildStepTab(String title, int index) {
    final isActive = _currentStep == index;
    final isCompleted = _currentStep > index;
    
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive 
                  ? AppColors.logoDeepBlack 
                  : (isCompleted ? AppColors.primaryGold : const Color(0xFF9E9E9E)),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            color: isActive 
                ? AppColors.logoDeepBlack 
                : (isCompleted ? AppColors.primaryGold : const Color(0xFFE0E0E0)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildServiceDetailsStep();
      case 1:
        return _buildYourInfoStep();
      case 2:
        return _buildPreferencesStep();
      default:
        return Container();
    }
  }

  Widget _buildServiceDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Your Event',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32, 
            fontWeight: FontWeight.bold, 
            color: AppColors.logoDeepBlack
          ),
        ),
        const SizedBox(height: 32),
        _buildLabel('Select Event Type', required: true),
        const SizedBox(height: 12),
        ..._serviceCategories.keys.map((category) => _buildMainCategoryCard(category)),
        const SizedBox(height: 32),
        _buildGuestCounter(),
        const SizedBox(height: 32),
        _buildLabel('Date of Service', required: true),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              border: Border.all(color: const Color(0xFFE0E0E0)), 
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_outlined, color: AppColors.primaryGold, size: 22),
                const SizedBox(width: 12),
                Text(
                  _selectedDate == null 
                    ? 'Select Date' 
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _selectedDate == null ? Colors.grey[600] : AppColors.logoDeepBlack,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.logoDeepBlack,
            letterSpacing: 0.5,
          ),
        ),
        if (required)
          Text(' *', style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGuestCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Number of Guests', required: true),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              _buildCounterBtn(
                icon: Icons.remove, 
                onTap: () {
                  if (_guestCount > 1) {
                    setState(() {
                      _guestCount--;
                      _guestCountController.text = _guestCount.toString();
                    });
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: _guestCountController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.logoDeepBlack,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              _buildCounterBtn(
                icon: Icons.add, 
                onTap: () {
                  setState(() {
                    _guestCount++;
                    _guestCountController.text = _guestCount.toString();
                  });
                },
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
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.primaryGold, size: 20),
        ),
      ),
    );
  }

  Widget _buildMainCategoryCard(String category) {
    final isSelected = _selectedMainCategory == category;
    final subCategories = _serviceCategories[category] ?? [];
    final icon = _categoryIcons[category] ?? Icons.category;
    Color categoryColor = AppColors.logoDeepBlack;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedMainCategory == category) {
            _selectedMainCategory = null;
            _selectedSubCategories.clear();
          } else {
            _selectedMainCategory = category;
            _selectedSubCategories.clear();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? categoryColor.withOpacity(0.08) : Colors.white,
          border: Border.all(color: isSelected ? categoryColor : const Color(0xFFE0E0E0), width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: categoryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: categoryColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      category,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? categoryColor : const Color(0xFF212121)),
                    ),
                  ),
                  Icon(isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: isSelected ? categoryColor : const Color(0xFF9E9E9E)),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: subCategories.map((subCategory) {
                    final isSubSelected = _selectedSubCategories.contains(subCategory);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSubSelected) _selectedSubCategories.remove(subCategory);
                          else _selectedSubCategories.add(subCategory);
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSubSelected ? categoryColor : Colors.white,
                          border: Border.all(color: isSubSelected ? categoryColor : const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subCategory,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: isSubSelected ? FontWeight.w600 : FontWeight.w500, color: isSubSelected ? Colors.white : const Color(0xFF424242)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildYourInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Information',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28, 
            fontWeight: FontWeight.bold, 
            color: AppColors.logoDeepBlack
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          controller: _nameController,
          label: 'Your Name',
          required: true,
          hint: 'Enter your full name',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _locationController,
          label: 'Add Location',
          required: true,
          hint: 'Area, City or Venue Name',
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          required: true,
          hint: 'e.g. 03001234567',
          keyboardType: TextInputType.phone,
          icon: Icons.phone_outlined,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Required';
            final regex = RegExp(r'^(\+92|03)[0-9]{9}$');
            if (!regex.hasMatch(value.replaceAll(' ', ''))) {
              return 'Enter valid PK number (03xx... or +92...)';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'Optional',
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
        ),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Preferences',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28, 
            fontWeight: FontWeight.bold, 
            color: AppColors.logoDeepBlack
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel('Preferred Service Styles'),
        const SizedBox(height: 12),
        _buildServiceStylesSelection(),
        const SizedBox(height: 24),
        _buildLabel('Additional Details'),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _additionalDetailsController,
          label: '',
          hint: 'Any special requests or details...',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildServiceStylesSelection() {
    final styles = ['Buffet', 'Breakfast', 'BBQ', 'Mix', 'Hogs Meal', 'Live Stations'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: styles.map((style) {
        final isSelected = _selectedServiceStyles.contains(style);
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) _selectedServiceStyles.remove(style);
              else _selectedServiceStyles.add(style);
            });
          },
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.logoDeepBlack : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.logoDeepBlack : const Color(0xFFE0E0E0),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              style,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF616161),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          _buildLabel(label, required: required),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 16, color: AppColors.logoDeepBlack),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
            prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryGold, size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
          validator: validator ?? (required ? (val) => (val == null || val.isEmpty) ? 'Required' : null : null),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'BACK',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: const Color(0xFF616161),
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : () {
                if (_currentStep == 0) {
                     if (_selectedMainCategory == null || _selectedSubCategories.isEmpty || _selectedDate == null) {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
                       return;
                     }
                }
                if (_currentStep == 1) {
                  if (!_formKey.currentState!.validate()) return;
                  if (_locationController.text.isEmpty) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a location')));
                     return;
                  }
                }
                
                if (_currentStep < 2) setState(() => _currentStep++);
                else _submitQuote();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.logoDeepBlack,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isSubmitting 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) 
                : Text(
                    _currentStep < 2 ? 'CONTINUE' : 'SUBMIT REQUEST',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w800, letterSpacing: 1),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
