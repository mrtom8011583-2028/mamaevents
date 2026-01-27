import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme/colors.dart';
import '../../../providers/app_config_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Premium Scroll-Responsive App Bar
/// Transitions from transparent to solid as user scrolls
/// Implements golden accent system
class ScrollResponsiveAppBar extends StatefulWidget {
  final ScrollController scrollController;
  
  const ScrollResponsiveAppBar({
    super.key,
    required this.scrollController,
  });

  @override
  State<ScrollResponsiveAppBar> createState() => _ScrollResponsiveAppBarState();
}

class _ScrollResponsiveAppBarState extends State<ScrollResponsiveAppBar> {
  double _scrollOffset = 0;
  
  // Scroll thresholds
  static const double _startFade = 0;
  static const double _midFade = 200;
  static const double _endFade = 400;
  
  // Height values
  static const double _expandedHeight = 80;
  static const double _compactHeight = 56;
  
  // Logo sizes
  static const double _expandedLogoSize = 64;
  static const double _compactLogoSize = 40;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = widget.scrollController.offset;
    });
  }

  // Calculate progress (0.0 to 1.0) based on scroll
  double get _scrollProgress {
    return ((_scrollOffset - _startFade) / (_endFade - _startFade)).clamp(0.0, 1.0);
  }
  
  // Calculate background opacity
  double get _backgroundOpacity {
    if (_scrollOffset < _startFade) return 0.0;
    if (_scrollOffset > _midFade) return 0.95;
    return ((_scrollOffset - _startFade) / (_midFade - _startFade)).clamp(0.0, 0.95);
  }

  // Calculate current height
  double get _currentHeight {
    return _expandedHeight - ((_expandedHeight - _compactHeight) * _scrollProgress);
  }

  // Calculate logo size
  double get _currentLogoSize {
    return _expandedLogoSize - ((_expandedLogoSize - _compactLogoSize) * _scrollProgress);
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final isCompact = _scrollProgress > 0.5;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _currentHeight,
      decoration: BoxDecoration(
        color: AppColors.logoCharcoalGrey.withOpacity(_backgroundOpacity),
        boxShadow: _scrollProgress > 0.3 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2 * _scrollProgress),
            blurRadius: 10 * _scrollProgress,
            offset: Offset(0, 2 * _scrollProgress),
          ),
        ] : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Logo Section
              _buildAnimatedLogo(isCompact),
              
              // Spacer
              const Spacer(),
              
              // Desktop Navigation (hidden on mobile)
              if (MediaQuery.of(context).size.width > 900)
                _buildDesktopNavigation(context),
              
              // CTA Buttons / Region Selector
              if (MediaQuery.of(context).size.width > 600)
                _buildActionButtons(context, config),
              
              // Mobile Menu Button
              if (MediaQuery.of(context).size.width <= 900)
                _buildMobileMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(bool isCompact) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Icon with glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _currentLogoSize,
              height: _currentLogoSize,
              decoration: BoxDecoration(
                gradient: AppColors.premiumGoldGradient,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.premiumGoldMedium.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(
                  'assets/images/logo_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    
    final navItems = [
      ('Home', '/'),
      ('About', '/about'),
      ('Services', '/services'),
      ('Menu', '/our-menu'),
      ('Gallery', '/gallery'),
      ('Contact', '/contact'),
    ];
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navItems.map((item) {
        final isActive = currentPath == item.$2;
        return _NavItem(
          label: item.$1,
          route: item.$2,
          isActive: isActive,
          scrollProgress: _scrollProgress,
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context, config) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // WhatsApp Button
        _buildWhatsAppButton(config),
        
        const SizedBox(width: 12),
        
        // Get Quote CTA
        _buildQuoteCTA(context),
      ],
    );
  }

  Widget _buildWhatsAppButton(config) {
    return IconButton(
      onPressed: () async {
        final url = Uri.parse(config.getWhatsAppLink());
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF25D366),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 16,
        ),
      ),
      tooltip: 'WhatsApp',
    );
  }

  Widget _buildQuoteCTA(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.premiumGoldGradient,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumGoldMedium.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/contact'),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'GET QUOTE',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.logoDeepBlack,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuButton(BuildContext context) {
    return IconButton(
      onPressed: () => _showMobileMenu(context),
      icon: Icon(
        Icons.menu,
        color: AppColors.logoSilverWhite,
        size: 28,
      ),
      tooltip: 'Menu',
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _MobileMenuSheet(),
    );
  }
}

/// Navigation Item with Gold Accent
class _NavItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isActive;
  final double scrollProgress;

  const _NavItem({
    required this.label,
    required this.route,
    required this.isActive,
    required this.scrollProgress,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive || _isHovered
                      ? AppColors.premiumGoldMedium
                      : AppColors.logoSilverWhite.withOpacity(0.9),
                  letterSpacing: 1.0,
                ),
                child: Text(widget.label.toUpperCase()),
              ),
              
              const SizedBox(height: 4),
              
              // Gold Underline (active indicator)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.isActive ? 20 : (_isHovered ? 12 : 0),
                height: 2,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppColors.premiumGoldMedium
                      : AppColors.premiumGoldMedium.withOpacity(_isHovered ? 0.7 : 0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mobile Menu Sheet with Gold Overlay
class _MobileMenuSheet extends StatelessWidget {
  const _MobileMenuSheet();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final currentPath = GoRouterState.of(context).uri.path;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.logoCharcoalGrey,
            AppColors.logoDeepBlack,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.premiumGoldMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Logo
          Container(
             padding: const EdgeInsets.all(12), // Slightly reduced padding for image
            decoration: BoxDecoration(
              gradient: AppColors.premiumGoldGradient,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.premiumGoldMedium.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo_icon.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildMobileNavItem(context, 'Home', '/', currentPath),
                _buildMobileNavItem(context, 'About Us', '/about', currentPath),
                _buildMobileNavItem(context, 'Services', '/services', currentPath),
                _buildMobileNavItem(context, 'Menu', '/menu', currentPath),
                _buildMobileNavItem(context, 'Gallery', '/gallery', currentPath),
                _buildMobileNavItem(context, 'Contact', '/contact', currentPath),
                
                const SizedBox(height: 32),
                
                // Gold CTA Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGoldGradient,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.premiumGoldMedium.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/contact');
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: Text(
                            'GET FREE QUOTE',
                            style: GoogleFonts.inter(
                              fontSize: 16,
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
                
                const SizedBox(height: 24),
                
                // WhatsApp Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        final url = Uri.parse(config.getWhatsAppLink());
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat, color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'WhatsApp Us',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Info
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              config.phoneNumber,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.mediumGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavItem(
    BuildContext context,
    String label,
    String route,
    String currentPath,
  ) {
    final isActive = currentPath == route;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          context.go(route);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isActive ? AppColors.premiumGoldMedium : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.premiumGoldMedium
                      : AppColors.logoSilverWhite,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              if (isActive)
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.premiumGoldMedium,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
