import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/event_package.dart';
import '../../../../core/services/event_service.dart';
import 'package:mama_events/features/admin/widgets/image_picker_widget.dart';
import '../../../../shared/widgets/base64_image.dart';

class AdminSubCategoriesScreen extends StatefulWidget {
  final String eventId;
  const AdminSubCategoriesScreen({super.key, required this.eventId});

  @override
  State<AdminSubCategoriesScreen> createState() => _AdminSubCategoriesScreenState();
}

class _AdminSubCategoriesScreenState extends State<AdminSubCategoriesScreen> {
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<EventCategory>>(
      stream: _eventService.getEventCategoriesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(appBar: AppBar(), body: Center(child: Text('Error: ${snapshot.error}')));
        }
        
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Find the specific category
        final categories = snapshot.data!;
        final eventIndex = categories.indexWhere((c) => c.id == widget.eventId);

        if (eventIndex == -1) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Event Category Not Found')));
        }

        final event = categories[eventIndex];
        final subCategories = event.subCategories;

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
                  event.name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Manage Sub-Events (Small Boxes)',
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
                  onPressed: () => _showAddEditDialog(context, event),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Small Box'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6), // Blue
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: subCategories.isEmpty
              ? _buildEmptyState(context, event)
              : GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: subCategories.length,
                  itemBuilder: (context, index) {
                    final subCategory = subCategories[index];
                    return _buildSubCategoryCard(context, event, subCategory);
                  },
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, EventCategory event) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.layers_clear, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No Sub-Events in ${event.name} yet',
            style: GoogleFonts.inter(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showAddEditDialog(context, event),
            child: const Text('Create Small Box'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryCard(BuildContext context, EventCategory event, EventSubCategory subCategory) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
           context.go('/admin/events/${event.id}/sub-events/${subCategory.id}/packages');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (subCategory.imageUrl.isNotEmpty)
                    Base64Image(
                      base64String: subCategory.imageUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: Colors.blue[50],
                      child: Center(child: Text(subCategory.icon, style: const TextStyle(fontSize: 40))),
                    ),
                    
                  // Order Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        '#${subCategory.order}',
                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subCategory.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                           icon: const Icon(Icons.more_vert, size: 18),
                           onSelected: (value) {
                             if (value == 'edit') {
                               _showAddEditDialog(context, event, subCategory: subCategory);
                             } else if (value == 'delete') {
                               _confirmDelete(context, event, subCategory);
                             }
                           },
                           itemBuilder: (context) => [
                             const PopupMenuItem(value: 'edit', child: Text('Edit')),
                             const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                           ],
                        ),
                      ],
                    ),
                    Text(
                      subCategory.description,
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.inventory_2, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          '${subCategory.packages.length} Packages',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, EventCategory event, {EventSubCategory? subCategory}) {
    final nameController = TextEditingController(text: subCategory?.name ?? '');
    final descController = TextEditingController(text: subCategory?.description ?? '');
    final iconController = TextEditingController(text: subCategory?.icon ?? '🎉');
    final imageUrlController = TextEditingController(text: subCategory?.imageUrl ?? '');
    final orderController = TextEditingController(text: subCategory?.order.toString() ?? '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(subCategory == null ? 'Create Small Box (Sub-Event)' : 'Edit Small Box'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Mehndi'),
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: 'Emoji Icon', hintText: '🎉'),
                ),
                const SizedBox(height: 16),
                AdminImagePicker(
                  initialUrl: imageUrlController.text,
                  storagePath: 'sub_categories',
                  onImageUploaded: (val) => imageUrlController.text = val,
                ),
                TextFormField(
                  controller: orderController,
                  decoration: const InputDecoration(labelText: 'Display Order', hintText: '1, 2, 3...'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final id = subCategory?.id ?? nameController.text.toLowerCase().replaceAll(' ', '_');
                final newSub = EventSubCategory(
                  id: id,
                  name: nameController.text,
                  description: descController.text,
                  icon: iconController.text,
                  imageUrl: imageUrlController.text,
                  packages: subCategory?.packages ?? [], // Keep children!
                  order: int.tryParse(orderController.text) ?? 1,
                );

                // Update Logic
                // 1. Create shallow copy of subCategories list
                final updatedSubCategories = List<EventSubCategory>.from(event.subCategories);
                
                if (subCategory != null) {
                  // Edit existing
                  final index = updatedSubCategories.indexWhere((s) => s.id == subCategory.id);
                  if (index != -1) {
                    updatedSubCategories[index] = newSub;
                  }
                } else {
                  // Add new
                  updatedSubCategories.add(newSub);
                }

                // 2. Create updated EventCategory
                final updatedEvent = EventCategory(
                  id: event.id,
                  name: event.name,
                  description: event.description,
                  icon: event.icon,
                  color: event.color,
                  status: event.status,
                  imageUrl: event.imageUrl,
                  subCategories: updatedSubCategories, // ✅ Updated list
                );

                // 3. Save to DB
                await _eventService.saveEventCategory(updatedEvent);
                
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(subCategory == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, EventCategory event, EventSubCategory subCategory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Small Box?'),
        content: Text('Are you sure you want to delete "${subCategory.name}"? This will delete all packages inside it!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // Remove from list
              final updatedSubCategories = List<EventSubCategory>.from(event.subCategories);
              updatedSubCategories.removeWhere((s) => s.id == subCategory.id);

              // Update Parent
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
