import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/event_package.dart';
import '../../../../core/models/region.dart';
import '../../../../core/services/event_service.dart';
import 'package:mama_events/features/admin/widgets/image_picker_widget.dart';

class AdminPackageEditorScreen extends StatefulWidget {
  final String eventId;
  final String subId;
  final String packageId;

  const AdminPackageEditorScreen({
    super.key,
    required this.eventId,
    required this.subId,
    required this.packageId,
  });

  @override
  State<AdminPackageEditorScreen> createState() => _AdminPackageEditorScreenState();
}

class _AdminPackageEditorScreenState extends State<AdminPackageEditorScreen> {
  final EventService _eventService = EventService();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = true;
  String? _error;
  
  // Parent Data (needed for saving)
  EventCategory? _eventCategory;
  EventSubCategory? _subCategory;
  
  // Form State
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _minGuestsController;
  late TextEditingController _descController;
  late TextEditingController _subtitleController;
  late TextEditingController _imageUrlController;

  String _selectedTier = 'economy';
  PackageFeatures _features = PackageFeatures();
  MenuSections _menuSections = MenuSections();
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _minGuestsController = TextEditingController();
    _descController = TextEditingController();
    _subtitleController = TextEditingController();
    _imageUrlController = TextEditingController();
    
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _minGuestsController.dispose();
    _descController.dispose();
    _subtitleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final categories = await _eventService.getEventCategoriesStream().first;
      _eventCategory = categories.firstWhere((c) => c.id == widget.eventId);
      _subCategory = _eventCategory!.subCategories.firstWhere((s) => s.id == widget.subId);
      
      if (widget.packageId != 'new') {
        final package = _subCategory!.packages.firstWhere((p) => p.id == widget.packageId);
        
        // Populate Form
        _nameController.text = package.name;
        _descController.text = package.description;
        _subtitleController.text = package.subtitle;
        _imageUrlController.text = package.images.isNotEmpty ? package.images.first : package.imageUrl; // Prefer images list
        
        // Pricing
        final price = package.pricing.displayPrice ? package.pricing.pricePerPerson : (package.basePriceByRegion['PK'] ?? 0);
        _priceController.text = price > 0 ? price.toStringAsFixed(0) : '';
        _minGuestsController.text = package.pricing.minimumGuests > 50 ? package.pricing.minimumGuests.toString() : '50';
        
        _selectedTier = package.tier;
        _features = package.features;
        
        // Auto-Migrate Legacy Menu Items
        if (package.menuSections.allItems.isEmpty && package.menuItems.isNotEmpty) {
           // If new structure is empty but old legacy list exists, migrate it to "Main Course"
           _menuSections = MenuSections(mainCourse: List<String>.from(package.menuItems));
        } else {
           _menuSections = package.menuSections;
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(appBar: AppBar(), body: Center(child: Text(_error!)));

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
                  icon: const Icon(Icons.close_rounded, size: 24),
                  onPressed: () => context.pop(),
                  tooltip: 'Cancel and Close',
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.packageId == 'new' ? 'New Treasure Chest' : 'Edit Treasure Chest',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Refining the perfect event package',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _savePackage,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('SAVE PACKAGE'),
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
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildSectionHeader('Basic Info', Icons.info_outline),
                  _buildBasicInfoCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Menu Content', Icons.restaurant_menu),
                  _buildMenuEditorCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Features & Tags', Icons.verified),
                  _buildFeaturesCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF374151))),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Package Name', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTier,
                    decoration: const InputDecoration(labelText: 'Tier', border: OutlineInputBorder()),
                    items: ['economy', 'premium', 'royal'].map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
                    onChanged: (v) => setState(() => _selectedTier = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Subtitle / Tagline', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price (PKR)', prefixText: 'Rs ', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _minGuestsController,
                    decoration: const InputDecoration(labelText: 'Min Guests', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AdminImagePicker(
              initialUrl: _imageUrlController.text,
              storagePath: 'packages',
              onImageUploaded: (val) => _imageUrlController.text = val,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Bone-Free'),
              value: _features.boneFree,
              onChanged: (v) => setState(() => _features = PackageFeatures(boneFree: v, messFree: _features.messFree, grilled: _features.grilled, lowOil: _features.lowOil, ketoFriendly: _features.ketoFriendly)),
            ),
            SwitchListTile(
              title: const Text('Live BBQ (Grilled)'),
              value: _features.grilled,
              onChanged: (v) => setState(() => _features = PackageFeatures(boneFree: _features.boneFree, messFree: _features.messFree, grilled: v, lowOil: _features.lowOil, ketoFriendly: _features.ketoFriendly)),
            ),
            SwitchListTile(
              title: const Text('Mess-Free (Easy to Eat)'),
              value: _features.messFree,
              onChanged: (v) => setState(() => _features = PackageFeatures(boneFree: _features.boneFree, messFree: v, grilled: _features.grilled, lowOil: _features.lowOil, ketoFriendly: _features.ketoFriendly)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuEditorCard() {
    return Card(
      elevation: 0,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _buildMenuSectionEditor('Main Courses', _menuSections.mainCourse, (l) => _menuSections = MenuSections(mainCourse: l, rice: _menuSections.rice, starters: _menuSections.starters, bbqGrilled: _menuSections.bbqGrilled, sides: _menuSections.sides, desserts: _menuSections.desserts, breads: _menuSections.breads, beverages: _menuSections.beverages)),
          const Divider(),
          _buildMenuSectionEditor('Rice Items', _menuSections.rice, (l) => _menuSections = MenuSections(mainCourse: _menuSections.mainCourse, rice: l, starters: _menuSections.starters, bbqGrilled: _menuSections.bbqGrilled, sides: _menuSections.sides, desserts: _menuSections.desserts, breads: _menuSections.breads, beverages: _menuSections.beverages)),
           const Divider(),
          _buildMenuSectionEditor('BBQ & Grills', _menuSections.bbqGrilled, (l) => _menuSections = MenuSections(mainCourse: _menuSections.mainCourse, rice: _menuSections.rice, starters: _menuSections.starters, bbqGrilled: l, sides: _menuSections.sides, desserts: _menuSections.desserts, breads: _menuSections.breads, beverages: _menuSections.beverages)),
           const Divider(),
          _buildMenuSectionEditor('Desserts', _menuSections.desserts, (l) => _menuSections = MenuSections(mainCourse: _menuSections.mainCourse, rice: _menuSections.rice, starters: _menuSections.starters, bbqGrilled: _menuSections.bbqGrilled, sides: _menuSections.sides, desserts: l, breads: _menuSections.breads, beverages: _menuSections.beverages)),
           const Divider(),
          _buildMenuSectionEditor('Beverages', _menuSections.beverages, (l) => _menuSections = MenuSections(mainCourse: _menuSections.mainCourse, rice: _menuSections.rice, starters: _menuSections.starters, bbqGrilled: _menuSections.bbqGrilled, sides: _menuSections.sides, desserts: _menuSections.desserts, breads: _menuSections.breads, beverages: l)),
        ],
      ),
    );
  }
  
  Widget _buildMenuSectionEditor(String title, List<String> currentItems, Function(List<String>) onUpdate) {
    final controller = TextEditingController();
    
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${currentItems.length} items', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: currentItems.map((item) => Chip(
                  label: Text(item),
                  onDeleted: () {
                    final newList = List<String>.from(currentItems)..remove(item);
                    setState(() => onUpdate(newList));
                  },
                )).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Add $title item...',
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (val) {
                         if (val.isNotEmpty) {
                          final newList = List<String>.from(currentItems)..add(val);
                          setState(() => onUpdate(newList));
                          controller.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                       if (controller.text.isNotEmpty) {
                          final newList = List<String>.from(currentItems)..add(controller.text);
                          setState(() => onUpdate(newList));
                          controller.clear();
                        }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _savePackage() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final id = widget.packageId == 'new' 
          ? DateTime.now().millisecondsSinceEpoch.toString() 
          : widget.packageId;

      final newPackage = PackageTier(
        id: id,
        name: _nameController.text,
        tier: _selectedTier,
        tagline: _subtitleController.text,
        description: _descController.text,
        imageUrl: _imageUrlController.text,
        images: _imageUrlController.text.isNotEmpty ? [_imageUrlController.text] : [],
        
        pricing: PackagePricing(
          displayPrice: true,
          pricePerPerson: double.tryParse(_priceController.text) ?? 0,
          minimumGuests: int.tryParse(_minGuestsController.text) ?? 50,
        ),
        
        features: _features,
        menuSections: _menuSections,
        
        // Boilerplate/Defaults
        categoryId: widget.subId, // Approximate mapping
        status: 'active',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Deep Update Logic
      final event = _eventCategory!;
      final subCategory = _subCategory!;

      // 1. Package List update
      final updatedPackages = List<PackageTier>.from(subCategory.packages);
      final pIndex = updatedPackages.indexWhere((p) => p.id == id);
      if (pIndex != -1) {
        updatedPackages[pIndex] = newPackage;
      } else {
        updatedPackages.add(newPackage);
      }

      // 2. SubCategory List update
      final updatedSubCategories = List<EventSubCategory>.from(event.subCategories);
      final sIndex = updatedSubCategories.indexWhere((s) => s.id == subCategory.id);
      
      updatedSubCategories[sIndex] = EventSubCategory(
        id: subCategory.id,
        name: subCategory.name,
        description: subCategory.description,
        icon: subCategory.icon,
        imageUrl: subCategory.imageUrl,
        packages: updatedPackages, // ✅ Updated
      );

      // 3. Main Event Update
      final updatedEvent = EventCategory(
        id: event.id,
        name: event.name,
        description: event.description,
        icon: event.icon,
        color: event.color,
        status: event.status,
        imageUrl: event.imageUrl,
        subCategories: updatedSubCategories, // ✅ Updated
      );

      await _eventService.saveEventCategory(updatedEvent);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Treasure Chest Saved!')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
