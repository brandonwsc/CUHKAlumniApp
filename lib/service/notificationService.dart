import 'dart:convert';
import 'dart:convert' as convert;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';

Future uploadFCMToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  const storage = FlutterSecureStorage();
  String? userId = await storage.read(key: 'userId');
  var postObj = jsonEncode({
    'data': {
      "user": [userId],
      'fcmToken': fcmToken,
    }
  });

  var url = Uri.http(apiDomain, 'api/fcm-tokens/upload');
  var token = await storage.read(key: 'token');

  var response = await http.post(url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: postObj);
  if (response.statusCode != 200) {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}
