import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../appConfig.dart';
import '../components/bottom_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.title});

  final String title;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future futureNotification;

  Future<void> checkIsLoggedIn() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token == null) {
      reDirectToLoginPage();
    }
  }

  Future viewNotification() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    String? userIdStr = await storage.read(key: 'userId');
    var url = Uri.http(apiDomain, 'api/notifications', {
      'populate': '*',
      'filters[user][id][\$contains]': userIdStr,
    });
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['data'];
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  void reDirectToLoginPage() {
    Navigator.pushNamed(context, "/login");
  }

  @override
  void initState() {
    futureNotification = viewNotification();
    super.initState();
    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: futureNotification,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView(
              children: List.generate(snapshot.data.length, (index) {
                return NotificationCard(
                  title: snapshot.data[index]['attributes']['title'],
                  subtitle: snapshot.data[index]['attributes']['content'],
                );
              }),
            );
          } else if (snapshot.hasData && snapshot.data.length == 0) {
            return const Center(
              child: Text('You have no notification'),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 2),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 5),
            ListTile(
              trailing: const Icon(Icons.album),
              title: Text(title),
              subtitle: Text(subtitle),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
