import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Optimized image widget with caching, placeholder, and fade-in animation
/// for fast loading across the app
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;
  final Widget? errorWidget;
  final bool showLoadingIndicator;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderColor,
    this.errorWidget,
    this.showLoadingIndicator = true,
  });

  /// Get optimized URL with width parameter for faster loading
  String get optimizedUrl {
    // If it's an Unsplash image, we can optimize it
    if (imageUrl.contains('unsplash.com')) {
      // Add width parameter for Unsplash to get smaller image
      final targetWidth = width?.toInt() ?? 800;
      if (imageUrl.contains('?')) {
        return '$imageUrl&w=$targetWidth&q=75';
      } else {
        return '$imageUrl?w=$targetWidth&q=75';
      }
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    Widget image = CachedNetworkImage(
      imageUrl: optimizedUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildLoadingPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: placeholderColor ?? const Color(0xFFF5F5F5),
        borderRadius: borderRadius,
      ),
      child: showLoadingIndicator
          ? const Center(
              child: _ShimmerEffect(),
            )
          : null,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: placeholderColor ?? const Color(0xFFF0F0F0),
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFFBDBDBD),
          size: 40,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Color(0xFFBDBDBD),
          size: 40,
        ),
      ),
    );
  }
}

/// Shimmer loading effect
class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect();

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Hero image with blur-up technique for faster perceived loading
class HeroImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final Widget? overlay;
  final BoxFit fit;

  const HeroImage({
    super.key,
    required this.imageUrl,
    this.height = 400,
    this.overlay,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Main Image with caching
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              fadeInDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => Container(
                color: const Color(0xFF212121).withOpacity(0.1),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF212121)),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF2E7D32).withOpacity(0.2),
                child: const Center(
                  child: Icon(Icons.image, size: 64, color: Colors.white54),
                ),
              ),
            ),
          ),
          // Overlay
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

/// Gallery thumbnail optimized for grid display
class GalleryThumbnail extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;

  const GalleryThumbnail({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  String get thumbnailUrl {
    if (imageUrl.contains('unsplash.com')) {
      // Get smaller thumbnail version
      if (imageUrl.contains('?')) {
        return '$imageUrl&w=400&q=70';
      }
      return '$imageUrl?w=400&q=70';
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 150),
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: borderRadius,
            ),
            child: const _ShimmerEffect(),
          ),
          errorWidget: (context, url, error) => Container(
            width: width,
            height: height,
            color: const Color(0xFFF5F5F5),
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: Color(0xFFBDBDBD),
            ),
          ),
        ),
      ),
    );
  }
}

/// Preload images for faster navigation
class ImagePreloader {
  static final ImagePreloader _instance = ImagePreloader._internal();
  factory ImagePreloader() => _instance;
  ImagePreloader._internal();

  final Set<String> _preloadedUrls = {};

  /// Preload a single image
  Future<void> preload(BuildContext context, String url) async {
    if (_preloadedUrls.contains(url)) return;
    
    try {
      await precacheImage(
        CachedNetworkImageProvider(url),
        context,
      );
      _preloadedUrls.add(url);
    } catch (e) {
      // Silently fail for preloading
    }
  }

  /// Preload multiple images
  Future<void> preloadAll(BuildContext context, List<String> urls) async {
    await Future.wait(
      urls.map((url) => preload(context, url)),
    );
  }
}
