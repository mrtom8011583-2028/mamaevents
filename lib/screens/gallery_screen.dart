import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/widgets/custom_image.dart';
import 'package:go_router/go_router.dart';
import '../data/gallery_data.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../features/gallery/widgets/image_lightbox.dart';
import '../config/theme/colors.dart';
import '../features/contact/widgets/simplified_quote_dialog.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  late AnimationController _animationController;
  int? _hoveredIndex;
  
  List<String> get _categories => GalleryData.getCategories();
  
  List<GalleryImage> get _filteredImages {
    return GalleryData.getImagesByCategory(_selectedCategory);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Precache images for faster loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }
  
  void _precacheImages() {
    for (final image in GalleryData.allImages) {
      if (image.imageUrl.isNotEmpty) {
        final optimizedUrl = image.imageUrl.replaceAll('w=800', 'w=400').replaceAll('q=80', 'q=60');
        precacheImage(NetworkImage(optimizedUrl), context);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(isMobile),
            
            // Category Filter
            _buildPremiumCategoryFilter(isMobile),
            
            // Stats Section
            _buildStatsSection(isMobile),
            
            // Gallery Grid
            _buildPremiumGalleryGrid(isMobile),
            
            // Instagram CTA
            _buildInstagramCTA(isMobile),
            
            // CTA Section (same as About page)
            _buildCTASection(context),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isMobile) {
    return SizedBox(
      height: isMobile ? 300 : 400,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image Grid (Collage Style)
          Positioned.fill(
            child: CustomImage(
              imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=1920&q=80',
              fit: BoxFit.cover,
            ),
          ),
          
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFC9B037), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'OUR PORTFOLIO',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Main Title
                  Text(
                    'Event Showcase',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 42 : 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Gold Accent Line
                  Container(
                    width: 80,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9B037),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Subtitle
                  Text(
                    'Discover memorable moments from our events\nacross Pakistan',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCategoryFilter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isMobile ? 16 : 40,
      ),
      child: Column(
        children: [
          Text(
            'Browse by Category',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          
          // Premium Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                final count = category == 'All'
                    ? GalleryData.allImages.length
                    : GalleryData.getImagesByCategory(category).length;
                
                // Icon for each category
                IconData icon = Icons.grid_view;
                Color iconColor = const Color(0xFF212121);
                
                switch (category) {
                  case 'Wedding':
                    icon = Icons.favorite;
                    iconColor = const Color(0xFF424242);
                    break;
                  case 'Walima':
                    icon = Icons.mosque;
                    iconColor = const Color(0xFF424242);
                    break;
                  case 'Corporate':
                    icon = Icons.business;
                    iconColor = const Color(0xFF424242);
                    break;
                  case 'Social':
                    icon = Icons.celebration;
                    iconColor = const Color(0xFF5A5A5A);
                    break;
                  case 'Live Stations':
                    icon = Icons.restaurant;
                    iconColor = const Color(0xFF5A5A5A);
                    break;
                  case 'Outdoor':
                    icon = Icons.park;
                    iconColor = const Color(0xFF757575);
                    break;
                }
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFFC9B037) 
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFFC9B037)
                                : const Color(0xFFE0E0E0),
                            width: 2,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFFC9B037).withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ] : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: isSelected ? Colors.white : iconColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected 
                                    ? Colors.white 
                                    : const Color(0xFF424242),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.2)
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                count.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected 
                                      ? Colors.white 
                                      : const Color(0xFF757575),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: isMobile ? 24 : 60,
      ),
      color: const Color(0xFFF8F8F8),
      child: isMobile
          ? Column(
              children: [
                _AnimatedStatItem(
                  endValue: 500,
                  suffix: '+',
                  label: 'Events Catered',
                  icon: Icons.event_available,
                ),
                const SizedBox(height: 32),
                _AnimatedStatItem(
                  endValue: 50,
                  suffix: 'K+',
                  label: 'Happy Guests',
                  icon: Icons.people,
                ),
                const SizedBox(height: 32),
                _AnimatedStatItem(
                  endValue: 100,
                  suffix: '%',
                  label: 'Satisfaction',
                  icon: Icons.star,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AnimatedStatItem(
                  endValue: 500,
                  suffix: '+',
                  label: 'Events Catered',
                  icon: Icons.event_available,
                ),
                _buildStatDivider(),
                _AnimatedStatItem(
                  endValue: 50,
                  suffix: 'K+',
                  label: 'Happy Guests',
                  icon: Icons.people,
                ),
                _buildStatDivider(),
                _AnimatedStatItem(
                  endValue: 100,
                  suffix: '%',
                  label: 'Satisfaction',
                  icon: Icons.star,
                ),
              ],
            ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 80,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _buildPremiumGalleryGrid(bool isMobile) {
    final images = _filteredImages;

    if (images.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(60),
          child: Column(
            children: [
              Icon(Icons.image_not_supported, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No images found in this category',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF757575),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 1200
              ? 4
              : (constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1));
          
          // Equal height for all cards
          const double cardHeight = 360;
          
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: images.asMap().entries.map((entry) {
              final index = entry.key;
              final image = entry.value;
              
              return SizedBox(
                width: (constraints.maxWidth - (crossAxisCount - 1) * 20) / crossAxisCount,
                height: cardHeight,
                child: _buildPremiumGalleryCard(image, index, cardHeight),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildPremiumGalleryCard(GalleryImage image, int index, double height) {
    final isHovered = _hoveredIndex == index;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ImageLightbox(
              images: _filteredImages,
              initialIndex: index,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,

          // ✅ FIXED: use translate instead of translateByDouble
          transform: Matrix4.identity()
            ..translate(0.0, isHovered ? -8.0 : 0.0, 0.0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isHovered ? 0.25 : 0.12,
                ),
                blurRadius: isHovered ? 30 : 15,
                offset: Offset(0, isHovered ? 15 : 8),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [

                // ================= IMAGE =================
                AnimatedScale(
                  duration: const Duration(milliseconds: 400),
                  scale: isHovered ? 1.1 : 1.0,
                  child: _buildImage(image),
                ),

                // ================= GRADIENT OVERLAY =================
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        isHovered
                            ? Colors.black.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.5),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),

                // ================= CATEGORY BADGE =================
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(image.category),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor(image.category)
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      image.category.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                // ================= ZOOM ICON =================
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  top: isHovered ? 16 : -50,
                  right: 16,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isHovered ? 1.0 : 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Color(0xFF212121),
                        size: 22,
                      ),
                    ),
                  ),
                ),

                // ================= CONTENT OVERLAY =================
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(isHovered ? 24 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // TITLE
                        Text(
                          image.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: isHovered ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // DESCRIPTION + BUTTON
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: isHovered
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: const SizedBox.shrink(),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                image.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.visibility,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'View Details',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  Color _getCategoryColor(String category) {
    return const Color(0xFFD4AF37); // Always use premium MAMA Gold for tags
  }

  Widget _buildImage(GalleryImage image) {
    if (image.imageUrl.isNotEmpty) {
      // Use smaller image size for faster loading (400px width for thumbnails)
      final optimizedUrl = image.imageUrl.replaceAll('w=800', 'w=400').replaceAll('q=80', 'q=60');
      
      return CustomImage(
        imageUrl: optimizedUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return _buildPlaceholder(image);
  }

  Widget _buildShimmerPlaceholder(GalleryImage image) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(image.category).withValues(alpha: 0.2),
            _getCategoryColor(image.category).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: _getCategoryColor(image.category).withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(GalleryImage image) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getCategoryColor(image.category).withValues(alpha: 0.3),
            _getCategoryColor(image.category).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: 64,
          color: _getCategoryColor(image.category).withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildInstagramCTA(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 32 : 60),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0D0D0D),
          ],
        ),
      ),
      child: Column(
        children: [
          // Instagram Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Follow Our Journey',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          
          Text(
            'Get daily inspiration, behind-the-scenes content,\nand exclusive event previews on Instagram',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: () async {
              final instagramUrl = Uri.parse('https://www.instagram.com/mamaevents');
              if (await canLaunchUrl(instagramUrl)) {
                await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1B5E20),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.photo_camera, size: 20),
            label: Text(
              '@mamaevents',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return const LuxuryCTASection(
      buttonTypes: [CTAButtonType.contact, CTAButtonType.quote],
    );
  }
}

// Animated Stat Card with Counter Animation
class _AnimatedStatItem extends StatefulWidget {
  final int endValue;
  final String suffix;
  final String label;
  final IconData icon;

  const _AnimatedStatItem({
    required this.endValue,
    required this.suffix,
    required this.label,
    required this.icon,
  });

  @override
  State<_AnimatedStatItem> createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<_AnimatedStatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _countAnimation = IntTween(begin: 0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _startAnimation();

    return AnimatedBuilder(
      animation: _countAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6D00).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFFFF6D00),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_countAnimation.value}${widget.suffix}',
              style: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF757575),
              ),
            ),
          ],
        );
      },
    );
  }
}
