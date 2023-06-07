import 'package:flutter/material.dart';
import '../pages/all_pages.dart';

class ForumCard extends StatelessWidget {
  const ForumCard(
      {super.key,
        required this.postId,
        required this.userName,
        required this.postTitle,
        required this.postContent,
        required this.likesNum,
        required this.commentsNum});

  final int postId;
  final String userName;
  final String postTitle;
  final String postContent;
  final int likesNum;
  final int commentsNum;

  @override
  Widget build(BuildContext context) {
    String shortenString(String str) {
      if (str.length > 56) {
        return "${str.substring(0, 56)}...";
      }
      return str;
    }

    void onCardTapped(int postId) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, __, ___) => ForumPostPage(postId: postId),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }

    return Card(
        child: InkWell(
            onTap: () {
              onCardTapped(postId);
            },
            child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Icon(Icons.favorite),
                              Text(likesNum.toString()),
                              const SizedBox(width: 10),
                              const Icon(Icons.comment),
                              Text(commentsNum.toString()),
                            ]),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                      Text(postTitle, style: const TextStyle(fontSize: 16)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(shortenString(postContent),
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade700)),
                    ),
                  ],
                ))));
  }
}