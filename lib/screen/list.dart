import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:streaming_app/screen/list_api.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  String token = '';
  Future<List<APIs>>? apis;

  void _getSharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      apis = getLists(token);
    });
  }

  @override
  void initState() {
    super.initState();
    _getSharedValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API List')),
      body: Center(
        child: FutureBuilder<List<APIs>>(
          future: apis,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.video_collection),
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].url),
                    onTap: () {
                      // Copy the URL to the clipboard when ListTile is tapped
                      _copyToClipboard(snapshot.data![index].url);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Error: ${snapshot.error}'); // You can use a different loading indicator
            }
          },
        ),
      ),
    );
  }
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copied to clipboard'),
      ),
    );
  }
}
