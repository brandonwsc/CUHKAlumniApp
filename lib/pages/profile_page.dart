import 'package:flutter/material.dart';
import 'package:frontend/appConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../components/bottom_bar.dart';
import '../components/forum_card.dart';
import '../service/loginService.dart';
import 'all_pages.dart';
import 'dart:convert' as convert;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  late Future userData;
  late Future futurePost;

  void checkIsLoggedIn() async {
    var token = await storage.read(key: 'token');
    // print(token);
    if (token == null) {
      reDirectToLoginPage();
    }
  }

  void reDirectToLoginPage() {
    Navigator.pushNamed(context, "/login");
  }

  void reDirectToSettingPage(){
    Navigator.pushNamed(context, "/setting");
  }

  void logout() {
    clearToken();
    Navigator.pushNamed(context, "/home");
  }

  void clearToken() async {
    await storage.delete(key: 'token');
  }

  Future getPost() async {
    var userId = await storage.read(key: 'userId');
    var url = Uri.http(apiDomain, 'api/posts', {
      'populate': '*',
      'filters[user][id][\$eq]': userId,
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['data'];
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    userData = getUser();
    futurePost = getPost();
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
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool haveIcon = false;
            bool haveDesc = false;
            var photoUrl = '';
            int followersNum = 0;
            int followingsNum = 0;
            var followers = followersNum.toString();
            var followings = followingsNum.toString();

            if (snapshot.data['icon'] != null) {
              haveIcon = true;
              photoUrl = snapshot.data['icon']['url'];
            }
            if (snapshot.data['followers'] != null) {
              followersNum = snapshot.data['followers'].length;
              followers = followersNum.toString();
            }
            if (snapshot.data['following'] != null) {
              followingsNum = snapshot.data['following'].length;
              followings = followingsNum.toString();
            }
            if (snapshot.data['description'] != null && snapshot.data['description'] != '') {
              haveDesc = true;
            }
            return ListView(children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            // open camera / upload image
                          },
                          child: haveIcon
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      "http://$apiDomain$photoUrl"),
                                )
                              : const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('assets/icon.png'),
                                ),
                        ),
                        Expanded(child: Container()),
                        //
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, __, ___) =>
                                    UserListingPage(
                                        title: 'Followers',
                                        userList: snapshot.data['followers']),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Text('Followers',
                                  style: TextStyle(fontSize: 16)),
                              Text(followers,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, __, ___) =>
                                    UserListingPage(
                                        title: 'Followings',
                                        userList: snapshot.data['following']),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Text('Followings',
                                  style: TextStyle(fontSize: 16)),
                              Text(followings,
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      left: 5,
                                      bottom: 5,
                                    ),
                                    child: Text(
                                        snapshot.data['firstName'] +
                                            ' ' +
                                            snapshot.data['lastName'],
                                        style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width *
                                        0.803,
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                            snapshot.data['graduationYear']
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                        const Text(" | ",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                        Text(snapshot.data['degree'],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                        const Text(" | ",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                        Text(snapshot.data['college'],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      left: 5,
                                    ),
                                    child: haveDesc
                                        ? Text(snapshot.data['description'],
                                            style:
                                                const TextStyle(fontSize: 16))
                                        : const Text('Description Not Yet Updated', style: TextStyle(color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ]))),
                    Row(children: [
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/edit");
                        },
                        style: OutlinedButton.styleFrom(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(18.0),
                            // ),
                            ),
                        child: const Text('Edit'),
                      ),
                      const SizedBox(width: 8)
                    ]),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            'Posts',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                    FutureBuilder(
                      future: futurePost,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.length > 0) {
                          return Column(
                            children:
                            List.generate(snapshot.data.length, (index) {
                              return ForumCard(
                                postId: snapshot.data[index]['id'],
                                userName: snapshot.data[index]['attributes']
                                ['user']['data']['attributes']['username'],
                                postTitle: snapshot.data[index]['attributes']
                                ['title'],
                                postContent: snapshot.data[index]['attributes']
                                ['content'],
                                likesNum: snapshot
                                    .data[index]['attributes']['likes']['data']
                                    .length,
                                commentsNum: snapshot
                                    .data[index]['attributes']['comments']
                                ['data']
                                    .length,
                              );
                            }),
                          );
                        } else if (snapshot.hasData) {
                          return const Text('No post yet');
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      endDrawer: Drawer(
        width: 180,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () => {reDirectToSettingPage()},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => {logout()},
            ),
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: true,
      bottomNavigationBar: const BottomBar(pageIndex: 3),
    );
  }
}
