import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/models/menu_item.dart';
import '../core/services/database_service.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../shared/widgets/luxury/luxury_hero_header.dart';
import '../shared/widgets/luxury/luxury_tab_bar.dart';
import '../shared/widgets/luxury/luxury_card.dart';
import '../shared/widgets/luxury/luxury_price_tag.dart';
import '../shared/widgets/luxury/gold_divider.dart';
import '../shared/widgets/animations/entry_animation.dart';

import '../providers/menu_provider.dart';
import '../providers/app_config_provider.dart';
import '../features/contact/widgets/simplified_quote_dialog.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';

class CustomerMenuScreen extends StatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  
  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this); // Initial dummy, updated in build
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1000;
    final size = MediaQuery.of(context).size;

    return Consumer<MenuProvider>(
      builder: (context, menuProvider, child) {
        // Show loading state
        if (menuProvider.isLoading && menuProvider.isEmpty) {
           return Scaffold(
             backgroundColor: Colors.black,
             body: Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
           );
        }

        // Initialize TabController
        final categories = menuProvider.categories.isNotEmpty 
            ? menuProvider.categories 
            : ['All'];
            
        if (_tabController.length != categories.length) {
          _tabController.dispose();
          _tabController = TabController(length: categories.length, vsync: this);
        }
        
        final isSearching = _searchQuery.isNotEmpty;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: const CustomAppBar(),
          body: CustomScrollView(
            slivers: [
              // 1. HERO SECTION
              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LuxuryHeroHeader(
                      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=1920&q=80',
                      title: 'OUR MENU',
                      subtitle: 'Exquisite Pakistani Cuisine',
                      height: isMobile ? 300 : 400,
                    ),
                    Positioned(
                      bottom: isMobile ? 40 : 60,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/event-packages'),
                        icon: const Icon(Icons.celebration, color: Colors.black, size: 20),
                        label: Text(
                          'VIEW EVENT PACKAGES',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 32, 
                            vertical: isMobile ? 12 : 20
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. SEARCH BAR & FEATURED (Only when not searching)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 48, 
                    vertical: 32
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Search Bar
                       Center(
                         child: Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.inter(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search for dishes...',
                              hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                              prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                              suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      menuProvider.searchItems('');
                                    }
                                  )
                                : null,
                              filled: true,
                              fillColor: const Color(0xFF1E1E1E),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8), // Sharper corners
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                            onChanged: (val) => menuProvider.searchItems(val),
                          ),
                         ),
                       ),
                       
                       // Featured Section (Hide on search)
                       if (!isSearching) ...[
                         const SizedBox(height: 48),
                         Text(
                            'CHEF\'S HIGHLIGHTS',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFD4AF37),
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                         ),
                         const SizedBox(height: 24),
                         SizedBox(
                           height: 400,
                           child: ListView.separated(
                             scrollDirection: Axis.horizontal,
                             itemCount: menuProvider.getFeaturedItems().length,
                             separatorBuilder: (_, __) => const SizedBox(width: 24),
                             itemBuilder: (context, index) {
                               final item = menuProvider.getFeaturedItems()[index];
                               return SizedBox(
                                 width: 280,
                                 child: LuxuryCard(
                                   imageUrl: item.imageUrl,
                                   title: item.name,
                                   description: _cleanDescription(item.description),
                                   price: menuProvider.getFormattedPrice(item),
                                   isLarge: true,
                                   onTap: () {}, // Detail view if needed
                                 ),
                               );
                             },
                           ),
                         ),
                       ],
                    ],
                  ),
                ),
              ),

              // 3. STICKY TABS (Hide on search)
              if (!isSearching)
                SliverPersistentHeader(
                  delegate: _StickyTabBarDelegate(
                     LuxuryStickyTabBar(
                       controller: _tabController,
                       tabs: categories,
                     ),
                  ),
                  pinned: true,
                ),

              // 4. MENU GRID
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48, 
                  vertical: 32
                ),
                sliver: isSearching 
                  ? _buildSearchResults(menuProvider, isMobile, isTablet) 
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Manually handling TabBarView logic in a sliver list is tricky
                          // Instead, we show ALL categories sequentially or filtered
                          // BUT User expects Tabs.
                          // Limitation: SliverPersistentHeader inside NestedScrollView works better for Tabs
                          // Let's rely on the TabController listener to rebuild/scroll or just show the selected category?
                          // Standard approach: Use SliverFillRemaining with TabBarView, 
                          // but that breaks the "Single Page" feel if we want the footer at the bottom.
                          // Luxury approach: Just show the SELECTED category's items in a Grid.
                          
                          // We need to listen to TabController changes to rebuild this section
                           return AnimatedBuilder(
                             animation: _tabController,
                             builder: (context, _) {
                               final category = categories[_tabController.index];
                               final items = menuProvider.getItemsByCategory(category);
                               
                               if (items.isEmpty) {
                                  return SizedBox(
                                    height: 200, 
                                    child: Center(child: Text('Coming Soon', style: GoogleFonts.inter(color: Colors.grey)))
                                  );
                               }

                              return AnimatedListWrapper(
                                 child: GridView.builder(
                                   shrinkWrap: true,
                                   physics: const NeverScrollableScrollPhysics(),
                                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                     crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                                     childAspectRatio: isMobile ? 0.7 : 0.65,
                                     mainAxisSpacing: 24,
                                     crossAxisSpacing: 24,
                                   ),
                                   itemCount: items.length,
                                   itemBuilder: (context, i) {
                                     final item = items[i];
                                     return EntryAnimation(
                                       index: i,
                                       child: LuxuryCard(
                                         imageUrl: item.imageUrl,
                                         title: item.name,
                                         description: _cleanDescription(item.description),
                                         price: menuProvider.getFormattedPrice(item),
                                         onTap: () {},
                                       ),
                                     );
                                   },
                                 ),
                               );
                             },
                           );
                        },
                        childCount: 1,
                      ),
                    ),
              ),

              // 5. FOOTER
              const SliverToBoxAdapter(
                child: LuxuryCTASection(
                  buttonTypes: [CTAButtonType.gallery, CTAButtonType.quote],
                ),
              ),
              // Extra space for footer
               const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(MenuProvider provider, bool isMobile, bool isTablet) {
     final results = provider.menuItems;
     
     if (results.isEmpty) {
       return SliverToBoxAdapter(
         child: SizedBox(
           height: 300,
           child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[800]),
                  const SizedBox(height: 16),
                  Text(
                    'No dishes found',
                    style: GoogleFonts.inter(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
           ),
         ),
       );
     }
     
     return SliverGrid(
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
         childAspectRatio: isMobile ? 0.7 : 0.65,
         mainAxisSpacing: 24,
         crossAxisSpacing: 24,
       ),
       delegate: SliverChildBuilderDelegate(
         (context, index) {
            final item = results[index];
            return LuxuryCard(
               imageUrl: item.imageUrl,
               title: item.name,
               description: _cleanDescription(item.description),
               price: provider.getFormattedPrice(item),
               onTap: () {},
             );
         },
         childCount: results.length,
       ),
     );
  }
  String _cleanDescription(String desc) {
    if (desc.isEmpty) return '';
    // Remove HTML, Emails, URLs
    return desc
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'), '')
        .replaceAll(RegExp(r'https?://\S+'), '')
        .trim();
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate(this.child);

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black, // Match background
      alignment: Alignment.center,
      child: child, // LuxuryStickyTabBar handles its own internal color/style
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return true; // Rebuild when tabs change
  }
}
