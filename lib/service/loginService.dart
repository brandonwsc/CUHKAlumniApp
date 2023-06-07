import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';
import 'dart:convert' as convert;

Future getUser() async {
  const storage = FlutterSecureStorage();
  var token = await storage.read(key: 'token');
  var url = Uri.http(apiDomain, 'api/users/me', {'populate':'*'});
  var response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse;
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}