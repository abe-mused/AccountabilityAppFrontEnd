import 'package:flutter/material.dart';

class LinearNavBar extends StatefulWidget {
  const LinearNavBar({super.key});

  @override
  State<LinearNavBar> createState() => _LinearNavBarState();
}

class _LinearNavBarState extends State<LinearNavBar> {
  int selected_icon = 0;

  void iconSelector(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/search');
    }
    if (index == 2) {
      Navigator.pushReplacementNamed(context, '/goals');
    }
    if (index == 3) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
    setState(() {
      selected_icon = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes_outlined),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
      currentIndex: selected_icon,
      onTap: iconSelector,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
