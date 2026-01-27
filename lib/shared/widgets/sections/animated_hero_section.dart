import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/colors.dart';

/// Premium Animated Hero Section
/// Implements the exact animation sequence from Senior Flutter Architect spec
/// Total Duration: 2.8 seconds
class AnimatedHeroSection extends StatefulWidget {
  const AnimatedHeroSection({super.key});

  @override
  State<AnimatedHeroSection> createState() => _AnimatedHeroSectionState();
}

class _AnimatedHeroSectionState extends State<AnimatedHeroSection>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late AnimationController _ctaController;
  
  // Animations
  late Animation<double> _backgroundOpacity;
  late Animation<double> _gradientScale;
  late Animation<double> _logoScale;
  late Animation<Offset> _logoOffset;
  late Animation<double> _logoOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _ctaSlide;
  late Animation<double> _ctaOpacity;
  late Animation<double> _shimmerPosition;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    // Background Animation (0-800ms)
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _backgroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeOut),
    );
    _gradientScale = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeOutCubic),
    );

    // Logo Animation (400-1200ms) - 800ms duration, starts at 400ms
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOffset = Tween<Offset>(
      begin: const Offset(0, 10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Tagline Animation (800-1800ms) - 1000ms duration, starts at 800ms
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    // CTA Animation (1200-2400ms) - 1200ms duration, starts at 1200ms
    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic),
    );
    _ctaOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctaController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _shimmerPosition = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _ctaController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _startAnimationSequence() async {
    // Stage 1: Background (0ms)
    _backgroundController.forward();
    
    // Stage 2: Logo (400ms delay)
    await Future.delayed(const Duration(milliseconds: 400));
    _logoController.forward();
    
    // Stage 3: Tagline (800ms delay from start)
    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();
    
    // Stage 4: CTA Buttons (1200ms delay from start)
    await Future.delayed(const Duration(milliseconds: 400));
    _ctaController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _taglineController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          final isSmallMobile = constraints.maxWidth < 400;

          return AnimatedBuilder(
            animation: Listenable.merge([
              _backgroundController,
              _logoController,
              _taglineController,
              _ctaController,
            ]),
            builder: (context, child) {
              return Stack(
                children: [
                  // Animated Background with Radial Gradient
                  _buildAnimatedBackground(),
                  
                  // Subtle Gold Accent Line at Bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        gradient: AppColors.premiumGoldGradient,
                      ),
                    ),
                  ),
                  
                  // Hero Content
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo
                          _buildAnimatedLogo(isMobile, isSmallMobile, constraints.maxWidth),
                          
                          SizedBox(height: isMobile ? 30 : 40),
                          
                          // Animated Tagline
                          _buildAnimatedTagline(isMobile),
                          
                          SizedBox(height: isMobile ? 40 : 60),
                          
                          // Animated CTA Buttons
                          _buildAnimatedCTAButtons(isMobile),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Opacity(
      opacity: _backgroundOpacity.value,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.logoDeepBlack,
        ),
        child: Center(
          child: Transform.scale(
            scale: _gradientScale.value,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.logoCharcoalGrey.withOpacity(0.4),
                    AppColors.logoDeepBlack.withOpacity(0.0),
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(bool isMobile, bool isSmallMobile, double maxWidth) {
    // Dynamic Scaled Font Size
    double fontSize = isMobile 
        ? (maxWidth * 0.12).clamp(32.0, 56.0) 
        : 72.0;

    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform.translate(
        offset: _logoOffset.value,
        child: Transform.scale(
          scale: _logoScale.value,
          child: Column(
            children: [
              // Logo with soft glow
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.premiumGoldMedium.withOpacity(0.15),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.logoSilverWhite,
                      Colors.white,
                      AppColors.premiumGoldLight.withOpacity(0.8),
                      Colors.white,
                      AppColors.logoSilverWhite,
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'MAMA EVENTS',
                      style: GoogleFonts.inter(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: isMobile ? 3.0 : 6.0,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Gold accent line under logo
              Container(
                width: isMobile ? 60 : 100,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: AppColors.premiumGoldGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTagline(bool isMobile) {
    final words = ['Complete', 'Event', 'Solutions'];
    
    return Opacity(
      opacity: _taglineOpacity.value,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: isMobile ? 6 : 12,
        runSpacing: isMobile ? 6 : 0,
        children: words.asMap().entries.map((entry) {
          final index = entry.key;
          final word = entry.value;
          
          // Staggered animation for each word
          final wordDelay = index * 0.15; // 150ms stagger
          final wordProgress = (_taglineController.value - wordDelay).clamp(0.0, 1.0 - wordDelay) / (1.0 - wordDelay);
          
          return Opacity(
            opacity: wordProgress.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - wordProgress.clamp(0.0, 1.0))),
              child: Text(
                word,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.w300,
                  color: AppColors.logoSilverWhite,
                  letterSpacing: isMobile ? 4.0 : 8.0,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedCTAButtons(bool isMobile) {
    return Opacity(
      opacity: _ctaOpacity.value,
      child: Transform.translate(
        offset: _ctaSlide.value,
        child: isMobile
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   // Right Button: GET QUOTE (Primary Action on Mobile)
                  _buildGoldGradientButton(
                    label: 'GET QUOTE',
                    onPressed: () => context.go('/contact'),
                    shimmerOffset: _shimmerPosition.value - 0.3,
                    elevated: true,
                    fullWidth: true,
                  ),
                  
                  const SizedBox(height: 16),

                  // Left Button: VIEW OUR MENU
                  _buildGoldGradientButton(
                    label: 'VIEW OUR MENU',
                    onPressed: () => context.go('/our-menu'),
                    shimmerOffset: _shimmerPosition.value,
                    fullWidth: true,
                  ),
                ],
              )
            : Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  // Left Button: VIEW OUR MENU
                  _buildGoldGradientButton(
                    label: 'VIEW OUR MENU',
                    onPressed: () => context.go('/our-menu'),
                    shimmerOffset: _shimmerPosition.value,
                  ),
                  
                  // Right Button: GET QUOTE (with elevation)
                  _buildGoldGradientButton(
                    label: 'GET QUOTE',
                    onPressed: () => context.go('/contact'),
                    shimmerOffset: _shimmerPosition.value - 0.3,
                    elevated: true,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGoldGradientButton({
    required String label,
    required VoidCallback onPressed,
    required double shimmerOffset,
    bool elevated = false,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? 280 : null, // Fixed width for mobile buttons for consistency
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumGoldMedium.withOpacity(elevated ? 0.5 : 0.3),
            blurRadius: elevated ? 24 : 16,
            offset: Offset(0, elevated ? 10 : 6),
            spreadRadius: elevated ? 2 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            // Base gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.premiumGoldGradient,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onPressed,
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    child: Center(
                      widthFactor: 1.0, 
                      child: Text(
                        label,
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
              ),
            ),
            
            // Shimmer overlay
            Positioned.fill(
              child: IgnorePointer(
                child: Transform.translate(
                  offset: Offset(shimmerOffset * 200, 0),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
