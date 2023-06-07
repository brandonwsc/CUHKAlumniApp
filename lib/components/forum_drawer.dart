import 'package:flutter/material.dart';

class ForumDrawer extends StatelessWidget {
  const ForumDrawer({super.key, required this.onFindPostWithCategory});

  final void Function(int) onFindPostWithCategory;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade300,
                  Colors.purple.shade400,
                ],
                begin: const FractionalOffset(1.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
              color: Colors.purple,
            ),
            child: const Text(
              'Topic',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Career'),
            onTap: () {
              onFindPostWithCategory(1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('School Life'),
            onTap: () {
              onFindPostWithCategory(2);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.nightlife),
            title: const Text('Leisure'),
            onTap: () {
              onFindPostWithCategory(3);
              Navigator.of(context).pop();
            },          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('Sports'),
            onTap: () {
              onFindPostWithCategory(4);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
