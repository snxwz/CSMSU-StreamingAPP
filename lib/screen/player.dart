import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerState();
}

class _PlayerState extends State<PlayerPage> {
  String? _videoUrl;
  VideoPlayerController? _controller;
  final TextEditingController _apiLinkController = TextEditingController();

  @override
  void dispose() {
    _controller?.dispose();
    _apiLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player from API'),
      ),
      body: Center(
        child: _videoUrl != null
            ? _videoPreviewWidget()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _apiLinkController,
                decoration: const InputDecoration(labelText: 'Enter API Link'),
              ),
            ),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text('Play Video'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideo() async {
    final apiLink = _apiLinkController.text;

    if (apiLink.isNotEmpty) {
      try {
        _videoUrl = await fetchVideoUrl(apiLink);
        if (_videoUrl != null) {
          _initializeVideoPlayer();
        }
      } catch (e) {
        print('$e');
      }
    }
  }

  Future<String?> fetchVideoUrl(String apiLink) async {
    final response = await http.get(apiLink as Uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load video URL');
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(_videoUrl!)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
      });
  }

  Widget _videoPreviewWidget() {
    if (_controller != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ],
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
