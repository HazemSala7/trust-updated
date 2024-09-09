import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../Constants/constants.dart';

class VideoSlider extends StatefulWidget {
  final String? url_video;
  const VideoSlider({Key? key, this.url_video}) : super(key: key);

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  bool showControls = true;
  late Duration duration;
  late Duration position;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      "https:\/\/qadrs.com\/qadr_bakcend\/storage\/reels\/April2024\/hP9YuJgehrkDW5PG05rV.mp4",
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.addListener(() {
      setState(() {
        duration = _controller.value.duration;
        position = _controller.value.position;
        isPlaying = _controller.value.isPlaying;
      });
    });
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      isPlaying = !isPlaying;
    });
  }

  void _stopVideo() {
    setState(() {
      _controller.pause();
      _controller.seekTo(Duration.zero);
      isPlaying = false;
    });
  }

  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            if (showControls)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _stopVideo,
                        icon: Icon(
                          Icons.stop,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: _togglePlayPause,
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.red,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.black45,
                          ),
                        ),
                      ),
                      Text(
                        _formatDuration(position) +
                            '/' +
                            _formatDuration(duration),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      IconButton(
                        onPressed: () {
                          // Implement full-screen functionality
                        },
                        icon: Icon(
                          Icons.fullscreen,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!showControls)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: IconButton(
                    onPressed: _togglePlayPause,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
