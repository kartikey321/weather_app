import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackground extends StatefulWidget {
  final int weatherCode;
  final bool isDaytime;

  const VideoBackground({
    super.key,
    required this.weatherCode,
    required this.isDaytime,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  VideoPlayerController? _controller;
  // bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(VideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherCode != widget.weatherCode ||
        oldWidget.isDaytime != widget.isDaytime) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    // final oldController = _controller;
    
    // Determine video asset based on weather code
    // Note: Since we don't have actual assets yet, we'll use network placeholders
    // or comment out the asset loading to prevent runtime errors if files are missing.
    // For now, I'll set up the structure but fallback to a container if no video.
    
    // Recommended Video Assets (Royalty Free):
    // 
    // Sunny/Clear:
    // - https://www.videezy.com/nature/4328-sunny-day-sky-time-lapse
    // - https://www.videezy.com/sky/4738-blue-sky-and-clouds-timelapse
    //
    // Cloudy:
    // - https://www.videezy.com/sky/4306-clouds-moving-over-the-sky
    // - https://www.videezy.com/abstract/3983-white-clouds-flight-loop
    //
    // Rain:
    // - https://www.videezy.com/elements-and-effects/5328-rain-on-window-loop
    // - https://www.videezy.com/nature/3868-rain-falling-on-green-grass
    //
    // Snow:
    // - https://www.videezy.com/nature/3874-snow-falling-on-trees
    // - https://www.videezy.com/backgrounds/4862-falling-snow-overlay
    //
    // Thunderstorm:
    // - https://www.videezy.com/nature/3998-lightning-storm-in-clouds
    
    // String? assetPath;
    // Example mapping (commented out until assets exist):
    // if (widget.weatherCode < 3) {
    //   assetPath = widget.isDaytime ? 'assets/videos/sunny.mp4' : 'assets/videos/clear_night.mp4';
    // } else if (widget.weatherCode < 50) {
    //   assetPath = 'assets/videos/cloudy.mp4';
    // } else {
    //   assetPath = 'assets/videos/rain.mp4';
    // }

    // If we had a valid assetPath:
    /*
    if (assetPath != null) {
      final controller = VideoPlayerController.asset(assetPath);
      try {
        await controller.initialize();
        await controller.setLooping(true);
        await controller.play();
        if (mounted) {
          setState(() {
            _controller = controller;
            _initialized = true;
          });
        }
        oldController?.dispose();
      } catch (e) {
        debugPrint('Error loading video: $e');
      }
    }
    */
    
    // For now, since we don't have assets, we'll just leave it uninitialized
    // which will trigger the fallback gradient/color in the build method.
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && _controller!.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      );
    }

    // Fallback if video is not available (or not implemented yet)
    // This ensures the app still looks good without the actual video files
    return Container(); 
  }
}
