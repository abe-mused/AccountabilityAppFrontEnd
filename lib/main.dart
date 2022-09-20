import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Linear Accountability App'),
        ),
        body: const Center(
          child: Text('Yo, this is the Linear Accountability App'),
        ),
      ),
    );
  }
}
