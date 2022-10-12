import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/home_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/widgets/post.dart'; 
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/constants/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';


class  SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
 
  @override
  State<SearchPage> createState() => SearchPageState();
}


class SearchPageState extends State<SearchPage>{
  int selected_icon = 1; //variable for nav bar

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

   /* static*/ const List<Widget> pages = <Widget>[
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
        title: const Text("Search"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/searchCommunity');  
            },
            icon: const Icon(Icons.search),
            )
        ],
        ), 
        body: Center(
            child: TextButton(
            onPressed: () {
               Navigator.pushNamed(context, '/createCommunity');
            },
            child: const Text("Can't find a community? Create a community here!"),
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

