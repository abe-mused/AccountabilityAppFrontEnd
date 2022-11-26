import 'package:flutter/material.dart';
import 'package:linear/util/cognito/user_preferences.dart';

class LinearNavBar extends StatefulWidget {
  const LinearNavBar({super.key});

  @override
  State<LinearNavBar> createState() => _LinearNavBarState();
}

class _LinearNavBarState extends State<LinearNavBar> {
  int selectedIcon = 0;

  void iconSelector(int index) {
    
    UserPreferences().setActiveTab(index);

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
      selectedIcon = index;
    });
  }

@override
  void initState() {
    super.initState();
    
    UserPreferences().getActiveTab().then((value) {
      setState(() {
        selectedIcon = value;
      });
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
      currentIndex: selectedIcon,
      onTap: iconSelector,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
