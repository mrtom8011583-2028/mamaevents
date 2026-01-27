import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_config_provider.dart';
import '../core/models/region.dart';

/// Location Selector Widget
/// Shows Pakistan cities only
/// 
/// Pakistan: Wazirabad, Sialkot, Daska, Kamoke, Gujrat, Faisalabad, etc.
class LocationSelector extends StatefulWidget {
  final Function(String city)? onCitySelected;
  final String? initialCity;
  
  const LocationSelector({
    super.key,
    this.onCitySelected,
    this.initialCity,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    // Set initial city if provided
    _selectedCity = widget.initialCity;
  }

  @override
  Widget build(BuildContext context) {
    // Get Pakistan cities
    final configProvider = context.watch<AppConfigProvider>();
    final currentRegion = configProvider.config.region;
    final cities = currentRegion.cities;

    debugPrint('🗺️ LocationSelector building - Region: ${currentRegion.name}, Cities count: ${cities.length}');

    // Reset selected city if it's not in the current region's cities
    if (_selectedCity != null && !cities.contains(_selectedCity)) {
      debugPrint('⚠️ Selected city "$_selectedCity" not in ${currentRegion.name} cities. Resetting...');
      _selectedCity = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Location Icon
          const Icon(
            Icons.location_on,
            color: Color(0xFF212121), // Black
            size: 20,
          ),
          const SizedBox(width: 12),
          
          // Dropdown
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCity,
                hint: Text(
                  'Select City',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF757575),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF212121),
                  size: 20,
                ),
                isExpanded: true,
                items: cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      city,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newCity) {
                  if (newCity != null) {
                    setState(() {
                      _selectedCity = newCity;
                    });
                    debugPrint('📍 City selected: $newCity in ${currentRegion.name}');
                    
                    // Callback
                    if (widget.onCitySelected != null) {
                      widget.onCitySelected!(newCity);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact Location Selector (for app bar or small spaces)
class CompactLocationSelector extends StatefulWidget {
  final Function(String city)? onCitySelected;
  
  const CompactLocationSelector({
    super.key,
    this.onCitySelected,
  });

  @override
  State<CompactLocationSelector> createState() => _CompactLocationSelectorState();
}

class _CompactLocationSelectorState extends State<CompactLocationSelector> {
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    final configProvider = context.watch<AppConfigProvider>();
    final currentRegion = configProvider.config.region;
    final cities = currentRegion.cities;

    // Auto-reset if city not in current region
    if (_selectedCity != null && !cities.contains(_selectedCity)) {
      _selectedCity = null;
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedCity,
        hint: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              color: Color(0xFF212121),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'City',
              style: GoogleFonts.inter(
                color: const Color(0xFF212121),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF212121),
          size: 20,
        ),
        items: cities.map((String city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(
              city,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newCity) {
          if (newCity != null) {
            setState(() {
              _selectedCity = newCity;
            });
            if (widget.onCitySelected != null) {
              widget.onCitySelected!(newCity);
            }
          }
        },
      ),
    );
  }
}
