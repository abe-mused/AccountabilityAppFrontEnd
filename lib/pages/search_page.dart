import 'package:flutter/material.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

class  SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
 
  @override
  State<SearchPage> createState() => SearchPageState();
}


class SearchPageState extends State<SearchPage>{
  int selected_icon = 1; 

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
    /*static*/ const List<Widget> pages = <Widget>[
      Icon(
      Icons.home,
      size: 75,
      ),
      Icon(
      Icons.search,
      size: 75,
      ),
      Icon(
      Icons.account_circle_rounded,
      size: 75,
      ),
    ];

   return Scaffold(
      appBar: AppBar(
        title: const Text("Search Community"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Search Community",
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 20),
          GetCommunityWidget(token: user?.idToken ?? "INVALID TOKEN"),
         TextButton(
            onPressed: () {
               Navigator.pushNamed(context, '/createCommunity');
            },
            child: const Text("Can't find a community? Create a community here!"),
          ),
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
          currentIndex: 1,
          onTap: iconSelector,
        ),
    );
  }
}