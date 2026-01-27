import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Premium Catering Tiers Section
/// 5-tier luxury progression with animated cards
/// Features: Tier bar navigation, hover effects, responsive grid
class CateringTiersSection extends StatefulWidget {
  const CateringTiersSection({super.key});

  @override
  State<CateringTiersSection> createState() => _CateringTiersSectionState();
}

class _CateringTiersSectionState extends State<CateringTiersSection> {
  int _selectedTier = 3; // Default to Gold (most popular)
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _tierKeys = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 5; i++) {
      _tierKeys[i] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTier(int tier) {
    setState(() => _selectedTier = tier);
    final key = _tierKeys[tier];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: BoxDecoration(
        color: AppColors.softWhite,
      ),
      child: Column(
        children: [
          _buildSectionHeader(),
          const SizedBox(height: 48),
          _buildTierNavigationBar(),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildTierCardsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.premiumGoldMedium, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'CATERING PACKAGES',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.premiumGoldMedium,
                letterSpacing: 3.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Luxury Service Tiers',
            style: GoogleFonts.inter(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppColors.logoDeepBlack,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'From intimate gatherings to grand celebrations, find your perfect package.',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: AppColors.darkGrey,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.premiumGoldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.logoDeepBlack,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final tier = index + 1;
            return _TierNavButton(
              tier: tier,
              isSelected: tier == _selectedTier,
              onTap: () => _scrollToTier(tier),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTierCardsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth > 1600) {
          crossAxisCount = 5;
        } else if (constraints.maxWidth > 1300) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: List.generate(5, (index) {
            final tier = index + 1;
            final tierData = _getTierData(tier);
            return SizedBox(
              key: _tierKeys[tier],
              width: crossAxisCount == 1 
                  ? constraints.maxWidth 
                  : (constraints.maxWidth - (crossAxisCount - 1) * 24) / crossAxisCount,
              child: _TierCard(
                tier: tier,
                data: tierData,
                isSelected: tier == _selectedTier,
                onSelect: () => setState(() => _selectedTier = tier),
              ),
            );
          }),
        );
      },
    );
  }

  _TierData _getTierData(int tier) {
    switch (tier) {
      case 1:
        return _TierData(
          name: 'The Essential Collection',
          subtitle: 'Perfect for Intimate Gatherings',
          guestRange: '20-50 Guests',
          priceRange: 'Rs 7,500/person',
          features: [
            '4 Main Course Options',
            '2 Appetizer Selections',
            'Standard Table Setup',
            'Basic Cutlery & Crockery',
            'Service Staff (1:20 ratio)',
          ],
          icon: Icons.stars_rounded,
        );
      case 2:
        return _TierData(
          name: 'Heritage Classic',
          subtitle: 'Ideal for Family Celebrations',
          guestRange: '50-100 Guests',
          priceRange: 'Rs 9,500/person',
          features: [
            '6 Main Course Options',
            '3 Appetizer Selections',
            'Enhanced Table Décor',
            'Premium Cutlery & Crockery',
            'Service Staff (1:15 ratio)',
            'Dessert Station',
          ],
          icon: Icons.emoji_events_rounded,
        );
      case 3:
        return _TierData(
          name: 'Signature Selection',
          subtitle: 'Most Popular Choice',
          guestRange: '100-200 Guests',
          priceRange: 'Rs 12,500/person',
          features: [
            '8 Main Course Options',
            '5 Appetizer Selections',
            'Premium Table Styling',
            'Gold-Rimmed Crockery',
            'Service Staff (1:12 ratio)',
            'Live Cooking Station',
            'Beverage Station',
          ],
          icon: Icons.workspace_premium,
          isPopular: true,
        );
      case 4:
        return _TierData(
          name: 'Grand Banquet',
          subtitle: 'Executive Level Excellence',
          guestRange: '200-400 Guests',
          priceRange: 'Rs 17,500/person',
          features: [
            '12 Main Course Options',
            '8 Appetizer Selections',
            'Luxury Table Design',
            'Crystal & Fine China',
            'Service Staff (1:10 ratio)',
            '3 Live Cooking Stations',
            'Premium Bar Setup',
            'Event Coordinator',
          ],
          icon: Icons.diamond_rounded,
        );
      case 5:
        return _TierData(
          name: 'Sovereign Experience',
          subtitle: 'Ultimate Luxury Experience',
          guestRange: '400+ Guests',
          priceRange: 'Custom Quote',
          features: [
            'Unlimited Menu Options',
            'Custom Menu Creation',
            'Bespoke Table Design',
            'Finest China & Crystal',
            'Service Staff (1:8 ratio)',
            '5+ Live Cooking Stations',
            'Full Bar Service',
            'Dedicated Event Manager',
            'Floral Arrangements',
            'Entertainment Coordination',
          ],
          icon: Icons.auto_awesome,
        );
      default:
        return _getTierData(1);
    }
  }
}

class _TierNavButton extends StatefulWidget {
  final int tier;
  final bool isSelected;
  final VoidCallback onTap;

  const _TierNavButton({
    required this.tier,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TierNavButton> createState() => _TierNavButtonState();
}

class _TierNavButtonState extends State<_TierNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final tierColor = AppColors.getTierColor(widget.tier);
    final tierName = AppColors.getTierName(widget.tier);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: '$tierName - Tier ${widget.tier}',
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: widget.isSelected || _isHovered
                  ? AppColors.getTierGradient(widget.tier)
                  : null,
              color: widget.isSelected || _isHovered
                  ? null
                  : AppColors.logoCharcoalGrey,
              borderRadius: BorderRadius.circular(8),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: tierColor.withOpacity(0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TIER ${widget.tier}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: widget.isSelected || _isHovered
                        ? AppColors.logoDeepBlack
                        : AppColors.mediumGrey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tierName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: widget.isSelected || _isHovered
                        ? AppColors.logoDeepBlack
                        : tierColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TierCard extends StatefulWidget {
  final int tier;
  final _TierData data;
  final bool isSelected;
  final VoidCallback onSelect;

  const _TierCard({
    required this.tier,
    required this.data,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<_TierCard> createState() => _TierCardState();
}

class _TierCardState extends State<_TierCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = AppColors.getTierColor(widget.tier);
    final tierGradient = AppColors.getTierGradient(widget.tier);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered || widget.isSelected
                      ? tierColor
                      : AppColors.lightGrey,
                  width: _isHovered || widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered || widget.isSelected
                        ? tierColor.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: _isHovered ? 30 : 15,
                    offset: const Offset(0, 8),
                    spreadRadius: _isHovered ? 4 : 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: tierGradient,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.logoDeepBlack.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'TIER ${widget.tier}',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.logoDeepBlack,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            if (widget.data.isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.logoDeepBlack,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '★ POPULAR',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.premiumGoldMedium,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Icon(
                          widget.data.icon,
                          size: 48,
                          color: AppColors.logoDeepBlack.withOpacity(0.8),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.data.name,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.logoDeepBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.logoDeepBlack.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Guest Capacity',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mediumGrey,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.data.guestRange,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.logoDeepBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Starting From',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.mediumGrey,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      widget.data.priceRange,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: tierColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: AppColors.lightGrey,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Package Includes:',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.logoDeepBlack,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.data.features.take(_isExpanded ? widget.data.features.length : 4).map((feature) => _buildFeatureItem(feature, tierColor)),
                        if (widget.data.features.length > 4)
                          GestureDetector(
                            onTap: () => setState(() => _isExpanded = !_isExpanded),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _isExpanded 
                                    ? '− Show Less' 
                                    : '+ ${widget.data.features.length - 4} more features',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: tierColor,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.go('/contact'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.premiumGoldGradient,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.premiumGoldMedium.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
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
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(
                                  'https://wa.me/971501234567?text=Hi! I\'m interested in the ${widget.data.name}'
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.whatsappGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(String feature, Color tierColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle,
              size: 16,
              color: tierColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.darkGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierData {
  final String name;
  final String subtitle;
  final String guestRange;
  final String priceRange;
  final List<String> features;
  final IconData icon;
  final bool isPopular;

  _TierData({
    required this.name,
    required this.subtitle,
    required this.guestRange,
    required this.priceRange,
    required this.features,
    required this.icon,
    this.isPopular = false,
  });
}
