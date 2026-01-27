import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/models/event_package.dart';
import '../providers/events_provider.dart';
import '../shared/widgets/custom_image.dart';

/// User-facing page showing event types for a category (e.g., Mehndi, Barat, Valima for Wedding)
class EventTypesScreen extends StatelessWidget {
  final String categoryId;

  const EventTypesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EventsProvider>(
        builder: (context, eventsProvider, child) {
          // ⚡ OPTIMIZED: Reading from cached data - no Firebase read needed
          final category = eventsProvider.getCategoryById(categoryId);

          if (category == null || category.id.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Category not found', style: GoogleFonts.inter(fontSize: 18)),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => context.go('/event-packages'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Categories'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Hero Header
              SliverToBoxAdapter(
                child: Container(
                  height: 250,
                  decoration: const BoxDecoration(color: Color(0xFF1a1a1a)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomImage(
                        imageUrl: _getCategoryImage(categoryId),
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.6),

                      ),
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Back Button
                            GestureDetector(
                              onTap: () => context.go('/event-packages'),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
                                  const SizedBox(width: 8),
                                  Text(
                                    'All Events',
                                    style: GoogleFonts.inter(color: const Color(0xFFD4AF37)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '${_getCategoryIcon(categoryId)} ${category.name}',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Choose your event type',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Event Type Cards
              SliverPadding(
                padding: const EdgeInsets.all(32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildEventTypeCard(context, category.subCategories[index]),
                    childCount: category.subCategories.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 64)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventTypeCard(BuildContext context, EventSubCategory subCategory) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/event-packages/$categoryId/${subCategory.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Text(
                subCategory.icon.isNotEmpty ? subCategory.icon : '🎉',
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                subCategory.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Tagline
              if (subCategory.tagline.isNotEmpty)
                Text(
                  subCategory.tagline,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (subCategory.description.isNotEmpty && subCategory.tagline.isEmpty)
                Text(
                  subCategory.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
              // Package Count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                ),
                child: Text(
                  '${subCategory.packages.length} Packages',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryIcon(String id) {
    switch (id) {
      case 'wedding': return '💍';
      case 'corporate': return '💼';
      case 'birthday': return '🎉';
      default: return '🎊';
    }
  }

  String _getCategoryImage(String id) {
    switch (id) {
      case 'wedding':
        return 'https://images.unsplash.com/photo-1519741497674-611481863552?w=1920&q=80';
      case 'corporate':
        return 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1920&q=80';
      case 'birthday':
        return 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=1920&q=80';
      default:
        return 'https://images.unsplash.com/photo-1529543544277-750e2ea87990?w=1920&q=80';
    }
  }
}
