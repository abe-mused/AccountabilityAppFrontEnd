import 'package:flutter/material.dart';
import 'package:linear/widgets/community_page.dart';
import 'package:linear/widgets/search_page.dart'; 
import 'package:linear/widgets/profile_page.dart'; 
import 'package:linear/widgets/home_page.dart'; 

//testing commit on macbook
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
       theme: ThemeData( 
        primarySwatch: Colors.green,
       ),
       home: HomePage(),
      );
  }
}
