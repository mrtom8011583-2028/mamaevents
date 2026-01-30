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
          body: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      onPressed: () => context.pop(),
                      tooltip: 'Back to Events',
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage Sub-Events (Small Boxes)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddEditDialog(context, event),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('ADD SUB-EVENT'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: subCategories.isEmpty
                    ? _buildEmptyState(context, event)
                    : GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    childAspectRatio: 1.0, // Consistent with events screen
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: subCategories.length,
                  itemBuilder: (context, index) {
                    final subCategory = subCategories[index];
                    return _buildSubCategoryCard(context, event, subCategory);
                  },
                ),
              ),
            ],
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
              flex: 5,
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
                      child: Center(child: Text(subCategory.icon, style: const TextStyle(fontSize: 32))),
                    ),
                    
                  // Order Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
                        ],
                      ),
                      child: Text(
                        '#${subCategory.order}',
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Material(
                          color: Colors.transparent,
                          child: PopupMenuButton<String>(
                             padding: EdgeInsets.zero,
                             constraints: const BoxConstraints(minWidth: 120),
                             icon: const Icon(Icons.more_vert, size: 18, color: Color(0xFF6B7280)),
                             onSelected: (value) {
                               if (value == 'edit') {
                                 _showAddEditDialog(context, event, subCategory: subCategory);
                               } else if (value == 'delete') {
                                 _confirmDelete(context, event, subCategory);
                               }
                             },
                             itemBuilder: (context) => [
                               const PopupMenuItem(
                                 value: 'edit',
                                 child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit', style: TextStyle(fontSize: 13))]),
                               ),
                               const PopupMenuItem(
                                 value: 'delete',
                                 child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 16), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red, fontSize: 13))]),
                               ),
                             ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subCategory.description,
                      style: GoogleFonts.inter(
                        fontSize: 11, 
                        color: const Color(0xFF6B7280),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey[100]!)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 14, color: Colors.blue[400]),
                          const SizedBox(width: 4),
                          Text(
                            '${subCategory.packages.length} Packages',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF4B5563)),
                          ),
                        ],
                      ),
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
