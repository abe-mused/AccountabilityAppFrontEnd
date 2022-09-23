import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/widgets/community_page.dart';
import 'package:linear/widgets/search_page.dart'; 
import 'package:linear/widgets/home_page.dart'; 
import 'package:linear/widgets/post.dart'; 

class  ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
 
  @override
  State<ProfilePage> createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage>{
  int selected_icon = 2; //variable for nav bar

  void iconSelector(int index) {
    if(index == 0){
      Navigator.pushNamed(context, '/'); 
      
    }
     if(index == 1){
      Navigator.pushNamed(context, '/second');  
      
    }
    if(index == 2){
      Navigator.pushNamed(context, '/third');  
      
    }
      setState(() {
      selected_icon = index;
    });
  }

  @override 
  Widget build(BuildContext context) {
    const List<Widget> pages = <Widget>[
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
        title: const Text("Profile"),
        ), 
        body: Center(
            child: const Text("Profile"),
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