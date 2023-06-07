import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../appConfig.dart';
import '../components/bottom_bar.dart';
import 'package:http/http.dart' as http;

class UserListingPage extends StatefulWidget {
  const UserListingPage({super.key, required this.title, required this.userList});

  final String title;
  final List<dynamic> userList;
  @override
  State<UserListingPage> createState() => _UserListingPageState();
}

class _UserListingPageState extends State<UserListingPage> {

  void reDirectToLoginPage() {
    Navigator.pushNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
              children: List.generate(widget.userList.length, (index) {
                return UserCard(
                  title: widget.userList[index]['username'],
                );
              }),
            ),
      bottomNavigationBar: const BottomBar(pageIndex: 1),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 5),
            ListTile(
              title: Text(title),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
