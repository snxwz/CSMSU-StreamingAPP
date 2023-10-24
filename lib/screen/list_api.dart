import 'dart:convert';
import 'package:http/http.dart' as http;

class APIs {
  String title;
  String url;
  APIs({
    required this.title,
    required this.url
  });
  factory APIs.fromJson(Map<String, dynamic> json) => APIs(
      title: json['V_title'],
      url: json['url']);

}

Future <List<APIs>> getLists(token) async{
  print(token);
  final response = await http.get(Uri.parse('http://116.204.180.51:8900/get/hls/list/$token'));
  if(response.statusCode == 200){
    var jsonResponse = jsonDecode(response.body);
    List<APIs> apis = [];
    for(var i in jsonResponse){
      APIs api = APIs(title: i['V_title'], url: i['url']);
      apis.add(api);
    }
    return apis;
  } else {
    throw Exception('Failed to Load');
  }
}