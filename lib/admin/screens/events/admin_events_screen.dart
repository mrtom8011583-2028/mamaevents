import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/event_package.dart';
import '../../../../core/services/event_service.dart';
import 'package:mama_events/features/admin/widgets/image_picker_widget.dart';
import '../../../../shared/widgets/base64_image.dart';

class AdminEventsScreen extends StatefulWidget {
  const AdminEventsScreen({super.key});

  @override
  State<AdminEventsScreen> createState() => _AdminEventsScreenState();
}

class _AdminEventsScreenState extends State<AdminEventsScreen> {
  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Event Categories',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage top-level event types (e.g. Weddings, Corporate)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddEditDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('ADD CATEGORY'),
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
            child: StreamBuilder<List<EventCategory>>(
        stream: _eventService.getEventCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                   const SizedBox(height: 16),
                   Text(
                     'No Events Found',
                     style: GoogleFonts.inter(fontSize: 18, color: Colors.grey),
                   ),
                   const SizedBox(height: 8),
                   ElevatedButton(
                     onPressed: () => _showAddEditDialog(context),
                     child: const Text('Create Your First Big Box'),
                   ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 1.0, // Made taller to avoid overflow
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildEventCard(context, category);
            },
          );
        },
      ),
    ),
  ],
),
    );
  }

  Widget _buildEventCard(BuildContext context, EventCategory category) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.go('/admin/events/${category.id}/sub-events'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Expanded(
              flex: 5, // Slightly larger image ratio
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (category.imageUrl.isNotEmpty)
                    Base64Image(
                      base64String: category.imageUrl,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: Color(category.color.value),
                      child: Icon(category.icon, size: 48, color: Colors.white),
                    ),
                  
                  // Status Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: category.status == 'active' ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category.status.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                        '#${category.order}',
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              flex: 4, // More room for text
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
                            category.name,
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
                             onSelected: (value) async {
                               if (value == 'edit') {
                                 _showAddEditDialog(context, category: category);
                               } else if (value == 'toggle') {
                                 await _eventService.toggleCategoryStatus(
                                   category.id, 
                                   category.status != 'active'
                                 );
                               } else if (value == 'delete') {
                                 _confirmDelete(context, category);
                               }
                             },
                             itemBuilder: (context) => [
                               const PopupMenuItem(
                                 value: 'edit',
                                 child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit', style: TextStyle(fontSize: 13))]),
                               ),
                               PopupMenuItem(
                                 value: 'toggle',
                                 child: Row(children: [
                                   Icon(category.status == 'active' ? Icons.visibility_off : Icons.visibility, size: 16),
                                   const SizedBox(width: 8),
                                   Text(category.status == 'active' ? 'Hide' : 'Show', style: const TextStyle(fontSize: 13))
                                 ]),
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
                      category.description,
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
                          Icon(Icons.layers_outlined, size: 12, color: Colors.blue[400]),
                          const SizedBox(width: 4),
                          Text(
                            '${category.subCategories.length} Sub-Events',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF4B5563)),
                          ),
                          const Spacer(),
                          Icon(Icons.inventory_2_outlined, size: 12, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${category.totalPackages} Pkgs',
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

  void _showAddEditDialog(BuildContext context, {EventCategory? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final descController = TextEditingController(text: category?.description ?? '');
    final imageUrlController = TextEditingController(text: category?.imageUrl ?? '');
    final orderController = TextEditingController(text: category?.order.toString() ?? '99');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Create Big Box (Event)' : 'Edit Big Box'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Event Name', hintText: 'e.g. Wedding'),
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Short description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                AdminImagePicker(
                  initialUrl: imageUrlController.text,
                  storagePath: 'events',
                  onImageUploaded: (val) => imageUrlController.text = val,
                ),
                const SizedBox(height: 16),
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
                final id = category?.id ?? nameController.text.toLowerCase().replaceAll(' ', '_');
                final newCategory = EventCategory(
                  id: id,
                  name: nameController.text,
                  description: descController.text,
                  imageUrl: imageUrlController.text,
                  subCategories: category?.subCategories ?? [], // Keep children!
                  status: category?.status ?? 'active',
                  order: int.tryParse(orderController.text) ?? 99,
                );
                
                await _eventService.saveEventCategory(newCategory);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(category == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, EventCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text('Are you sure you want to delete "${category.name}"? This will delete all sub-events and packages inside it!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _eventService.deleteEventCategory(category.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
