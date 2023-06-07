import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/input_field.dart';
import '../appConfig.dart';
import 'all_pages.dart';
import '../components/bottom_bar.dart';
import '../components/forum_drawer.dart';
import '../components/forum_card.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key, required this.title});

  final String title;

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  bool showSearchBar = false;
  late Future futurePost;
  final TextEditingController _searchController = TextEditingController();

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

  Future findPostBySortMethod(sortMethod) async {
    var url = Uri.http(apiDomain, 'api/posts', {
      // 'sort': 'createdAt:DESC',
      'sort': '$sortMethod:DESC',
      'populate': ['user', 'likes', 'comments']
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



  Future searchPost(String text) async {
    var url = Uri.http(apiDomain, 'api/posts', {
      'populate': ['user', 'likes', 'comments'],
      'filters[\$or][0][title][\$contains]': text,
      'filters[\$or][1][user][username][\$contains]': text,
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

  Future getPostWithCategory(int categoryId) async {
    var url = Uri.http(apiDomain, 'api/posts', {
      'populate': '*',
      'filters[category][id][\$eq]': categoryId.toString(),
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

  void findPostWithCategory(int categoryId) {
    setState(() {
      futurePost = getPostWithCategory(categoryId);
    });
  }

  @override
  void initState() {
    futurePost = findPostBySortMethod("views");
    super.initState();
    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ForumDrawer(
        onFindPostWithCategory: (int categoryId) {
          findPostWithCategory(categoryId);
        },
      ),
      appBar: AppBar(
        leading: showSearchBar
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    showSearchBar = false;
                  });
                },
              )
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
        title: showSearchBar
            ? TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white),
                    fillColor: Colors.purple[300],
                    filled: true),
                onSubmitted: (value) {
                  setState(() {
                    futurePost = searchPost(_searchController.text);
                  });
                })
            : Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              if (showSearchBar) {
                if (_searchController.text.isNotEmpty) {
                  setState(() {
                    futurePost = searchPost(_searchController.text);
                  });
                } else {
                  setState(() {
                    showSearchBar = false;
                  });
                }
              } else {
                setState(() {
                  showSearchBar = true;
                });
              }
            },
            icon: const Icon(Icons.search),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Icon(
                Icons.sort,
                color: Colors.white,
              ),
              buttonPadding: const EdgeInsets.only(right:20),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.menuItems.length, 48),
              ],
              items: [
                ...MenuItems.menuItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  futurePost = findPostBySortMethod(value?.text);
                });
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 160,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.purple[300],
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.hasData&&snapshot.data.length>0) {
            return ListView(
              children: List.generate(snapshot.data.length, (index) {
                return ForumCard(
                  postId: snapshot.data[index]['id'],
                  userName: snapshot.data[index]['attributes']['user']['data']
                      ['attributes']['username'],
                  postTitle: snapshot.data[index]['attributes']['title'],
                  postContent: snapshot.data[index]['attributes']['content'],
                  likesNum: snapshot
                      .data[index]['attributes']['likes']['data'].length,
                  commentsNum: snapshot
                      .data[index]['attributes']['comments']['data'].length,
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: const BottomBar(pageIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/forumNewPost");
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
//
// class ForumCard extends StatelessWidget {
//   const ForumCard(
//       {super.key,
//       required this.postId,
//       required this.userName,
//       required this.postTitle,
//       required this.postContent,
//       required this.likesNum,
//       required this.commentsNum});
//
//   final int postId;
//   final String userName;
//   final String postTitle;
//   final String postContent;
//   final int likesNum;
//   final int commentsNum;
//
//   @override
//   Widget build(BuildContext context) {
//     String shortenString(String str) {
//       if (str.length > 56) {
//         return "${str.substring(0, 56)}...";
//       }
//       return str;
//     }
//
//     void onCardTapped(int postId) {
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, __, ___) => ForumPostPage(postId: postId),
//           transitionDuration: const Duration(seconds: 0),
//         ),
//       );
//     }
//
//     return Card(
//         child: InkWell(
//             onTap: () {
//               onCardTapped(postId);
//             },
//             child: Container(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(
//                           userName,
//                           style: const TextStyle(
//                               fontSize: 18,
//                               color: Colors.purple,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               const Icon(Icons.favorite),
//                               Text(likesNum.toString()),
//                               const SizedBox(width: 10),
//                               const Icon(Icons.comment),
//                               Text(commentsNum.toString()),
//                             ]),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child:
//                           Text(postTitle, style: const TextStyle(fontSize: 16)),
//                     ),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(shortenString(postContent),
//                           style: TextStyle(
//                               fontSize: 14, color: Colors.grey.shade700)),
//                     ),
//                   ],
//                 ))));
//   }
// }

class MenuItem {
  final String label;
  final IconData icon;
  final String text;
  const MenuItem({
    required this.label,
    required this.icon,
    required this.text,
  });
}

class MenuItems{
  static const List<MenuItem> menuItems = [view,date];

  static const view = MenuItem(label: 'View', icon: Icons.view_agenda, text:"views");
  static const date = MenuItem(label: 'Date', icon: Icons.date_range, text:"lastUpdatedAt");


   static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.white,
            size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

}
