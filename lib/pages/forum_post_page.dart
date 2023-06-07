import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/appConfig.dart';
import 'package:frontend/pages/forum_new_comment_page.dart';
import 'package:frontend/pages/profile_public.dart';
import '../components/love_button.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../service/loginService.dart';

class ForumPostPage extends StatefulWidget {
  const ForumPostPage({super.key, required this.postId});

  final int postId;

  @override
  State<ForumPostPage> createState() => _ForumPostPageState();
}

class _ForumPostPageState extends State<ForumPostPage> {
  late Future futurePost;
  late Future futureLike;
  int likeId = 0;
  bool isLiked = false;

  Future<void> checkIsLoggedIn() async {
    const storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token == null) {
      reDirectToLoginPage();
    }
  }

  void reDirectToLoginPage() {
    Navigator.pushNamed(context, "/login");
  }

  Future viewPost() async {
    Map<String, dynamic> queryParameters = {
      //'populate[likes][populate]': ['user'],
      'populate[likes]': ['*'],
      'populate[user][populate]': ['usernames'],
      'populate[comments][populate]': ['user'],
    };
    var url = Uri.http(apiDomain, 'api/posts/${widget.postId}/view', queryParameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse['data'];
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

  }

  Future getLike() async {
    const storage = FlutterSecureStorage();
    String? userIdStr = await storage.read(key: 'userId');
    int userId = userIdStr != null ? int.parse(userIdStr) : 0;
    Map<String, dynamic> post = await futurePost;
    Map<String, dynamic> queryParameters = {
      'filters[\$and][0][user][id][\$contains]': userId.toString(),
      'filters[\$and][1][post][id][\$contains]': [post['id'].toString()],
    };
    var url = Uri.http(apiDomain, 'api/likes', queryParameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse['data'].length != 0) {
        likeId = jsonResponse['data'][0]['id'];
      }
      return jsonResponse['data'];
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  void reload() {
    setState(() {
      futurePost = viewPost();
    });
  }

  Duration timeDiffFromNow(DateTime time) {
    DateTime now = DateTime.now();
    return now.difference(time);
  }

  String durationStr(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int hours = duration.inHours.remainder(24);
    if (hours == 0) return '${minutes}m';
    int days = duration.inDays;
    if (days == 0) return '${hours}h ${minutes}m';
    return '${days}d ${hours}h ${minutes}m';
  }

  String timeStr(DateTime time) {
    Duration timeDiff = timeDiffFromNow(time);
    //if (timeDiff.inHours < 24)
    return durationStr(timeDiff);
    //return DateFormat.yMd().add_jm().format(time);
  }

  @override
  void initState() {
    futureLike = getLike();
    futurePost = viewPost();
    super.initState();
    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, "/forum"),
          ),
          title: FutureBuilder(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data['attributes']['title']);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
          //backgroundColor: Colors.lightBlueAccent[400],
        ),
        body: ListView(children: <Widget>[
          FutureBuilder(
            future: Future.wait([
              futureLike,
              futurePost,
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: PostMainContentCard(
                    id: snapshot.data![1]['id'],
                    userId: snapshot.data![1]['attributes']['user']['data']['id'],
                    userName: snapshot.data![1]['attributes']['user']['data']
                        ['attributes']['username'],
                    createdBefore: timeStr(DateTime.parse(
                        snapshot.data![1]['attributes']['createdAt'])),
                    title: snapshot.data![1]['attributes']['title'],
                    content: snapshot.data![1]['attributes']['content'],
                    likesNum:
                        snapshot.data![1]['attributes']['likes']['data'].length,
                    commentsNum: snapshot
                        .data![1]['attributes']['comments']['data'].length,
                    reload: () {
                      reload();
                    },
                    loveButtonIsPressed: snapshot.data![0].length > 0,
                    postId: widget.postId,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
          FutureBuilder(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                        snapshot.data['attributes']['comments']['data'].length,
                        (index) {
                      return PostReplyCard(
                        id: snapshot.data['attributes']['comments']['data']
                            [index]["id"],
                        postId: snapshot.data['id'],
                        respondentId: snapshot.data['attributes']['comments']
                            ['data'][index]['attributes']['user']['data']['id'],
                        userName: snapshot.data['attributes']['comments']
                                ['data'][index]['attributes']['user']['data']
                            ['attributes']["username"],
                        createdBefore: timeStr(DateTime.parse(
                            snapshot.data['attributes']['comments']['data']
                                [index]['attributes']['createdAt'])),
                        content: snapshot.data['attributes']['comments']['data']
                            [index]['attributes']["content"],
                      );
                    }));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ]));
  }
}

class PostMainContentCard extends StatelessWidget {
  const PostMainContentCard({
    super.key,
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.createdBefore,
    required this.content,
    required this.likesNum,
    required this.commentsNum,
    required this.reload,
    required this.loveButtonIsPressed,
    required this.postId,
  });

  final int id;
  final int userId;
  final String userName;
  final String title;
  final String createdBefore;
  final String content;
  final int likesNum;
  final int commentsNum;
  final VoidCallback reload;
  final bool loveButtonIsPressed;
  final int postId;

  Future like() async {
    const storage = FlutterSecureStorage();
    String? userIdStr = await storage.read(key: 'userId');
    int userId = userIdStr != null ? int.parse(userIdStr) : 0;
    var likeObj = jsonEncode({
      'data': {
        "user": [userId],
        "post": [id],
      }
    });

    var url = Uri.http(apiDomain, 'api/likes');
    var response = await http.post(url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: likeObj);
    if (response.statusCode == 200) {
      reload();
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future deleteLike() async {
    List<dynamic> like = await getLike();
    if (like.isNotEmpty) {
      int likeId = like[0]['id'];
      var url = Uri.http(apiDomain, 'api/likes/$likeId');
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        reload();
      } else {
        throw Exception('Request failed with status: ${response.statusCode}.');
      }
    }
  }

  Future getLike() async {
    const storage = FlutterSecureStorage();
    String? userIdStr = await storage.read(key: 'userId');
    int userId = userIdStr != null ? int.parse(userIdStr) : 0;
    Map<String, dynamic> queryParameters = {
      'filters[\$and][0][user][id][\$contains]': userId.toString(),
      'filters[\$and][1][post][id][\$contains]': postId.toString()
    };
    var url = Uri.http(apiDomain, 'api/likes', queryParameters);
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
  Widget build(BuildContext context) {
    void onNameTapped(int userId, String username) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => ProfilePublic(userId: userId, title: username),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
    return Card(
        shadowColor: Colors.black,
        child: Container(
            padding: const EdgeInsets.all(9.0),
            child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Text(userName,
                          style: const TextStyle(
                              color: Colors.purple, fontSize: 14)),
                      onTap: () {
                        onNameTapped(userId, userName);
                      },
                    ),
                    const SizedBox(width: 30),
                    Text(createdBefore, style: const TextStyle(fontSize: 14))
                  ]),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerLeft, child: Text(content)),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(
                            Icons.favorite,
                          ),
                          Text(likesNum.toString()),
                          const SizedBox(width: 10),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, __, ___) =>
                                      ForumNewCommentPage(postId: id),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.message,
                            ),
                          ),
                          Text(commentsNum.toString()),
                        ]),
                    LoveButton(
                      normalColor: Colors.grey,
                      pressedColor: Colors.purple,
                      onPress: () {
                        like();
                      },
                      unPressed: () {
                        deleteLike();
                      },
                      isPressed: loveButtonIsPressed,
                    )
                  ]),
            ])));
  }
}

class PostReplyCard extends StatefulWidget {
  const PostReplyCard(
      {super.key,
      required this.id,
      required this.postId,
      required this.respondentId,
      required this.userName,
      required this.content,
      required this.createdBefore});

  final int id;
  final int postId;
  final int respondentId;
  final String userName;
  final String content;
  final String createdBefore;

  @override
  State<PostReplyCard> createState() => _PostReplyCardState();
}

class _PostReplyCardState extends State<PostReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.all(9.0),
            child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                        child: Text(widget.userName,
                            style: const TextStyle(
                                color: Colors.purple, fontSize: 14)),
                        onTap: () {}),
                    //const SizedBox(width: 30),
                    // LoveButton(
                    //     normalColor: Colors.grey,
                    //     pressedColor: Colors.purple,
                    //     onPress: () {},
                    //     unPressed: () {})
                  ]),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft, child: Text(widget.content)),
              const SizedBox(height: 8),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.createdBefore,
                      style: const TextStyle(fontSize: 14))),
            ])));
  }
}
