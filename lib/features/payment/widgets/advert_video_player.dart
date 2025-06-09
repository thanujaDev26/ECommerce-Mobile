import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdvertVideoPlayer extends StatefulWidget {

  final String videoPath;

  const AdvertVideoPlayer({super.key, required this.videoPath});

  @override
  State<AdvertVideoPlayer> createState() => _AdvertVideoPlayerState();
}

class _AdvertVideoPlayerState extends State<AdvertVideoPlayer> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPath.startsWith('http')
        ? VideoPlayerController.network(widget.videoPath)
        : VideoPlayerController.asset(widget.videoPath);
    _controller
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
        ) : const Center(child: CircularProgressIndicator(),);
  }
}
