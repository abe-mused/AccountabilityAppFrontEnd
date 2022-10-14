import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/pages/home_page.dart';
import 'package:linear/pages/search_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/widgets/scrolling_post_view.dart'; 
import 'package:linear/widgets/community_info_box.dart';

class  CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);
 
  @override
  State<CommunityPage> createState() => CommunityPageState();
}


class CommunityPageState extends State<CommunityPage>{
  int selected_icon = 2; 
  String com = "communityName";
  String day = "dayCreated";

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
          currentIndex: 2,
          onTap: iconSelector,
        ),
       
    );
  }
}