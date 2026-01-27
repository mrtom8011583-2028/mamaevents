import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/models/event_package.dart';
import '../providers/events_provider.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../shared/widgets/luxury/luxury_hero_header.dart';
import '../shared/widgets/luxury/luxury_card.dart';
import '../shared/widgets/luxury/gold_divider.dart';
import '../shared/widgets/animations/entry_animation.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';
import '../config/theme/colors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class EventPackagesScreen extends StatelessWidget {
  const EventPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: AnimationLimiter(
        child: CustomScrollView(
          slivers: [
            // 1. HERO SECTION
            SliverToBoxAdapter(
              child: LuxuryHeroHeader(
                imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=1920&q=80',
                title: 'CELEBRATE',
                subtitle: 'Unforgettable Moments',
                height: isMobile ? 300 : 400,
              ),
            ),

            // 2. CATEGORIES GRID
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48, 
                vertical: 48
              ),
              sliver: Consumer<EventsProvider>(
                builder: (context, eventsProvider, child) {
                  if (eventsProvider.isLoading && eventsProvider.categories.isEmpty) {
                     return const SliverToBoxAdapter(
                       child: SizedBox(
                         height: 200, 
                         child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))
                       )
                     );
                  }
                  
                  final events = eventsProvider.activeCategories;
                  
                  if (events.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          'No events found.', 
                          style: GoogleFonts.inter(color: Colors.white)
                        )
                      )
                    );
                  }

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : 2, // 2 columns max for premium feel
                      childAspectRatio: isMobile ? 0.9 : 1.4, // Wider cards on desktop
                      mainAxisSpacing: 32,
                      crossAxisSpacing: 32,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        // Use a default image if empty, but preferably real images
                        final imageUrl = event.imageUrl.isNotEmpty 
                            ? event.imageUrl 
                            : 'https://via.placeholder.com/800x600?text=${event.name}';
                            
                        return EntryAnimation(
                          index: index,
                          child: LuxuryCard(
                            imageUrl: imageUrl,
                            title: event.name,
                            description: event.description.isNotEmpty 
                                ? event.description 
                                : 'Experience the magic of our ${event.name.toLowerCase()} packages.',
                            isLarge: true,
                            onTap: () {
                              // View Details
                              context.go('/event-packages/${event.id}');
                            },
                          ),
                        );
                      },
                      childCount: events.length,
                    ),
                  );
                },
              ),
            ),


            // 3. CTA SECTION
            const SliverToBoxAdapter(
              child: LuxuryCTASection(
                buttonTypes: [CTAButtonType.gallery, CTAButtonType.quote],
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
