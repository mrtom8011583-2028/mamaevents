import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_image.dart';

class LuxuryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String? price;
  final VoidCallback onTap;
  final bool isLarge;

  const LuxuryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onTap,
    this.price,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    // Large cards have taller images (e.g. for featured items or big packages)
    final double imageRatio = isLarge ? 0.6 : 0.55; 

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Dark card background
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Expanded(
                flex: (imageRatio * 100).round(),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image with BoxFit.cover
                      CustomImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
                      
                      // Slight gradient at bottom of image for text separation if needed
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Section
              Expanded(
                flex: ((1 - imageRatio) * 100).round(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: isLarge ? 20 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (price != null) ...[
                        Text(
                          price!,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD4AF37),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Flexible(
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
