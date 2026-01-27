import 'package:flutter/material.dart';

/// Custom shimmer loading widget for better loading states
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            highlightColor,
            baseColor,
          ],
        ),
      ),
    );
  }
}

/// Shimmer effect for card loading
class CardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const CardShimmer({
    super.key,
    this.width = 350,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF0F0F0),
      ),
    );
  }
}

/// Shimmer effect for list items
class ListItemShimmer extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;

  const ListItemShimmer({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          if (hasLeading)
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 120,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          if (hasTrailing)
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ],
      ),
    );
  }
}
