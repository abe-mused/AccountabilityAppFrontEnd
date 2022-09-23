import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return
    // Container(
    //   child: const Text("Yo you're in the Home Page"),
    // );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Text("Yo you're in the Home Page"),
      ),
    );
  }
}
