import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/models/event_package.dart';
import '../providers/events_provider.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../features/contact/widgets/simplified_quote_dialog.dart';
import '../shared/widgets/luxury/luxury_hero_header.dart';
import '../shared/widgets/luxury/luxury_tab_bar.dart';
import '../shared/widgets/luxury/gold_divider.dart';
import '../shared/widgets/animations/entry_animation.dart';

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
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48, vertical: 48),
                      color: const Color(0xFF111111),
                      child: Column(
                        children: [
                          const Icon(Icons.format_quote, color: Color(0xFFD4AF37), size: 40),
                          const SizedBox(height: 24),
                          Text(
                            event.description.isNotEmpty 
                                ? event.description 
                                : "Immerse yourself in a world of elegance and taste. Our ${event.name.toLowerCase()} experiences are crafted to leave a lasting impression, combining culinary excellence with impeccable service.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: isMobile ? 18 : 24,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                           const SizedBox(height: 32),
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
  final Widget? childWidget; // Optional pre-built
  final List<String>? tabs; // For building standard TabBar

  _StickyTabBarDelegate({this.childWidget, this.tabs});

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: childWidget ?? TabBar(
        isScrollable: true,
        indicatorColor: const Color(0xFFD4AF37),
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: 1),
        tabs: tabs!.map((t) => Tab(text: t.toUpperCase())).toList(),
      ), 
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}

extension _MethodExtensions on EventDetailsScreen {
  Widget _buildPackageList(EventSubCategory subCategory) {
    // Packages List
    if (subCategory.packages.isEmpty) {
        return Center(child: Text('No packages available.', style: GoogleFonts.inter(color: Colors.grey)));
    }

    return AnimatedListWrapper(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        itemCount: subCategory.packages.length + 1, // +1 for Bottom CTA space
        itemBuilder: (context, index) {
          if (index == subCategory.packages.length) {
              return const SizedBox(height: 100); // Space for FAB or just footer
          }
          final package = subCategory.packages[index];
          return EntryAnimation(
            index: index,
            child: _buildPremiumPackageCard(context, package),
          );
        },
      ),
    );
  }

  Widget _buildPremiumPackageCard(BuildContext context, PackageTier package) {
     final features = package.description.split('\n').where((s) => s.trim().isNotEmpty).toList();
     final isMobile = MediaQuery.of(context).size.width < 600;

     return Container(
       margin: const EdgeInsets.only(bottom: 32),
       decoration: BoxDecoration(
         color: const Color(0xFF1E1E1E),
         borderRadius: BorderRadius.circular(12),
         border: Border.all(color: Colors.white.withOpacity(0.05)),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           // Header / Title
           Container(
             width: double.infinity,
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: const Color(0xFF252525),
               borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
               border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Expanded(
                   child: Text(
                     package.name,
                     style: GoogleFonts.playfairDisplay(
                       color: Colors.white,
                       fontSize: 24,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
                 Text(
                   '${package.pricing.pricePerPerson} PKR', // Fixed to use proper pricing field if available or getter
                   style: GoogleFonts.inter(
                     color: const Color(0xFFD4AF37),
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ],
             ),
           ),
           
           // Features List
           Padding(
             padding: const EdgeInsets.all(24),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 if (features.isNotEmpty)
                    ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFFD4AF37), size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature.replaceAll('•', '').trim(),
                              style: GoogleFonts.inter(
                                color: Colors.grey[300],
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList()
                 else
                    Text(
                      'Contact us for package details.',
                      style: GoogleFonts.inter(color: Colors.grey[500], fontStyle: FontStyle.italic),
                    ),
                    
                 const SizedBox(height: 32),
                 
                 // CTA
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const SimplifiedQuoteDialog(),
                        );
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFFD4AF37),
                       foregroundColor: Colors.black,
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       elevation: 0,
                     ),
                     child: Text(
                       'GET QUOTE',
                       style: GoogleFonts.inter(
                         fontWeight: FontWeight.bold,
                         letterSpacing: 1,
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
}

  // Remove duplicate methods if any
