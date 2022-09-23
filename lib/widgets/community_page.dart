import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/widgets/home_page.dart';
import 'package:linear/widgets/search_page.dart'; 
import 'package:linear/widgets/profile_page.dart'; 

class  CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);
 
  @override
  State<CommunityPage> createState() => CommunityPageState();
}


class CommunityPageState extends State<CommunityPage>{
  int selected_icon = 0; //variable for nav bar

  void iconSelector(int index) {
   /*******
    setState(() {
    selected_icon = index;
    });
    *******/
    selected_icon = index;
    if(selected_icon == 0){
      Navigator.pushNamed(context, '/');  
    }
     if(selected_icon == 1){
      Navigator.pushNamed(context, '/second');  
    }
    if(selected_icon == 2){
      Navigator.pushNamed(context, '/third');  
    }
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
        title: const Text("Community"),
        ), 
        body: Center(
            child: pages.elementAt(selected_icon),
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
