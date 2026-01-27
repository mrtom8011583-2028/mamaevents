import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LuxuryPriceTag extends StatelessWidget {
  final String price;
  final String? suffix;
  final bool isLarge;

  const LuxuryPriceTag({
    super.key,
    required this.price,
    this.suffix,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: price,
            style: GoogleFonts.inter(
              color: const Color(0xFFD4AF37),
              fontSize: isLarge ? 24 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (suffix != null)
            TextSpan(
              text: ' $suffix',
              style: GoogleFonts.inter(
                color: Colors.grey[500],
                fontSize: isLarge ? 14 : 12,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}
