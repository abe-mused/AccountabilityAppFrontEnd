import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/pages/home_page.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/search_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/widgets/post.dart'; 
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/pages/create_community.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

class  CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);
 
  @override
  State<CreatePostPage> createState() => CreatePostPageState();
}


class CreatePostPageState extends State<CreatePostPage>{
  int selected_icon = 1; //variable for nav bar
  TextEditingController userInput = TextEditingController();
  String text = "";
  String new_community_name = "";

  /****** 
  void disposeController() {
    userInput.dispose ();
    super.dispose();
  }
  *******/

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
          currentIndex: selected_icon,
          onTap: iconSelector,
        ),
    );
  }
}