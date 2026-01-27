import 'package:flutter/material.dart';
import '../../../core/services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../../../config/theme/colors.dart';
import '../../../providers/app_config_provider.dart';

/// Premium Contact Section
/// Features: 2x2 Quick Contact Grid + Contact Form with Gold Accents
class PremiumContactSection extends StatefulWidget {
  const PremiumContactSection({super.key});

  @override
  State<PremiumContactSection> createState() => _PremiumContactSectionState();
}

class _PremiumContactSectionState extends State<PremiumContactSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isSubmitting = false;
  bool _isSuccess = false;
  late AnimationController _successController;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _successController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    // Submit to Firebase
    try {
      await DatabaseService().submitContactMessage({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'message': _messageController.text.trim(),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSubmitting = false);
      }
      return;
    }
    
    setState(() {
      _isSubmitting = false;
      _isSuccess = true;
    });
    
    _successController.forward();
    _confettiController.forward();
    
    // Reset after animation
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isSuccess = false);
      _successController.reset();
      _confettiController.reset();
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.softWhite,
            AppColors.pureWhite,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section Header
              _buildSectionHeader(),
              
              const SizedBox(height: 60),
              
              // Content Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Quick Contact Grid
                        Expanded(child: _buildQuickContactGrid(config)),
                        
                        const SizedBox(width: 60),
                        
                        // Right: Contact Form
                        Expanded(child: _buildContactForm()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildQuickContactGrid(config),
                        const SizedBox(height: 60),
                        _buildContactForm(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        // Section Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.premiumGoldMedium, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'CONTACT US',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.premiumGoldMedium,
              letterSpacing: 3.0,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Main Title
        Text(
          'Get In Touch',
          style: GoogleFonts.inter(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            color: AppColors.logoDeepBlack,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Subtitle
        Text(
          'We\'d love to hear from you. Reach out for inquiries, quotes, or consultations.',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.darkGrey,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Gold Divider
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: AppColors.premiumGoldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickContactGrid(config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Contact',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.logoDeepBlack,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 2x2 Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            // Call Us
            _QuickContactCard(
              icon: Icons.phone_rounded,
              title: 'Call Us',
              subtitle: config.phoneNumber,
              onTap: () async {
                final uri = Uri.parse('tel:${config.phoneNumber}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            ),
            
            // WhatsApp
            _QuickContactCard(
              icon: Icons.chat_rounded,
              title: 'WhatsApp',
              subtitle: 'Quick Response',
              onTap: () async {
                final url = Uri.parse(config.getWhatsAppLink());
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            
            // Email Us
            _QuickContactCard(
              icon: Icons.email_rounded,
              title: 'Email Us',
              subtitle: config.email,
              onTap: () async {
                final uri = Uri.parse('mailto:${config.email}');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            ),
            
            // Get Quote - Gold Gradient
            _QuickContactCard(
              icon: Icons.description_rounded,
              title: 'Get Quote',
              subtitle: 'Free Consultation',
              isGold: true,
              onTap: () {
                // Scroll to form or navigate
              },
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        const SizedBox(height: 0),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send us a Message',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.logoDeepBlack,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Fill out the form below and we\'ll get back to you within 24 hours.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your name',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Phone Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 20),
                
                // Message Field
                _buildTextField(
                  controller: _messageController,
                  label: 'Message',
                  hint: 'Tell us about your event...',
                  icon: Icons.message_outlined,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
          
          // Success Overlay
          if (_isSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.logoDeepBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.logoDeepBlack,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.mediumGrey,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.mediumGrey,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.softWhite,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.premiumGoldMedium, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isSubmitting ? null : _submitForm,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: _isSubmitting ? null : AppColors.premiumGoldGradient,
            color: _isSubmitting ? AppColors.mediumGrey : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isSubmitting
                ? null
                : [
                    BoxShadow(
                      color: AppColors.premiumGoldMedium.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                      spreadRadius: 2,
                    ),
                  ],
          ),
          child: Center(
            child: _isSubmitting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.pureWhite,
                      ),
                    ),
                  )
                : Text(
                    'SEND MESSAGE',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.logoDeepBlack,
                      letterSpacing: 2.0,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Confetti
            ...List.generate(20, (index) => _buildConfettiPiece(index)),
            
            // Success Content
            Center(
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _successController,
                  curve: Curves.elasticOut,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumGoldGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.premiumGoldMedium.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.logoDeepBlack,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Message Sent!',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.logoDeepBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll get back to you within 24 hours.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfettiPiece(int index) {
    final random = math.Random(index);
    final startX = random.nextDouble() * 300;
    final startY = random.nextDouble() * 100 + 100;
    final endY = startY + 200 + random.nextDouble() * 100;
    final rotation = random.nextDouble() * 4 * math.pi;
    
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        final progress = _confettiController.value;
        return Positioned(
          left: startX + math.sin(progress * 4) * 20,
          top: startY + (endY - startY) * progress,
          child: Opacity(
            opacity: (1 - progress).clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: rotation * progress,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? AppColors.premiumGoldMedium
                      : AppColors.premiumGoldLight,
                  borderRadius: BorderRadius.circular(index % 3 == 0 ? 4 : 0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Quick Contact Card Widget
class _QuickContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isGold;

  const _QuickContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isGold = false,
  });

  @override
  State<_QuickContactCard> createState() => _QuickContactCardState();
}

class _QuickContactCardState extends State<_QuickContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            gradient: widget.isGold ? AppColors.premiumGoldGradient : null,
            color: widget.isGold ? null : AppColors.logoCharcoalGrey,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.isGold
                    ? AppColors.premiumGoldMedium.withOpacity(_isHovered ? 0.5 : 0.3)
                    : Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 4),
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isGold
                      ? AppColors.logoDeepBlack.withOpacity(0.15)
                      : AppColors.premiumGoldMedium.withOpacity(_isHovered ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isGold
                      ? AppColors.logoDeepBlack
                      : AppColors.premiumGoldMedium,
                  size: 28,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.isGold
                      ? AppColors.logoDeepBlack
                      : AppColors.pureWhite,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: widget.isGold
                        ? AppColors.logoDeepBlack.withOpacity(0.7)
                        : AppColors.mediumGrey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
