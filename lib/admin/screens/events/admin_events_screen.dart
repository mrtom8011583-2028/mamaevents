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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Events (Big Boxes)',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showAddEditDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC4899),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
      ),
      body: StreamBuilder<List<EventCategory>>(
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
              childAspectRatio: 1.2,
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
    );
  }

  Widget _buildEventCard(BuildContext context, EventCategory category) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/admin/events/${category.id}/sub-events'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Expanded(
              flex: 3,
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
                      child: Icon(category.icon, size: 64, color: Colors.white),
                    ),
                  
                  // Status Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: category.status == 'active' ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category.status.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                        '#${category.order}',
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                           icon: const Icon(Icons.more_vert, size: 20),
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
                               child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')]),
                             ),
                             PopupMenuItem(
                               value: 'toggle',
                               child: Row(children: [
                                 Icon(category.status == 'active' ? Icons.visibility_off : Icons.visibility, size: 18),
                                 const SizedBox(width: 8),
                                 Text(category.status == 'active' ? 'Hide' : 'Show')
                               ]),
                             ),
                             const PopupMenuItem(
                               value: 'delete',
                               child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 18), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))]),
                             ),
                           ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.layers, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          '${category.subCategories.length} Sub-Events',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6B7280)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.card_giftcard, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          '${category.totalPackages} Packages',
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
