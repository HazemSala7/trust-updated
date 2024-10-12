import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoSlider extends StatefulWidget {
  final String? url_video;
  const VideoSlider({Key? key, this.url_video}) : super(key: key);

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url_video ?? "https://www.w3schools.com/html/mov_bbb.mp4",
    );
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: true,
      showControls: true,
      placeholder: const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
