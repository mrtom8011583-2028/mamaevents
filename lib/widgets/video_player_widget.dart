import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CateringVideoPlayer extends StatefulWidget {
  const CateringVideoPlayer({Key? key}) : super(key: key);

  @override
  State<CateringVideoPlayer> createState() => _CateringVideoPlayerState();
}

class _CateringVideoPlayerState extends State<CateringVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      // Initialize video controller
      _videoPlayerController = VideoPlayerController.asset(
        'assets/videos/background.mp4',
      );

      // Wait for video to initialize
      await _videoPlayerController.initialize();

      // Initialize Chewie for better controls
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        showControls: true,
        showControlsOnInitialize: false,
        allowFullScreen: true,
        allowMuting: true,
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Video not available',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.green,
          handleColor: Colors.green,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade300,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 250,
        color: Colors.black12,
        child: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    if (_errorMessage != null || _chewieController == null) {
      return Container(
        height: 250,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off, color: Colors.white, size: 50),
              SizedBox(height: 10),
              Text(
                'Premium Experience Video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'MAMA EVENTS - 15+ Years Event Excellence',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}