import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Base64Image extends StatelessWidget {
  final String base64String;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const Base64Image({
    super.key,
    required this.base64String,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (base64String.isEmpty) {
      return _buildPlaceholder();
    }

    try {
      // Check if it's a URL first
      if (base64String.startsWith('http')) {
        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image.network(
            base64String,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildShimmer();
            },
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          ),
        );
      }

      // Proceed as Base64
      String cleanBase64 = base64String;
      if (base64String.startsWith('data:image')) {
        cleanBase64 = base64String.split(',').last;
      }
      
      final bytes = base64Decode(cleanBase64);
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
    );
  }
}
