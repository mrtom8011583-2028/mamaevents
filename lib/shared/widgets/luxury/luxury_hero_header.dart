import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_image.dart';

class LuxuryHeroHeader extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final double height;
  
  const LuxuryHeroHeader({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          CustomImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4), // Darken for readability
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3), // Top gradient
                  Colors.transparent,
                  Colors.black.withOpacity(0.8), // Bottom gradient
                ],
              ),
            ),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD4AF37), // Gold
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
