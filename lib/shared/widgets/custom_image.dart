import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Color? color; // Added color parameter

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color, // Added color parameter
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildErrorPlaceholder();
    }

    Widget imageWidget;

    // 1. Base64 Image
    if (imageUrl.startsWith('data:image') || _isBase64(imageUrl)) {
      imageWidget = _buildBase64Image(context);
    } 
    // 2. Network Image (URL)
    else if (imageUrl.startsWith('http')) {
      imageWidget = _buildNetworkImage(context);
    }
    // 3. Asset Image (Fallback)
    else if (imageUrl.startsWith('assets')) {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        color: color, // Apply color
        colorBlendMode: color != null ? BlendMode.darken : null, // Apply blend mode
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } else {
      imageWidget = _buildErrorPlaceholder();
    }

    // Optimization: RepaintBoundary for complex images (especially Base64)
    imageWidget = RepaintBoundary(child: imageWidget);

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Widget _buildBase64Image(BuildContext context) {
    try {
      String base64String = imageUrl;
      if (imageUrl.contains(',')) {
        base64String = imageUrl.split(',').last;
      }
      
      final Uint8List bytes = base64Decode(base64String);
      
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        color: color, // Apply color
        colorBlendMode: color != null ? BlendMode.darken : null, // Apply blend mode
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    } catch (e) {
      // If decoding fails, show placeholder
      return _buildErrorPlaceholder();
    }
  }

  Widget _buildNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color, // Apply color
      colorBlendMode: color != null ? BlendMode.darken : null, // Apply blend mode
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => _buildErrorPlaceholder(),
    );
  }

  bool _isBase64(String str) {
    return str.length > 200 && !str.startsWith('http') && !str.startsWith('assets');
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
