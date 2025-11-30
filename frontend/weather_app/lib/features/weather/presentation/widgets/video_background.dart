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
  VideoPlayerController? _oldController;
  bool _visible = false;

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

  String _getVideoUrl() {
    // Verified working direct MP4 links (High Quality from Flixel)
    final Map<String, String> weatherVideos = {
      'sunnyDay': 'https://cdn.flixel.com/flixel/hlhff0h8md4ev0kju5be.hd.mp4',
      'starryNight': 'https://cdn.flixel.com/flixel/ypy8bw9fgw1zv2b4htp2.hd.mp4',
      'cloudy': 'https://cdn.flixel.com/flixel/hrkw2m8eofib9sk7t1v2.hd.mp4',
      'rain': 'https://cdn.flixel.com/flixel/f0w23bd0enxur5ff0bxz.hd.mp4',
      'snow': 'https://cdn.flixel.com/flixel/psi1hhbsshcus8eumtr7.hd.mp4',
      'thunder': 'https://cdn.flixel.com/flixel/sbk5sc03j7vay52r3e4o.hd.mp4',
    };

    String videoKey;

    // Logic to select the correct video key
    if (widget.weatherCode <= 1) {
      videoKey = widget.isDaytime ? 'sunnyDay' : 'starryNight';
    } else if (widget.weatherCode <= 48) {
      videoKey = 'cloudy';
    } else if ((widget.weatherCode >= 51 && widget.weatherCode <= 67) ||
        (widget.weatherCode >= 80 && widget.weatherCode <= 82)) {
      videoKey = 'rain';
    } else if ((widget.weatherCode >= 71 && widget.weatherCode <= 77) ||
        (widget.weatherCode >= 85 && widget.weatherCode <= 86)) {
      videoKey = 'snow';
    } else if (widget.weatherCode >= 95) {
      videoKey = 'thunder';
    } else {
      videoKey = 'cloudy'; // Safe fallback
    }

    return weatherVideos[videoKey]!;
  }

  Future<void> _initializeVideo() async {
    final url = _getVideoUrl();

    // Prepare new controller
    final newController = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await newController.initialize();
      await newController.setLooping(true);
      await newController.setVolume(0); // Mute background video
      await newController.play();

      if (!mounted) {
        newController.dispose();
        return;
      }

      setState(() {
        _oldController = _controller;
        _controller = newController;
        _visible = false; // Start invisible for fade in
      });

      // Trigger fade in
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _visible = true;
          });
        }
      });

      // Dispose old controller after transition
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _oldController?.dispose();
          _oldController = null;
        }
      });
    } catch (e) {
      debugPrint('Error loading video: $e');
      newController.dispose();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _oldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Old video (fading out)
        if (_oldController != null && _oldController!.value.isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _oldController!.value.size.width,
                height: _oldController!.value.size.height,
                child: VideoPlayer(_oldController!),
              ),
            ),
          ),

        // New video (fading in)
        if (_controller != null && _controller!.value.isInitialized)
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),
          ),

        // Overlay gradient to ensure text readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
