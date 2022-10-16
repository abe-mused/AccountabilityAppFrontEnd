import 'package:flutter/material.dart';
import 'package:linear/pages/create_community.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected_icon = 0; 
  
  void iconSelector(int index) {
    if(index == 0){
      Navigator.pushNamed(context, '/home'); 
      
    }
     if(index == 1){
      Navigator.pushNamed(context, '/search');  
      
    }
    if(index == 2){
      Navigator.pushNamed(context, '/profile');  
      
    }
      setState(() {
    selected_icon = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    if (user == null || user.username == null) {
      print("User is null in the homePage, redirecting to sign in");
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print("User is not null in the homePage");
      print("name is ${user.username} email is ${user.email} name is ${user.name} token is ${user.idToken}");
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Linear Home Page!"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Hello ${user?.name}",
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 20),
          CreateCommunityWidget(token: user?.idToken ?? "INVALID TOKEN"),
          const SizedBox(height: 20),
          GetCommunityWidget(token: user?.idToken ?? "INVALID TOKEN"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.account_circle_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: 0,
          onTap: iconSelector,
        ),
    );
  }
}