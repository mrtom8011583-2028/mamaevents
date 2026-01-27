import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/cake_details.dart';

class CakeBuilderWidget extends StatefulWidget {
  final Function(CakeDetails) onChanged;

  const CakeBuilderWidget({super.key, required this.onChanged});

  @override
  State<CakeBuilderWidget> createState() => _CakeBuilderWidgetState();
}

class _CakeBuilderWidgetState extends State<CakeBuilderWidget> {
  String _selectedFlavor = 'Chocolate Fudge';
  double _weight = 2.0;
  final TextEditingController _messageController = TextEditingController();


  final List<String> _flavors = [
    'Chocolate Fudge',
    'Red Velvet',
    'Pineapple',
    'Lotus Biscoff',
    'Coffee',
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_updateDetails);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _updateDetails() {
    final details = CakeDetails(
      size: '${_weight.toStringAsFixed(1)} lbs',
      flavor: _selectedFlavor,
      design: _messageController.text.isNotEmpty ? _messageController.text : 'Standard',
    );
    widget.onChanged(details);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cake, color: Color(0xFFE91E63), size: 28), // Pink for easy ident
              const SizedBox(width: 12),
              Text(
                'Customize Your Cake',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF212121),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Included in your package! Customize it below.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 24),

          // 1. Flavor Selector
          Text(
            'Select Flavor',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _flavors.map((flavor) {
              final isSelected = _selectedFlavor == flavor;
              return ChoiceChip(
                label: Text(
                  flavor,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : const Color(0xFF424242),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFFE91E63),
                backgroundColor: const Color(0xFFF5F5F5),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedFlavor = flavor;
                    });
                    _updateDetails();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 2. Weight Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cake Weight',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF424242),
                ),
              ),
              Text(
                '${_weight.toStringAsFixed(1)} lbs',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE91E63),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFE91E63),
              inactiveTrackColor: const Color(0xFFF8BBD0),
              thumbColor: const Color(0xFFE91E63),
              overlayColor: const Color(0xFFE91E63).withOpacity(0.2),
            ),
            child: Slider(
              value: _weight,
              min: 2.0,
              max: 10.0,
              divisions: 16, // 0.5 steps
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
                _updateDetails();
              },
            ),
          ),
          const SizedBox(height: 24),

          // 3. Design / Theme
          Text(
            'Design / Theme',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'e.g. Spiderman theme, "Happy Birthday Ali"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
