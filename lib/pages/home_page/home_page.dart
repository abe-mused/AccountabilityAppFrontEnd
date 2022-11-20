import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/home_page/home_page_content.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    
    auth_util.getUserName().then((userName) {
      setState(() {
        _currentUsername = userName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Linear Home Page!"),
        elevation: 0.1,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _currentUsername != null?
          HomePageContent(username: _currentUsername!)
          : Container(),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
