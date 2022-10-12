import 'package:flutter/material.dart';
import 'package:linear/pages/create_community.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/main.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/widgets/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    int selected_icon = 0; //variable for nav bar

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


    if (user == null || user.username == null) {
      print("User is null in the homePage, redirecting to sign in");
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print("User is not null in the homePage");
      print("name is ${user.username} email is ${user.email} name is ${user.name} token is ${user.idToken}");
    }
    /*static*/ const List<Widget> pages = <Widget>[
      //index 0
      Icon(
      Icons.home,
      size: 75,
      ),
      //index 1
      Icon(
      Icons.search,
      size: 75,
      ),
      //index 2
      Icon(
      Icons.account_circle_rounded,
      size: 75,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${user?.name}"),
        elevation: 0.1,
      ),
      body: Center(
            child: ListView.builder(
          itemCount: dummy_data.totalPosts,
          itemBuilder: (BuildContext context, int index){
            return Post();
          }
          ),
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
          currentIndex: selected_icon,
          onTap: iconSelector,
        ),
    );
  }
}
