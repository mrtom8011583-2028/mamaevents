import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/models/menu_item.dart';
import '../../../providers/app_config_provider.dart';
import '../../../widgets/advanced_quote_request_form.dart';

class MenuDetailDialog extends StatelessWidget {
  final MenuItem item;

  const MenuDetailDialog({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final price = item.getFormattedPrice(config.region);
    final isAvailable = item.isAvailableInRegion(config.region);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: _buildImage(),
                ),
                // Close Button
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                // Live Station Badge (if applicable)
                if (item.liveStation)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6D00),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.whatshot, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'LIVE STATION',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      item.category.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B5E20),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Item Name
                    Text(
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cuisine Type
                    if (item.cuisineType != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.cuisineType!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF616161),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      item.description,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF424242),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Dietary Tags
                    if (item.dietaryTags.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dietary Information',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: item.dietaryTags.map((tag) => _buildTag(tag)).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),

                    // Servings Info
                    if (item.servings != null)
                      _buildInfoRow(
                        Icons.group,
                        'Serves',
                        item.servings!,
                      ),
                    
                    // Preparation Time
                    _buildInfoRow(
                      Icons.timer,
                      'Preparation Time',
                      item.preparationTime,
                    ),

                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 24),

                    // Price & Availability
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF757575),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              price,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1B5E20),
                              ),
                            ),
                            if (item.servings != null)
                              Text(
                                'for ${item.servings}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF757575),
                                ),
                              ),
                          ],
                        ),
                        if (!isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Not available in ${config.region.name}',
                              style: GoogleFonts.inter(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // CTA Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isAvailable
                                ? () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: SizedBox(
                                          height: 800,
                                          width: 960,
                                          child: AdvancedQuoteRequestForm(
                                            packageName: item.name,
                                            basePricePerHead: item.isPricePerHead ? (item.prices['PK'] ?? 0) : 0,
                                            onSuccess: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Quote request for ${item.name} submitted!'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B5E20),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            icon: const Icon(Icons.request_quote),
                            label: Text(
                              'REQUEST QUOTE',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isAvailable
                                ? () async {
                                    final whatsappUrl = Uri.parse(
                                      config.getWhatsAppLink(
                                        message: 'Hi! I\'m interested in ordering ${item.name}. Can you provide more details?',
                                      ),
                                    );
                                    // Launch WhatsApp (requires url_launcher)
                                    // In production, add: await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF25D366),
                              side: const BorderSide(color: Color(0xFF25D366), width: 2),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.chat),
                            label: Text(
                              'WHATSAPP',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
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

  Widget _buildImage() {
    if (item.imageUrl.isNotEmpty) {
      return Image.network(
        item.imageUrl,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE0E0E0),
            const Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.liveStation ? Icons.restaurant : Icons.restaurant_menu,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              item.liveStation ? 'Live Station' : 'Menu Item',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    IconData icon;
    Color color;

    switch (tag.toLowerCase()) {
      case 'halal':
        icon = Icons.verified;
        color = const Color(0xFF1B5E20);
        break;
      case 'vegetarian':
        icon = Icons.eco;
        color = const Color(0xFF4CAF50);
        break;
      case 'vegan':
        icon = Icons.spa;
        color = const Color(0xFF66BB6A);
        break;
      case 'gluten-free':
        icon = Icons.no_meals;
        color = const Color(0xFFFF9800);
        break;
      default:
        icon = Icons.check_circle;
        color = const Color(0xFF616161);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF616161)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF212121),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
