import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../appConfig.dart';
import '../components/bottom_bar.dart';
import '../components/input_field.dart';

class Success extends StatefulWidget {
  const Success({super.key, required this.title});

  final String title;

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {

  void redirectToLogin() {
    Navigator.pushNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: () {
              //     Navigator.pushNamed(context, "/home");
              //   },
              // )
          ),
          body: const Center(
            child: Text("Verification Succeeded."),
          ),
          bottomNavigationBar: const BottomBar(pageIndex: 3),
        );
  }
}
