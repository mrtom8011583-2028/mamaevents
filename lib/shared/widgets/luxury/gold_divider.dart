import 'package:flutter/material.dart';

class GoldDivider extends StatelessWidget {
  final double width;
  final double height;
  
  const GoldDivider({
    super.key,
    this.width = 60,
    this.height = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
