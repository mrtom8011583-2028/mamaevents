import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoBackground extends StatefulWidget {
  final String videoUrl;
  final bool playAudio;
  final double opacity;
  final bool isAsset;

  const VideoBackground({
    super.key,
    required this.videoUrl,
    this.playAudio = false,
    this.opacity = 1.0,
    this.isAsset = false,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isLoading = true;
  bool _userInteracted = false; // Track user interaction

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      print('🔄 Initializing video: ${widget.videoUrl}');
      print('📁 Is asset: ${widget.isAsset}');

      if (widget.isAsset) {
        _videoController = VideoPlayerController.asset(widget.videoUrl);
      } else {
        _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      }

      _videoController.addListener(() {
        if (_videoController.value.hasError && !_hasError) {
          // Only set error if user tried to play
          if (_userInteracted) {
            print('❌ Video error: ${_videoController.value.errorDescription}');
            setState(() {
              _hasError = true;
              _errorMessage = _videoController.value.errorDescription;
            });
          }
        }
      });

      await _videoController.initialize();

      print('✅ Video initialized successfully!');
      print('📏 Video dimensions: ${_videoController.value.size}');
      print('🎬 Video duration: ${_videoController.value.duration}');

      _videoController.setLooping(true);
      _videoController.setVolume(widget.playAudio ? 1.0 : 0.0);

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: false, // Don't autoplay - wait for user interaction
        looping: true,
        showControls: false,
        allowFullScreen: false,
        allowMuting: true,
      );

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });

    } catch (e) {
      print('❌ Video initialization error: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load video';
        _isLoading = false;
      });
    }
  }

  void _startVideo() {
    setState(() {
      _userInteracted = true;
    });

    try {
      _videoController.play();
    } catch (e) {
      print('❌ Play error: $e');
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show gradient background with play button until user interacts
    if (!_userInteracted) {
      return GestureDetector(
        onTap: () {
          if (_isInitialized) {
            _startVideo();
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0B0B0B),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  const CircularProgressIndicator(color: Color(0xFFC6A869))
                else if (_isInitialized)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC6A869).withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 48,
                      color: Color(0xFF0B0B0B),
                    ),
                  ),
                if (_isInitialized) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Tap to play video',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    if (_hasError) {
      return _buildErrorFallback();
    }

    if (!_isInitialized) {
      return _buildLoadingPlaceholder();
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: Opacity(
                opacity: widget.opacity,
                child: _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : VideoPlayer(_videoController),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFFC6A869)),
      ),
    );
  }

  Widget _buildErrorFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, size: 48, color: Color(0xFF8E8E8E)),
            const SizedBox(height: 16),
            Text(
              'Video unavailable',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
