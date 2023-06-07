import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Chung Chi College',
  'New Asia College',
  'United College',
  'Shaw College',
  'S.H. Ho College',
  'CW Chu College',
  'Wu Yee Sun College',
  'Lee Woo Sing College',
];

class DropdownButtonExample extends StatefulWidget {
  final ValueChanged<String> onItemChange;

  const DropdownButtonExample({
    Key? key,
    required this.onItemChange,
  }) : super(key: key);
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
        widget.onItemChange(value!);
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
