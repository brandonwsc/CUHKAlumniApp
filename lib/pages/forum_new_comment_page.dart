import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../appConfig.dart';
import 'forum_post_page.dart';

class ForumNewCommentPage extends StatefulWidget {
  const ForumNewCommentPage({super.key, required this.postId});

  final int postId;

  @override
  State<ForumNewCommentPage> createState() => _ForumNewCommentPageState();
}

class _ForumNewCommentPageState extends State<ForumNewCommentPage> {
  final TextEditingController _contentController = TextEditingController();
  late Future futureCategory;
  late String dropdownValue;

  bool _isContentEmpty = false;


  bool checkEmpty() {
    setState(() {
      _isContentEmpty = _contentController.text.isEmpty;
    });
    return _contentController.text.isNotEmpty;
  }

  Future<void> submit() async {
    if(checkEmpty()){
      const storage = FlutterSecureStorage();
      String? userIdStr = await storage.read(key: 'userId');
      int userId = userIdStr != null ? int.parse(userIdStr) : 0;
      postForumPost(userId,widget.postId,_contentController.text);
    }
  }

  void reDirectToPost(){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, __, ___) => ForumPostPage(postId: widget.postId),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }


  Future postForumPost(int userId, int postId,String content) async {
    var postObj = jsonEncode({
      'data': {
        "user": [userId],
        "post": [postId],
        'content': content,
      }
    });

    var url = Uri.http(apiDomain, 'api/comments');
    var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: postObj
    );
    if (response.statusCode == 200) {
      reDirectToPost();
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Comment"),
          actions: <Widget>[
            IconButton(
              onPressed: () => {submit()},
              icon: const Icon(Icons.check),
            )
          ],
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 19,
                  right: 19,
                ),
                child: ListView(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Content",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      errorText: _isContentEmpty ? 'Content shouldn\'t be empty' : null,
                      hintText: 'Enter your comment content',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    controller: _contentController,
                  ),
                ]))));
  }
}
