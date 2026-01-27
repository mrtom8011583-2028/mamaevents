import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LuxuryStickyTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const LuxuryStickyTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Or consistent background color
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: const Color(0xFFD4AF37),
        indicatorWeight: 3,
        labelColor: Colors.black, // Active color
        unselectedLabelColor: Colors.grey,
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: tabs.map((t) => Tab(text: t.toUpperCase())).toList(),
      ),
    );
  }
}
