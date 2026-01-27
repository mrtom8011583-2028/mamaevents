import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_config_provider.dart';

/// Premium Multi-Step Quote Request Form
/// Luxury Gold Theme - Converts visitors into qualified leads
class QuoteRequestForm extends StatefulWidget {
  const QuoteRequestForm({super.key});

  @override
  State<QuoteRequestForm> createState() => _QuoteRequestFormState();
}

class _QuoteRequestFormState extends State<QuoteRequestForm>
    with TickerProviderStateMixin {
  
  // ═══════════════════════════════════════════════════════════════════════════
  // 🎨 LUXURY GOLD COLOR PALETTE
  // ═══════════════════════════════════════════════════════════════════════════
  static const Color primaryGold = Color(0xFFD4AF37);      // Royal Gold
  static const Color darkGold = Color(0xFF9E7C2F);         // Dark Gold Accent
  static const Color softGold = Color(0xFFE8D8A8);         // Soft Gold Highlight
  static const Color champagneGold = Color(0xFFC9A24D);    // Champagne Gold
  static const Color deepGold = Color(0xFF8B6914);         // Deep Gold
  static const Color luxuryBlack = Color(0xFF1A1A1A);      // Luxury Black
  static const Color warmGray = Color(0xFF6B6B6B);         // Warm Gray
  static const Color creamWhite = Color(0xFFFAF8F5);       // Cream White
  
  // Current step (0-3)
  int _currentStep = 0;
  
  // Form keys for each step
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  
  // Animation controller
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _successController;
  
  // Form data
  String? _selectedEventType;
  DateTime? _eventDate;
  TimeOfDay? _eventTime;
  int _guestCount = 50;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _company = '';
  String _additionalNotes = '';
  List<String> _selectedMenuPreferences = [];
  String _budgetRange = '';
  bool _needsVenue = false;
  bool _needsDecor = false;
  bool _needsPhotography = false;
  
  // Submission state
  bool _isSubmitting = false;
  bool _isSuccess = false;

  // Event types with luxury styling
  final List<Map<String, dynamic>> _eventTypes = [
    {'id': 'wedding', 'name': 'Wedding', 'icon': Icons.favorite, 'color': const Color(0xFFD4AF37)},
    {'id': 'walima', 'name': 'Walima', 'icon': Icons.celebration, 'color': const Color(0xFFC9A24D)},
    {'id': 'corporate', 'name': 'Corporate Event', 'icon': Icons.business, 'color': const Color(0xFF9E7C2F)},
    {'id': 'birthday', 'name': 'Birthday Party', 'icon': Icons.cake, 'color': const Color(0xFFD4AF37)},
    {'id': 'mehndi', 'name': 'Mehndi', 'icon': Icons.palette, 'color': const Color(0xFFC9A24D)},
    {'id': 'engagement', 'name': 'Engagement', 'icon': Icons.diamond, 'color': const Color(0xFFD4AF37)},
    {'id': 'conference', 'name': 'Conference', 'icon': Icons.groups, 'color': const Color(0xFF9E7C2F)},
    {'id': 'other', 'name': 'Other', 'icon': Icons.more_horiz, 'color': const Color(0xFFC9A24D)},
  ];

  // Menu preferences
  final List<Map<String, dynamic>> _menuOptions = [
    {'id': 'pakistani', 'name': 'Pakistani Cuisine', 'icon': '🍛'},
    {'id': 'arabic', 'name': 'Arabic/Middle Eastern', 'icon': '🥙'},
    {'id': 'continental', 'name': 'Continental', 'icon': '🍝'},
    {'id': 'chinese', 'name': 'Chinese/Asian', 'icon': '🥢'},
    {'id': 'bbq', 'name': 'Live BBQ Station', 'icon': '🍖'},
    {'id': 'seafood', 'name': 'Seafood', 'icon': '🦐'},
    {'id': 'desserts', 'name': 'Desserts & Sweets', 'icon': '🍰'},
    {'id': 'beverages', 'name': 'Beverages', 'icon': '🥤'},
  ];

  // Budget ranges
  final List<String> _budgetRanges = [
    'Under 50,000',
    '50,000 - 100,000',
    '100,000 - 250,000',
    '250,000 - 500,000',
    '500,000+',
    'Flexible / Discuss',
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedEventType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an event type', style: GoogleFonts.inter()),
          backgroundColor: darkGold,
        ),
      );
      return;
    }
    
    if (_formKeys[_currentStep].currentState?.validate() ?? true) {
      _formKeys[_currentStep].currentState?.save();
      
      if (_currentStep < 3) {
        setState(() {
          _currentStep++;
        });
        _animateSlide();
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _animateSlide(reverse: true);
    }
  }

  void _animateSlide({bool reverse = false}) {
    _slideController.reset();
    _slideAnimation = Tween<Offset>(
      begin: Offset(reverse ? -1 : 1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  Future<void> _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _isSuccess = true;
    });
    
    _successController.forward();
  }

  void _sendWhatsAppQuote() {
    final config = context.read<AppConfigProvider>().config;
    final dateStr = _eventDate != null 
        ? DateFormat('MMM d, yyyy').format(_eventDate!)
        : 'TBD';
    final timeStr = _eventTime != null 
        ? _eventTime!.format(context)
        : 'TBD';
    
    final message = '''
✨ *Luxury Quote Request*

📋 *Event Details*
• Type: $_selectedEventType
• Date: $dateStr
• Time: $timeStr
• Guests: $_guestCount

👤 *Contact*
• Name: $_name
• Email: $_email
• Phone: $_phone
${_company.isNotEmpty ? '• Company: $_company' : ''}

🍽️ *Menu Preferences*
${_selectedMenuPreferences.join(', ')}

💰 *Budget*: $_budgetRange

📝 *Notes*: ${_additionalNotes.isNotEmpty ? _additionalNotes : 'None'}

*Additional Services*:
${_needsVenue ? '✓ Venue Required\n' : ''}${_needsDecor ? '✓ Decor Required\n' : ''}${_needsPhotography ? '✓ Photography Required' : ''}
''';

    final whatsappUrl = config.getWhatsAppLink(message: message);
    launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _isSuccess = false;
      _selectedEventType = null;
      _eventDate = null;
      _eventTime = null;
      _guestCount = 50;
      _name = '';
      _email = '';
      _phone = '';
      _company = '';
      _additionalNotes = '';
      _selectedMenuPreferences = [];
      _budgetRange = '';
      _needsVenue = false;
      _needsDecor = false;
      _needsPhotography = false;
    });
    _successController.reset();
    _animateSlide();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    if (_isSuccess) {
      return _buildSuccessState(isMobile);
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Indicator
          _buildProgressIndicator(isMobile),
          const SizedBox(height: 32),
          
          // Step Title
          _buildStepTitle(),
          const SizedBox(height: 24),
          
          // Form Content
          SlideTransition(
            position: _slideAnimation,
            child: _buildStepContent(),
          ),
          const SizedBox(height: 32),
          
          // Navigation Buttons
          _buildNavigationButtons(isMobile),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isMobile) {
    final steps = ['Event', 'Details', 'Contact', 'Menu'];
    
    return Row(
      children: List.generate(4, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;
        
        return Expanded(
          child: Row(
            children: [
              // Step Circle with luxury gold styling
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isActive || isCompleted
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isActive 
                              ? [primaryGold, champagneGold]
                              : [darkGold, deepGold],
                        )
                      : null,
                  color: isActive || isCompleted ? null : const Color(0xFFE8E8E8),
                  shape: BoxShape.circle,
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: primaryGold.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                  border: isActive ? Border.all(
                    color: softGold,
                    width: 2,
                  ) : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.inter(
                            color: isActive ? Colors.white : warmGray,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              
              // Connector Line
              if (index < 3)
                Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: isCompleted 
                          ? const LinearGradient(
                              colors: [darkGold, champagneGold],
                            )
                          : null,
                      color: isCompleted ? null : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepTitle() {
    final titles = [
      'What type of event are you planning?',
      'When is your event?',
      'How can we reach you?',
      'Tell us about your preferences',
    ];
    final subtitles = [
      'Select the event type that best describes your occasion',
      'Let us know the date and expected number of guests',
      'We\'ll get back to you within 24 hours',
      'Help us customize the perfect menu for you',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titles[_currentStep],
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: luxuryBlack,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryGold, champagneGold],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                subtitles[_currentStep],
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: warmGray,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildEventTypeStep();
      case 1:
        return _buildDateGuestsStep();
      case 2:
        return _buildContactStep();
      case 3:
        return _buildPreferencesStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEventTypeStep() {
    return Form(
      key: _formKeys[0],
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: _eventTypes.map((event) {
          final isSelected = _selectedEventType == event['name'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEventType = event['name'];
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 155,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected ? creamWhite : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? primaryGold : const Color(0xFFE8E8E8),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: primaryGold.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ] : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon with gradient background
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: isSelected 
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [primaryGold, champagneGold],
                              )
                            : null,
                        color: isSelected ? null : softGold.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        event['icon'] as IconData,
                        color: isSelected ? Colors.white : darkGold,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      event['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? darkGold : luxuryBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: primaryGold,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Selected',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateGuestsStep() {
    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Picker
          _buildLuxuryLabel('Event Date'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _eventDate ?? DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primaryGold,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: luxuryBlack,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                setState(() {
                  _eventDate = date;
                });
              }
            },
            child: _buildLuxuryInputContainer(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: softGold.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.calendar_today, color: darkGold, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    _eventDate != null 
                        ? DateFormat('EEEE, MMMM d, yyyy').format(_eventDate!)
                        : 'Select your event date',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: _eventDate != null ? luxuryBlack : warmGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Time Picker
          _buildLuxuryLabel('Event Time'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _eventTime ?? const TimeOfDay(hour: 19, minute: 0),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primaryGold,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: luxuryBlack,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (time != null) {
                setState(() {
                  _eventTime = time;
                });
              }
            },
            child: _buildLuxuryInputContainer(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: softGold.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.access_time, color: darkGold, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    _eventTime != null 
                        ? _eventTime!.format(context)
                        : 'Select preferred time',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: _eventTime != null ? luxuryBlack : warmGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Guest Count Slider
          _buildLuxuryLabel('Number of Guests'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: creamWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: softGold.withOpacity(0.5)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryGold, champagneGold],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.people, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$_guestCount',
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: darkGold,
                      ),
                    ),
                    Text(
                      ' guests',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: warmGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: primaryGold,
                    inactiveTrackColor: softGold,
                    thumbColor: primaryGold,
                    overlayColor: primaryGold.withOpacity(0.2),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                  ),
                  child: Slider(
                    value: _guestCount.toDouble(),
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    onChanged: (value) {
                      setState(() {
                        _guestCount = value.round();
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10', style: GoogleFonts.inter(color: warmGray, fontSize: 12)),
                    Text('1000+', style: GoogleFonts.inter(color: warmGray, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep() {
    return Form(
      key: _formKeys[2],
      child: Column(
        children: [
          _buildLuxuryTextField(
            label: 'Full Name',
            icon: Icons.person_outline,
            isRequired: true,
            onSaved: (value) => _name = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          _buildLuxuryTextField(
            label: 'Email Address',
            icon: Icons.email_outlined,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _email = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          _buildLuxuryTextField(
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            isRequired: true,
            keyboardType: TextInputType.phone,
            onSaved: (value) => _phone = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          _buildLuxuryTextField(
            label: 'Company Name',
            icon: Icons.business_outlined,
            isRequired: false,
            onSaved: (value) => _company = value ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryGold, champagneGold],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: luxuryBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildLuxuryInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLuxuryTextField({
    required String label,
    required IconData icon,
    required bool isRequired,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: GoogleFonts.inter(color: warmGray),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: softGold.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: darkGold, size: 20),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE57373)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      style: GoogleFonts.inter(fontSize: 15, color: luxuryBlack),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildPreferencesStep() {
    return Form(
      key: _formKeys[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu Options
          _buildLuxuryLabel('Cuisine Preferences'),
          const SizedBox(height: 4),
          Text(
            'Select all that apply',
            style: GoogleFonts.inter(fontSize: 12, color: warmGray),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _menuOptions.map((option) {
              final isSelected = _selectedMenuPreferences.contains(option['name']);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedMenuPreferences.remove(option['name']);
                    } else {
                      _selectedMenuPreferences.add(option['name'] as String);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected 
                        ? LinearGradient(colors: [primaryGold, champagneGold])
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? primaryGold : const Color(0xFFE0E0E0),
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: primaryGold.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(option['icon'] as String, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        option['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : luxuryBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          
          // Budget Range
          _buildLuxuryLabel('Budget Range'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _budgetRange.isEmpty ? null : _budgetRange,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: softGold.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.attach_money, color: darkGold, size: 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primaryGold, width: 2),
              ),
            ),
            hint: Text('Select your budget range', style: GoogleFonts.inter(color: warmGray)),
            items: _budgetRanges.map((range) {
              return DropdownMenuItem(
                value: range,
                child: Text(range, style: GoogleFonts.inter()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _budgetRange = value ?? '';
              });
            },
          ),
          const SizedBox(height: 28),
          
          // Additional Services
          _buildLuxuryLabel('Additional Services'),
          const SizedBox(height: 12),
          _buildLuxuryCheckbox('Venue arrangement needed', _needsVenue, (v) => setState(() => _needsVenue = v!)),
          _buildLuxuryCheckbox('Decor & flowers needed', _needsDecor, (v) => setState(() => _needsDecor = v!)),
          _buildLuxuryCheckbox('Photography/videography needed', _needsPhotography, (v) => setState(() => _needsPhotography = v!)),
          const SizedBox(height: 24),
          
          // Additional Notes
          _buildLuxuryLabel('Additional Notes'),
          const SizedBox(height: 8),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requirements, dietary restrictions, or questions...',
              hintStyle: GoogleFonts.inter(color: warmGray, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: primaryGold, width: 2),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 14, color: luxuryBlack),
            onChanged: (value) => _additionalNotes = value,
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryCheckbox(String label, bool value, void Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  gradient: value 
                      ? const LinearGradient(colors: [primaryGold, champagneGold])
                      : null,
                  color: value ? null : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: value ? primaryGold : const Color(0xFFD0D0D0),
                    width: 2,
                  ),
                  boxShadow: value ? [
                    BoxShadow(
                      color: primaryGold.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: value 
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: value ? darkGold : luxuryBlack,
                  fontWeight: value ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(bool isMobile) {
    return Row(
      children: [
        // Back Button
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: darkGold,
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: const BorderSide(color: softGold, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        if (_currentStep > 0) const SizedBox(width: 16),
        
        // Next / Submit Button with luxury gold gradient
        Expanded(
          flex: _currentStep == 0 ? 1 : 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _currentStep == 3 
                    ? [primaryGold, champagneGold]
                    : [darkGold, champagneGold],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: primaryGold.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentStep == 3 ? 'Submit Request' : 'Continue',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentStep == 3 ? Icons.send : Icons.arrow_forward,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(bool isMobile) {
    return AnimatedBuilder(
      animation: _successController,
      builder: (context, child) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: softGold.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: primaryGold.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Animation with gold design
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryGold, champagneGold, darkGold],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryGold.withOpacity(0.4),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 55,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Sparkle decoration
              Text(
                '✨',
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                'Quote Request Submitted!',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: luxuryBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Thank you for choosing MAMA EVENTS! Our team will review your request and get back to you within 24 hours with a personalized quote.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: warmGray,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              
              // WhatsApp Button with luxury styling
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _sendWhatsAppQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.chat, size: 22),
                  label: Text(
                    'Chat on WhatsApp Now',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Submit Another
              TextButton(
                onPressed: _resetForm,
                child: Text(
                  'Submit Another Request',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkGold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
