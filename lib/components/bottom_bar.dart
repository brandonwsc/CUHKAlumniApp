import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<BottomBar> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, "/home");
      }
      if (index == 1) {
        Navigator.pushNamed(context, "/forum");
      }
      if (index == 2) {
        Navigator.pushNamed(context, "/notification");
      }
      if (index == 3) {
        Navigator.pushNamed(context, "/profile");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: '',
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: '',
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face),
          label: '',
          backgroundColor: Colors.purple,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
