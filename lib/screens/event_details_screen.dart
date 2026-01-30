import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/models/event_package.dart';
import '../providers/events_provider.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../widgets/advanced_quote_request_form.dart';
import '../shared/widgets/luxury/luxury_hero_header.dart';
import '../shared/widgets/luxury/luxury_tab_bar.dart';
import '../shared/widgets/luxury/gold_divider.dart';
import '../shared/widgets/animations/entry_animation.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // We need to fetch data first to know how many tabs (SubCategories)
  
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          if (eventsProvider.isLoading && eventsProvider.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)));
          }
          
          final event = eventsProvider.getCategoryById(widget.eventId) ?? 
              EventCategory(id: '404', name: 'Not Found', description: '', icon: Icons.error_outline, color: Colors.black, subCategories: []);

          if (event.id == '404') return const Center(child: Text('Event Not Found', style: TextStyle(color: Colors.white)));

          return DefaultTabController(
            length: event.subCategories.length,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // 1. HERO SECTION
                  SliverToBoxAdapter(
                    child: LuxuryHeroHeader(
                      imageUrl: event.imageUrl.isNotEmpty ? event.imageUrl : 'https://via.placeholder.com/1920',
                      title: 'THE EXPERIENCE',
                      subtitle: event.name,
                      height: isMobile ? 300 : 450,
                    ),
                  ),

                   // 2. STORY SECTION
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48, vertical: 80),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D0D0D),
                        image: DecorationImage(
                          image: NetworkImage('https://www.transparenttextures.com/patterns/black-linen.png'), // Subtle texture
                          opacity: 0.1,
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.format_quote, color: Color(0xFFD4AF37), size: 32),
                          ),
                          const SizedBox(height: 32),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: Text(
                              event.description.isNotEmpty 
                                  ? event.description 
                                  : "Immerse yourself in a world of elegance and taste. Our ${event.name.toLowerCase()} experiences are crafted to leave a lasting impression, combining culinary excellence with impeccable service.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: isMobile ? 20 : 28,
                                height: 1.6,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          const GoldDivider(),
                        ],
                      ),
                    ),
                  ),

                  // 3. STICKY TABS
                  if (event.subCategories.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyTabBarDelegate(
                         tabs: event.subCategories.map((sub) => sub.name).toList(),
                      ),
                    ),
                ];
              },
              body: event.subCategories.isEmpty 
                  ? const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white)))
                  : TabBarView(
                      children: event.subCategories.map((sub) => widget._buildPackageList(sub)).toList(),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget? childWidget; 
  final List<String>? tabs; 

  _StickyTabBarDelegate({this.childWidget, this.tabs});

  @override
  double get minExtent => 70;

  @override
  double get maxExtent => 70;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      alignment: Alignment.center,
      child: childWidget ?? TabBar(
        isScrollable: true,
        indicatorColor: const Color(0xFFD4AF37),
        indicatorWeight: 4,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w800, 
          letterSpacing: 2,
          fontSize: 13,
        ),
        tabs: tabs!.map((t) => Tab(text: t.toUpperCase())).toList(),
      ), 
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return true;
  }
}

extension _MethodExtensions on EventDetailsScreen {
  Widget _buildPackageList(EventSubCategory subCategory) {
    return AnimatedListWrapper(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        // Add 1 for the header (description/image). 
        // If packages exist, add them + 2 (CTA + spacer).
        // If empty, add 1 (message).
        itemCount: subCategory.packages.isEmpty 
            ? 2 // Header + "No packages"
            : subCategory.packages.length + 3, // Header + Packages + CTA + Spacer
        itemBuilder: (context, index) {
          // 0. SUB-CATEGORY HEADER (Description & Image)
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sub-Category Image (Optional: Only if different from main hero or specific desire)
                // For now, let's focus on the Description as requested.
                
                // Description
                if (subCategory.description.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border(left: BorderSide(color: const Color(0xFFD4AF37), width: 3)),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subCategory.name.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD4AF37),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          subCategory.description,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          // Handle Empty State
          if (subCategory.packages.isEmpty) {
             // Index 1 is the message
             return Center(
               child: Padding(
                 padding: const EdgeInsets.only(top: 40),
                 child: Text(
                   'No packages available for this category yet.',
                   style: GoogleFonts.inter(color: Colors.grey[600], fontStyle: FontStyle.italic),
                 ),
               ),
             );
          }

          // Handle Packages
          // Indices: 0=Header, 1..N = Packages
          final packageIndex = index - 1;

          if (packageIndex < subCategory.packages.length) {
            final package = subCategory.packages[packageIndex];
            return EntryAnimation(
              index: packageIndex,
              child: _buildPremiumPackageCard(context, package),
            );
          }

          // CTA Section
          if (packageIndex == subCategory.packages.length) {
              return const LuxuryCTASection(
                buttonTypes: [CTAButtonType.gallery, CTAButtonType.quote],
              );
          }

          // Spacer
          return const SizedBox(height: 80);
        },
      ),
    );
  }

  Widget _buildPremiumPackageCard(BuildContext context, PackageTier package) {
     final isMobile = MediaQuery.of(context).size.width < 600;
     
     // 1. Resolve Image
     String? bgImage;
     if (package.images.isNotEmpty) {
       bgImage = package.images.first;
     } else if (package.imageUrl.isNotEmpty) {
       bgImage = package.imageUrl;
     }

     // 2. Resolve Price
     final price = package.pricing.pricePerPerson;
     final priceText = price > 0 
         ? 'Rs ${price.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
         : 'Get Quote';

     // 3. Resolve Features (Highlights)
     final displayFeatures = <String>[];
     
     // Add structured features
     if (package.features.boneFree) displayFeatures.add('Bone-Free (No Bones)');
     if (package.features.messFree) displayFeatures.add('Mess-Free (Easy to Eat)');
     if (package.features.grilled) displayFeatures.add('Live BBQ (Grilled Fresh)');
     if (package.features.lowOil) displayFeatures.add('Low Oil / Heart Healthy');
     if (package.features.ketoFriendly) displayFeatures.add('Keto Friendly');
     
     // Add explicit tags
     if (package.tags.isNotEmpty) {
       displayFeatures.addAll(package.tags);
     }
     
     // Fallback to description loop if no structured features found
     if (displayFeatures.isEmpty) {
        final descLines = package.description.split('\n').where((s) => s.trim().isNotEmpty).toList();
        if (descLines.every((l) => l.length < 60)) {
           displayFeatures.addAll(descLines);
        }
     }

     return Container(
       margin: const EdgeInsets.only(bottom: 40),
       decoration: BoxDecoration(
         color: const Color(0xFF111111), // Fallback color
         image: bgImage != null && bgImage.isNotEmpty
             ? DecorationImage(
                 image: NetworkImage(bgImage),
                 fit: BoxFit.cover,
                 colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.85), BlendMode.darken),
               )
             : null,
         gradient: bgImage == null 
             ? const LinearGradient(
                 begin: Alignment.topLeft,
                 end: Alignment.bottomRight,
                 colors: [Color(0xFF222222), Color(0xFF111111)],
               )
             : null,
         borderRadius: BorderRadius.circular(16),
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.3),
             blurRadius: 20,
             offset: const Offset(0, 10),
           ),
         ],
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Header
           Container(
             padding: const EdgeInsets.all(32),
             decoration: BoxDecoration(
               border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
             ),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 // Gold Accent Bar
                 Container(
                   width: 4,
                   height: 40,
                   decoration: BoxDecoration(
                     color: const Color(0xFFD4AF37),
                     borderRadius: BorderRadius.circular(2),
                   ),
                 ),
                 const SizedBox(width: 20),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         package.name.toUpperCase(),
                         style: GoogleFonts.playfairDisplay(
                           color: Colors.white,
                           fontSize: isMobile ? 22 : 28,
                           fontWeight: FontWeight.w900,
                           letterSpacing: 1,
                         ),
                       ),
                       const SizedBox(height: 4),
                       Text(
                         package.tagline.isNotEmpty ? package.tagline : 'EXCLUSIVELY CRAFTED',
                         style: GoogleFonts.inter(
                           color: const Color(0xFFD4AF37).withOpacity(0.7),
                           fontSize: 10,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 3,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(
                     color: const Color(0xFFD4AF37).withOpacity(0.1),
                     borderRadius: BorderRadius.circular(30),
                     border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                   ),
                   child: Text(
                     priceText,
                     style: GoogleFonts.inter(
                       color: const Color(0xFFD4AF37),
                       fontSize: isMobile ? 16 : 20,
                       fontWeight: FontWeight.w800,
                     ),
                   ),
                 ),
               ],
             ),
           ),
           
           // Features & Menu
           Padding(
             padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  // 1. Highlights (Structured Features)
                  if (displayFeatures.isNotEmpty) ...[
                     Text(
                       'PACKAGE HIGHLIGHTS',
                       style: GoogleFonts.inter(
                         color: Colors.white,
                         fontSize: 12,
                         fontWeight: FontWeight.bold,
                         letterSpacing: 1.2,
                       ),
                     ),
                     const SizedBox(height: 16),
                     ...displayFeatures.map((feature) => _buildFeatureItem(feature)).toList(),
                     const SizedBox(height: 32),
                     const Divider(color: Colors.white10),
                     const SizedBox(height: 32),
                  ],

                  // 2. Structured Menu Sections
                  _buildSectionGroup('Main Course', package.menuSections.mainCourse),
                  _buildSectionGroup('Rice & Sides', [...package.menuSections.rice, ...package.menuSections.sides]),
                  _buildSectionGroup('BBQ & Grill', package.menuSections.bbqGrilled),
                  _buildSectionGroup('Desserts', package.menuSections.desserts),
                  _buildSectionGroup('Beverages', package.menuSections.beverages),
                  _buildSectionGroup('Live Stations', package.menuSections.liveStations),
                  _buildSectionGroup('Bakery & Breads', package.menuSections.breads),

                  // If everything is empty, show a placeholder
                  if (package.menuSections.allItems.isEmpty && displayFeatures.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Contact us for full menu details.',
                        style: GoogleFonts.inter(color: Colors.grey[500], fontStyle: FontStyle.italic),
                      ),
                    ),
                    
                 const SizedBox(height: 40),
                 
                 // CTA
                 Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(12),
                     boxShadow: [
                       BoxShadow(
                         color: const Color(0xFFD4AF37).withOpacity(0.2),
                         blurRadius: 15,
                         offset: const Offset(0, 5),
                       ),
                     ],
                   ),
                   child: ElevatedButton(
                     onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.white,
                            insetPadding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width < 600 ? 16 : 40,
                              vertical: 24
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: AdvancedQuoteRequestForm(
                                  packageName: package.name,
                                  basePricePerHead: package.pricing.pricePerPerson.toDouble(),
                                  onSuccess: () {
                                     Navigator.pop(context);
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       const SnackBar(
                                         content: Text('Reservation request submitted successfully!'),
                                         backgroundColor: Color(0xFF059669),
                                       ),
                                     );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFFD4AF37),
                       foregroundColor: Colors.black,
                       minimumSize: const Size(double.infinity, 64),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                       elevation: 0,
                     ),
                     child: Text(
                       'RESERVE YOUR EXPERIENCE',
                       style: GoogleFonts.inter(
                         fontWeight: FontWeight.w900,
                         letterSpacing: 2,
                         fontSize: 14,
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
  }

  Widget _buildSectionGroup(String title, List<String> items) {
    // Filter out empty items
    final validItems = items.where((i) => i.trim().isNotEmpty).toList();
    if (validItems.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFFD4AF37),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Divider(color: const Color(0xFFD4AF37).withOpacity(0.1), thickness: 0.5)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: validItems.map((item) => SizedBox(
              width: 250, // Fixed width for a nice grid-like flow
              child: _buildFeatureItem(item, compact: true),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, {bool compact = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
            ),
            child: const Icon(Icons.check, color: Color(0xFFD4AF37), size: 8),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text.replaceAll('•', '').trim(),
              style: GoogleFonts.inter(
                color: Colors.grey[300],
                fontSize: compact ? 14 : 16,
                height: 1.4,
                fontWeight: compact ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
