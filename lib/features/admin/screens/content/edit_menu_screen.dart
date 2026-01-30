import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/event_package.dart';
import '../../../../core/models/menu_item.dart';
import '../../../../core/models/live_station_add_on.dart';
import '../../../../core/services/database_service.dart';
import '../../../../utils/database_seeder.dart';
import '../../../../shared/widgets/base64_image.dart';
import 'package:mama_events/features/admin/widgets/image_picker_widget.dart';

class EditMenuScreen extends StatefulWidget {
  const EditMenuScreen({super.key});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  final bool _isAdmin = FirebaseAuth.instance.currentUser?.email == 'wassamk44@gmail.com';
  bool _isSeeding = false;

  Future<void> _handleSeeding() async {
    setState(() => _isSeeding = true);
    await DatabaseSeeder.seedInitialData();
    if (mounted) {
      setState(() => _isSeeding = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database Seeded Successfully!'), backgroundColor: Colors.green),
      );
    }
  }


  void _showItemDialog({MenuItem? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(text: (item?.prices['PK'] ?? 0).toString());
    final catController = TextEditingController(text: item?.category ?? 'General');
    final descController = TextEditingController(text: item?.description ?? '');
    String? base64Image = item?.imageUrl;
    String? selectedCategory = item?.category ?? 'BBQ Specials';
    bool isPricePerHead = item?.isPricePerHead ?? false;
    bool isSaving = false; // Track saving state

    final categories = ['BBQ Specials', 'Traditional Rice', 'Live Tandoor', 'Desserts', 'Beverages'];

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss while saving
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(item != null ? 'Edit Item' : 'Add New Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 8),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price (PKR)'), keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: categories.contains(selectedCategory) ? selectedCategory : categories.first,
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => selectedCategory = v),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Price is Per Head'),
                  value: isPricePerHead,
                  activeColor: const Color(0xFFC9B037),
                  onChanged: (val) => setState(() => isPricePerHead = val),
                  contentPadding: EdgeInsets.zero,
                ),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 2),
                const SizedBox(height: 16),
                
                AdminImagePicker(
                  initialUrl: base64Image,
                  storagePath: 'menu_items',
                  onImageUploaded: (val) => setState(() => base64Image = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx), 
              child: const Text('Cancel')
            ),
            ElevatedButton(
              onPressed: isSaving ? null : () async {
                // Validate inputs
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter item name'), backgroundColor: Colors.orange),
                  );
                  return;
                }
                
                setState(() => isSaving = true);
                
                try {
                  final id = item?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
                  
                  final newItem = MenuItem(
                    id: id,
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    category: selectedCategory!,
                    imageUrl: base64Image ?? '',
                    prices: {'PK': double.tryParse(priceController.text) ?? 0},
                    regions: ['PK'],
                    available: true,
                    isPricePerHead: isPricePerHead,
                  );
                  
                  debugPrint('💾 Saving menu item: ${newItem.name} (ID: ${newItem.id}) to category: ${newItem.category}');
                  await DatabaseService().updateMenuItem(newItem);
                  debugPrint('✅ Menu item saved successfully!');
                  
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item != null ? "Updated" : "Added"} "${newItem.name}" successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint('❌ Error saving menu item: $e');
                  setState(() => isSaving = false);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to save: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
              ),
              child: isSaving 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await DatabaseService().deleteMenuItem(id);
              if (mounted) Navigator.pop(ctx);
            }, 
            child: const Text('Delete', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Live Stations', 'BBQ Specials', 'Traditional Rice', 'Live Tandoor', 'Desserts', 'Beverages', 'Appetizers', 'Main Course'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Manage Menu',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                if (_isSeeding)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  Row(
                    children: [
                      IconButton(
                         icon: const Icon(Icons.cloud_upload),
                         tooltip: 'Seed Initial Data',
                         onPressed: _handleSeeding,
                      ),
                      const SizedBox(width: 16),
                      if (_isAdmin)
                        ElevatedButton.icon(
                          onPressed: () => _showItemDialog(),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('ADD ITEM'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.filter_list, size: 20, color: Colors.grey),
                const SizedBox(width: 12),
                Text('Filter by Category:', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterOptions.contains(_selectedFilter) ? _selectedFilter : 'All',
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        items: _filterOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _selectedFilter = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(child: _buildMenuItemsList()),
        ],
      ),
    );
  }

  Widget _buildMenuItemsList() {
    return StreamBuilder<List<MenuItem>>(
      stream: DatabaseService().getMenuItemsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        
        final allItems = snapshot.data ?? [];
        
        // Filter Items
        final filteredItems = allItems.where((item) {
          if (_selectedFilter == 'All') return true;
          // Special handling for Live Stations if not explicitly categorized
          if (_selectedFilter == 'Live Stations') {
             return item.category == 'Live Stations' || item.liveStation;
          }
          return item.category == _selectedFilter;
        }).toList();

        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Items in "$_selectedFilter"'),
                const SizedBox(height: 16),
                if (allItems.isEmpty && !_isSeeding)
                  ElevatedButton(
                    onPressed: _handleSeeding,
                    child: const Text('Seed Initial Data'),
                  )
              ],
            ),
          );
        }
        
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filteredItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            final item = filteredItems[i];
            final price = item.prices['PK'] ?? 0;
            return Card(
              elevation: 2,
              child: ListTile(
                leading: Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                   child: item.imageUrl.isNotEmpty
                      ? Base64Image(base64String: item.imageUrl, borderRadius: BorderRadius.circular(4))
                      : const Icon(Icons.fastfood),
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${item.category} • $price PKR ${item.isPricePerHead ? '/head' : ''}'),
                trailing: _isAdmin ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Availability Toggle
                    Switch(
                      value: item.available,
                      activeColor: const Color(0xFFD4AF37),
                      onChanged: (val) async {
                        // Optimistic update handled by stream usually, but let's just push to DB
                        final updated = item.copyWith(available: val);
                        await DatabaseService().updateMenuItem(updated);
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showItemDialog(item: item)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDelete(item.id)),
                  ],
                ) : null,
              ),
            );
          },
        );
      },
    );
  }
}
