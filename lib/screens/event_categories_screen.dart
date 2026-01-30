import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/models/event_package.dart';
import '../providers/events_provider.dart';
import '../config/theme/colors.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../shared/widgets/custom_image.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';

/// User-facing page showing all event categories (Wedding, Corporate, Birthday)
class EventCategoriesScreen extends StatelessWidget {
  const EventCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFF1a1a1a),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  CustomImage(
                    imageUrl: 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=1920&q=80',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OUR EVENT PACKAGES',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Exquisite Catering for Every Occasion',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category Cards - ⚡ OPTIMIZED: Using cached data from EventsProvider
          SliverPadding(
            padding: const EdgeInsets.all(32),
            sliver: Consumer<EventsProvider>(
              builder: (context, eventsProvider, child) {
                // Show loader only on first load
                if (eventsProvider.isLoading && eventsProvider.categories.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
                  );
                }

                final categories = eventsProvider.categories;

                if (categories.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No event packages available',
                        style: GoogleFonts.inter(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCategoryCard(context, categories[index]),
                    childCount: categories.length,
                  ),
                );
              },
            ),
          ),


          // 3. CTA SECTION
          const SliverToBoxAdapter(
            child: LuxuryCTASection(
              buttonTypes: [CTAButtonType.menu, CTAButtonType.quote],
            ),
          ),

          // Bottom Spacing
          const SliverToBoxAdapter(child: SizedBox(height: 64)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, EventCategory category) {
    // Get total package count
    int totalPackages = 0;
    for (var sub in category.subCategories) {
      totalPackages += sub.packages.length;
    }

    // Get icon emoji
    String icon = '🎉';
    if (category.id == 'wedding') icon = '💍';
    else if (category.id == 'corporate') icon = '💼';
    else if (category.id == 'birthday') icon = '🎉';

    // Get background image
    String bgImage = 'https://images.unsplash.com/photo-1529543544277-750e2ea87990?w=800&q=80';
    if (category.id == 'wedding') {
      bgImage = 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&q=80';
    } else if (category.id == 'corporate') {
      bgImage = 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80';
    } else if (category.id == 'birthday') {
      bgImage = 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=800&q=80';
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/event-packages/${category.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                CustomImage(
                  imageUrl: bgImage,
                  fit: BoxFit.cover,
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                          icon,
                          style: const TextStyle(fontSize: 36),
                        ),
                      const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 4),
                        Text(
                          category.description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$totalPackages Packages',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
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
        ),
      ),
    );
  }
}
