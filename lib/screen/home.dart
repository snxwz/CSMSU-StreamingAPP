import 'package:flutter/material.dart';
import 'package:streaming_app/screen/list.dart';
import 'package:streaming_app/screen/player.dart';
import 'package:streaming_app/screen/upload.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _currentIndex = 0;
  final tabs = [ListPage(), UploadPage(), PlayerPage(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        iconSize: 35,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
              backgroundColor: Colors.greenAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.upload_file),
              label: 'Upload',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle),
              label: 'Player',
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
