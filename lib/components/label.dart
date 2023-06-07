import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  const Label({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}