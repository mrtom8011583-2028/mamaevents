import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../config/theme/colors.dart';

/// Premium Testimonials Section
/// Auto-playing carousel with gold accents
/// Features: Gold stars, gold border accent, pulse dots
class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  bool _isHovered = false;

  final List<_TestimonialData> _testimonials = [
    _TestimonialData(
      name: 'Sarah Al-Rashid',
      title: 'Wedding Client',
      quote: 'MAMA EVENTS transformed our wedding into a magical experience. The attention to detail was extraordinary, and our guests are still talking about the incredible food and service.',
      rating: 5,
      guestCount: '350 Guests',
      eventType: 'Wedding Reception',
      imageUrl: null,
    ),
    _TestimonialData(
      name: 'Ahmed Hassan',
      title: 'Corporate Event Manager',
      quote: 'We\'ve partnered with MAMA EVENTS for three consecutive annual galas. Their professionalism and culinary excellence consistently exceed expectations.',
      rating: 5,
      guestCount: '500 Guests',
      eventType: 'Corporate Gala',
      imageUrl: null,
    ),
    _TestimonialData(
      name: 'Fatima Khan',
      title: 'Private Party Host',
      quote: 'From the first consultation to the last plate served, MAMA EVENTS delivered perfection. The fusion menu was a hit with everyone!',
      rating: 5,
      guestCount: '120 Guests',
      eventType: 'Birthday Celebration',
      imageUrl: null,
    ),
    _TestimonialData(
      name: 'Mohammed Al-Farsi',
      title: 'Hotel Manager',
      quote: 'As a 5-star hotel, we demand excellence. MAMA EVENTS has been our trusted catering partner for VIP events and has never disappointed.',
      rating: 5,
      guestCount: '200 Guests',
      eventType: 'VIP Reception',
      imageUrl: null,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!_isHovered && mounted) {
        final nextPage = (_currentPage + 1) % _testimonials.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.pureWhite,
            AppColors.softWhite,
          ],
        ),
      ),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(),
          
          const SizedBox(height: 60),
          
          // Testimonials Carousel
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: SizedBox(
              height: 380,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _testimonials.length,
                itemBuilder: (context, index) {
                  return _buildTestimonialCard(index);
                },
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Carousel Dots
          _buildCarouselDots(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Section Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.premiumGoldMedium, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'TESTIMONIALS',
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
            'What Our Clients Say',
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
            'Trusted by hundreds of satisfied clients across the region',
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
      ),
    );
  }

  Widget _buildTestimonialCard(int index) {
    final testimonial = _testimonials[index];
    final isActive = index == _currentPage;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: isActive ? 0 : 20,
      ),
      transform: Matrix4.identity()
        ..scale(isActive ? 1.0 : 0.95),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.premiumGoldMedium.withOpacity(0.15)
                  : Colors.black.withOpacity(0.06),
              blurRadius: isActive ? 30 : 15,
              offset: const Offset(0, 8),
              spreadRadius: isActive ? 2 : 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Gold Gradient Top Border
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: AppColors.premiumGoldGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Stars + Event Info
                    Row(
                      children: [
                        // Gold Star Rating
                        _buildGoldStars(testimonial.rating),
                        
                        const Spacer(),
                        
                        // Guest Count with Gold Icon
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.premiumGoldMedium.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: AppColors.premiumGoldMedium,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                testimonial.guestCount,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.premiumGoldDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quote
                    Expanded(
                      child: Text(
                        '"${testimonial.quote}"',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrey,
                          height: 1.7,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Author Info
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.premiumGoldGradient,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              testimonial.name.substring(0, 1),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.logoDeepBlack,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Name & Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testimonial.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.logoDeepBlack,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              testimonial.eventType,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.premiumGoldMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildGoldStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 20,
            color: index < rating 
                ? AppColors.premiumGoldLight 
                : AppColors.lightGrey,
          ),
        );
      }),
    );
  }

  Widget _buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_testimonials.length, (index) {
        final isActive = index == _currentPage;
        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: isActive ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              gradient: isActive ? AppColors.premiumGoldGradient : null,
              color: isActive ? null : AppColors.lightGrey,
              borderRadius: BorderRadius.circular(5),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.premiumGoldMedium.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

class _TestimonialData {
  final String name;
  final String title;
  final String quote;
  final int rating;
  final String guestCount;
  final String eventType;
  final String? imageUrl;

  _TestimonialData({
    required this.name,
    required this.title,
    required this.quote,
    required this.rating,
    required this.guestCount,
    required this.eventType,
    this.imageUrl,
  });
}
