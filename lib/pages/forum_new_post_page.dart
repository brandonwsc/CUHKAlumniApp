import 'dart:convert';

import 'package:flutter/material.dart';

import '../appConfig.dart';
import '../components/input_field.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../service/loginService.dart';

class ForumNewPostPage extends StatefulWidget {
  const ForumNewPostPage({super.key});

  @override
  State<ForumNewPostPage> createState() => _ForumNewPostPageState();
}

class _ForumNewPostPageState extends State<ForumNewPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late Future futureCategory;
  late String dropdownValue;


  bool _isTitleEmpty = false;
  bool _isContentEmpty = false;


  bool checkEmpty() {
    setState(() {
      _isTitleEmpty = _titleController.text.isEmpty;
      _isContentEmpty = _contentController.text.isEmpty;
    });
    return _titleController.text.isNotEmpty&&_contentController.text.isNotEmpty;
  }

  Future<void> submit() async {
    if(checkEmpty()){
      Map<String, dynamic> user= await getUser();
      int userId=user['id'];
      postForumPost(userId, int.parse(dropdownValue),_titleController.text,_contentController.text);
    }
  }

  void reDirectToForumPage(){
    Navigator.pushNamed(context, "/forum");
  }

  Future getCategory() async {
    var url = Uri.http(apiDomain, 'api/categories');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      dropdownValue=jsonResponse['data'][0]['id'].toString();
      return jsonResponse['data'];
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future postForumPost(int userId, int categoryId, String title,String content) async {
    var postObj = jsonEncode({
      'data': {
        "user": [userId],
        "category": [categoryId],
        'title': title,
        'content': content,
      }
    });

    var url = Uri.http(apiDomain, 'api/posts');
    var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: postObj
    );
    if (response.statusCode == 200) {
      reDirectToForumPage();
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
    }

  }

  @override
  void initState() {
    futureCategory = getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Post"),
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
                      "Category",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: futureCategory,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          width: 200,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: List.generate(snapshot.data.length, (index) {
                              return DropdownMenuItem<String>(
                                value: snapshot.data[index]['id'].toString(),
                                child: Text(snapshot.data[index]['attributes']
                                    ['title']),
                              );
                            }).toList(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Title",
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
                      errorText: _isTitleEmpty ? 'Title shouldn\'t be empty' : null,
                      hintText: 'Enter your post title',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    controller: _titleController,
                  ),
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
                      hintText: 'Enter your post content',
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
