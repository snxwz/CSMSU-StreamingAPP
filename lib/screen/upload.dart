import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadState();
}

class _UploadState extends State<UploadPage> {
  String? _videoUrl;
  String? _videoName;
  VideoPlayerController? _controller;
  String token = '';

  void _getSharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getSharedValue();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Center(
        child: _videoUrl != null
            ? _videoPreviewWidget()
            : const Text('No Video Selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        child: const Icon(Icons.upload_file),
      ),
    );
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  void _pickVideo() async {
    final videoUrl = await pickVideo();
    if (videoUrl != null) {
      _videoUrl = videoUrl;
      _initializeVideoPlayer();
    }
  }

  Future<String?> pickVideo() async {
    final picker = ImagePicker();
    XFile? videoFile;
    try {
      videoFile = await picker.pickVideo(source: ImageSource.gallery);
      _videoName = videoFile?.name;
      return videoFile?.path;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<void> _uploadVideo(String? videoPath) async {
    if (videoPath == null) {
      return;
    }
    final url = Uri.parse('http://116.204.180.51:8900/upload/hls/$token');
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('video', videoPath));
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video uploaded successfully'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video upload fail!'),
        ),
      );
    }
  }


  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoUrl!))
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
            Container(
              width: 400,  // Adjust these values as needed
              height: 400, // Adjust these values as needed
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _videoName ?? '', // Show the video name here
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _uploadVideo(_videoUrl);
                showToast("Video uploaded fail!", duration: Toast.lengthLong, gravity:  Toast.bottom);
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
