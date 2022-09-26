import 'package:flutter/material.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/search_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/pages/home_page.dart'; 


void main() {
  //runApp(const MyApp());
  runApp(MaterialApp( 
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage (),
      '/second': (context) => const SearchPage (),
      '/third': (context) => const ProfilePage (),
      '/fourth': (context) => const CommunityPage(),
      // '/fourth': (context) => const ProfileRoute (),
      //'fifth': (context) => const SettingsRoute (),
    },
    theme:  ThemeData(
        scaffoldBackgroundColor: Colors.green,
        primaryColor: Colors.green,
        fontFamily: 'Calibri',
        appBarTheme: AppBarTheme( 
          color: Color.fromARGB(255, 39, 87, 41),
        ),
    ), 
    ));
}

//StatelessWidget cannot use setState, StatefulWidget can
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      //TODO: When we add more widgets to this app that show the colors, add theme based on the
      //color palette we picked in this issue: https://github.com/abe-mused/AccountabilityAppFrontEnd/issues/7
       title: 'Linear Accountability App',
       theme:  ThemeData(
        scaffoldBackgroundColor: Colors.green,
        primaryColor: Colors.green,
        fontFamily: 'Calibri',

        ),
       home: const HomePage(),
      );
  }
}
