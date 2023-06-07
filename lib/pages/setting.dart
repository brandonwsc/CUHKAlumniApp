import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../appConfig.dart';
import '../service/loginService.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final storage = const FlutterSecureStorage();
  late Future userData;
  bool isSubscribedAnnouncementNotification = false;
  bool isSubscribedPostNotification = false;

  Future<void> submit() async {
    updateUser();
  }

  Future updateUser() async {
    Map<String, dynamic> user = await getUser();
    int userId = user['id'];
    Uri url = Uri.http(apiDomain, 'api/users/$userId');
    String postObj = jsonEncode({
      'isSubscribedAnnouncementNotification':
          isSubscribedAnnouncementNotification,
      'isSubscribedPostNotification': isSubscribedPostNotification,
    });

    var token = await storage.read(key: 'token');
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: postObj);
    if (response.statusCode == 200) {
      reDirectToProfilePage();
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  void reDirectToProfilePage() {
    Navigator.pushNamed(context, "/profile");
  }

  @override
  void initState() {
    super.initState();
    userData = getUser().then((value) => {
          setState(() {
            isSubscribedAnnouncementNotification =
                value['isSubscribedAnnouncementNotification'];
            isSubscribedPostNotification =
                value['isSubscribedPostNotification'];
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => reDirectToProfilePage(),
            ),
          ),
          title: const Text("Setting"),
          actions: <Widget>[
            IconButton(
              onPressed: () => {submit()},
              icon: const Icon(Icons.check),
            )
          ],
        ),
        body: FutureBuilder(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.only(
                          left: 19,
                          right: 19,
                        ),
                        child: ListView(children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Notification of new announcement",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value:
                                          isSubscribedAnnouncementNotification,
                                      onChanged: (value) {
                                        setState(() {
                                          isSubscribedAnnouncementNotification =
                                              value;
                                        });
                                      },
                                      activeTrackColor: Colors.purple.shade200,
                                      activeColor: Colors.deepPurple.shade300,
                                      inactiveThumbColor:
                                          Colors.deepPurple.shade300,
                                      inactiveTrackColor:
                                          Colors.purple.shade200,
                                    ),
                                  ),
                              ]),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Notification of new reply",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                               Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: isSubscribedPostNotification,
                                    onChanged: (value) {
                                      setState(() {
                                        isSubscribedPostNotification = value;
                                      });
                                    },
                                    activeTrackColor: Colors.purple.shade200,
                                    activeColor: Colors.deepPurple.shade300,
                                    inactiveThumbColor:
                                        Colors.deepPurple.shade300,
                                    inactiveTrackColor: Colors.purple.shade200,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ])));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
