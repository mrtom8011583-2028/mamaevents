import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/event_package.dart';
import '../../../../core/services/event_service.dart';
import '../../../../shared/widgets/base64_image.dart';

class AdminPackagesListScreen extends StatefulWidget {
  final String eventId;
  final String subId;
  
  const AdminPackagesListScreen({
    super.key, 
    required this.eventId, 
    required this.subId
  });

  @override
  State<AdminPackagesListScreen> createState() => _AdminPackagesListScreenState();
}

class _AdminPackagesListScreenState extends State<AdminPackagesListScreen> {
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventCategory>>(
      stream: _eventService.getEventCategoriesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Scaffold(appBar: AppBar(), body: Center(child: Text('Error: ${snapshot.error}')));
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        // Resolve Hierarchy
        try {
          final categories = snapshot.data!;
          final event = categories.firstWhere((c) => c.id == widget.eventId);
          final subCategory = event.subCategories.firstWhere((s) => s.id == widget.subId);
          final packages = subCategory.packages;

          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
                onPressed: () => context.pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    '${subCategory.name} Packages',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1F2937),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Manage Treasure Chests',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/admin/events/${widget.eventId}/sub-events/${widget.subId}/packages/new'),
                    icon: const Icon(Icons.add_box),
                    label: const Text('Add Package'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9B037), // Gold
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            body: packages.isEmpty
                ? _buildEmptyState(context, subCategory)
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final package = packages[index];
                      return _buildPackageCard(context, event, subCategory, package);
                    },
                  ),
          );
        } catch (e) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Event or Sub-Category Not Found')));
        }
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, EventSubCategory subCategory) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.diamond_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No Packages Found',
            style: GoogleFonts.inter(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.go('/admin/events/${widget.eventId}/sub-events/${widget.subId}/packages/new'),
            child: const Text('Create First Treasure Chest'),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, EventCategory event, EventSubCategory subCategory, PackageTier package) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
               BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: (package.images.isNotEmpty || package.imageUrl.isNotEmpty)
              ? Base64Image(
                  base64String: package.images.isNotEmpty ? package.images.first : package.imageUrl,
                  borderRadius: BorderRadius.circular(8),
                )
              : const Icon(Icons.inventory, color: Colors.grey),
        ),
        title: Text(
          package.name,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (package.subtitle.isNotEmpty) Text(package.subtitle),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildBadge(package.tier, _getTierColor(package.tier)),
                const SizedBox(width: 8),
                Text(
                  'Rs ${package.basePriceByRegion['PK']?.toStringAsFixed(0) ?? '0'}',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(package.status == 'active' ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
              onPressed: () => _toggleStatus(event, subCategory, package),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => context.go('/admin/events/${widget.eventId}/sub-events/${widget.subId}/packages/edit/${package.id}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, event, subCategory, package),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'economy': return Colors.green[100]!;
      case 'premium': return Colors.purple[100]!;
      case 'royal': return Colors.amber[100]!;
      default: return Colors.grey[200]!;
    }
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _toggleStatus(EventCategory event, EventSubCategory subCategory, PackageTier package) async {
    // 1. Find indexes
    final subIndex = event.subCategories.indexWhere((s) => s.id == subCategory.id);
    final pkgIndex = subCategory.packages.indexWhere((p) => p.id == package.id);

    // 2. Clone structure
    final updatedSubCategories = List<EventSubCategory>.from(event.subCategories);
    final updatedPackages = List<PackageTier>.from(subCategory.packages);
    
    // 3. Update Package
    final updatedPackage = PackageTier(
      id: package.id,
      name: package.name,
      // ... Copy all other fields ...
      categoryId: package.categoryId,
      eventTypeId: package.eventTypeId,
      tier: package.tier,
      tagline: package.tagline,
      description: package.description,
      images: package.images,
      menuSections: package.menuSections,
      features: package.features,
      pricing: package.pricing,
      // Change Status
      status: package.status == 'active' ? 'inactive' : 'active',
      // Legacy params
      subtitle: package.subtitle,
      tierLevel: package.tierLevel,
      isMostPopular: package.isMostPopular,
      basePriceByRegion: package.basePriceByRegion,
      featuresLegacy: package.featuresLegacy,
      idealFor: package.idealFor,
      servingCapacity: package.servingCapacity,
      menuItems: package.menuItems,
      imageUrl: package.imageUrl,
      tags: package.tags,
    );
    
    updatedPackages[pkgIndex] = updatedPackage;
    
    // 4. Update SubCategory
    updatedSubCategories[subIndex] = EventSubCategory(
      id: subCategory.id,
      name: subCategory.name,
      description: subCategory.description,
      icon: subCategory.icon,
      imageUrl: subCategory.imageUrl,
      packages: updatedPackages,
    );

    // 5. Update Event
    final updatedEvent = EventCategory(
      id: event.id,
      name: event.name,
      description: event.description,
      icon: event.icon,
      color: event.color,
      status: event.status,
      imageUrl: event.imageUrl,
      subCategories: updatedSubCategories,
    );

    await _eventService.saveEventCategory(updatedEvent);
  }

  Future<void> _confirmDelete(BuildContext context, EventCategory event, EventSubCategory subCategory, PackageTier package) async {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Package?'),
        content: Text('Are you sure you want to delete "${package.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
               // 1. Find indexes
                final subIndex = event.subCategories.indexWhere((s) => s.id == subCategory.id);
                
                // 2. Clone structure
                final updatedSubCategories = List<EventSubCategory>.from(event.subCategories);
                final updatedPackages = List<PackageTier>.from(subCategory.packages);
                
                // 3. Remove Package
                updatedPackages.removeWhere((p) => p.id == package.id);
                
                // 4. Update SubCategory
                updatedSubCategories[subIndex] = EventSubCategory(
                    id: subCategory.id,
                    name: subCategory.name,
                    description: subCategory.description,
                    icon: subCategory.icon,
                    imageUrl: subCategory.imageUrl,
                    packages: updatedPackages,
                );

                // 5. Update Event
                final updatedEvent = EventCategory(
                    id: event.id,
                    name: event.name,
                    description: event.description,
                    icon: event.icon,
                    color: event.color,
                    status: event.status,
                    imageUrl: event.imageUrl,
                    subCategories: updatedSubCategories,
                );

                await _eventService.saveEventCategory(updatedEvent);
                if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
