import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Arts',
  'Education',
  'Law',
  'Science',
  'Business Administration',
  'Engineering',
  'Medicine',
  'Social Science',
];

class FacultyDropdown extends StatefulWidget {
  final ValueChanged<String> onItemChange;

  const FacultyDropdown({
    Key? key,
    required this.onItemChange,
  }) : super(key: key);
  @override
  State<FacultyDropdown> createState() => _FacultyDropdownState();
}

class _FacultyDropdownState extends State<FacultyDropdown> {

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
