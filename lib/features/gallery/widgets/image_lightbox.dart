import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/gallery_data.dart';

class ImageLightbox extends StatefulWidget {
  final List<GalleryImage> images;
  final int initialIndex;

  const ImageLightbox({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImageLightbox> createState() => _ImageLightboxState();
}

class _ImageLightboxState extends State<ImageLightbox> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.95),
        child: Stack(
          children: [
            // Main Image Display
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildImageView(widget.images[index]);
              },
            ),

            // Close Button
            Positioned(
              top: 40,
              right: 40,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),

            // Previous Button
            if (_currentIndex > 0)
              Positioned(
                left: 40,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _previousImage,
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 48),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),

            // Next Button
            if (_currentIndex < widget.images.length - 1)
              Positioned(
                right: 40,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _nextImage,
                    icon: const Icon(Icons.chevron_right, color: Colors.white, size: 48),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),

            // Image Info Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildImageInfo(widget.images[_currentIndex]),
            ),

            // Counter
            Positioned(
              top: 40,
              left: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.images.length}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageView(GalleryImage image) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: _buildImage(image),
      ),
    );
  }

  Widget _buildImage(GalleryImage image) {
    if (image.imageUrl.isNotEmpty) {
      return Image.network(
        image.imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(image),
      );
    }
    return _buildPlaceholder(image);
  }

  Widget _buildPlaceholder(GalleryImage image) {
    IconData icon;
    switch (image.category) {
      case 'Wedding':
        icon = Icons.favorite;
        break;
      case 'Corporate':
        icon = Icons.business_center;
        break;
      case 'Live Stations':
        icon = Icons.restaurant;
        break;
      case 'Outdoor':
        icon = Icons.sailing;
        break;
      default:
        icon = Icons.celebration;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade800,
            Colors.grey.shade900,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 120, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 24),
            Text(
              image.category,
              style: GoogleFonts.inter(
                fontSize: 20,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageInfo(GalleryImage image) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              image.category.toUpperCase(),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Title
          Text(
            image.title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Description
          Text(
            image.description,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          
          // Tags
          if (image.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: image.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    '#$tag',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
