import 'dart:html';

import 'package:flutter/material.dart';
//TESTING PUSH


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linear',
      //TODO: When we add more widgets to this app that show the colors, add theme based on the
      //color palette we picked in this issue: https://github.com/abe-mused/AccountabilityAppFrontEnd/issues/7
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'HomePage'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Linear Accountability App'),
        ),
        body: Center(
          child: TextButton(
          onPressed:() {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CommunityPage(title: 'CommunityPage');
          }));
          },
          child: const Text('Community Page'),
          ),
        ),
      );
  }
}

class CommunityPage extends StatelessWidget{
  const CommunityPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        ), 
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: const Text('Go Back to Home Page'),
          ),
        ),
    );
  }

}
