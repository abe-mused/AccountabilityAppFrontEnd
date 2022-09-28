import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/pages/home_page.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/search_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/widgets/post.dart'; 
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/constants/apis.dart';

class  CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({Key? key}) : super(key: key);
 
  @override
  State<CreateCommunityPage> createState() => CreateCommunityPageState();
}


class CreateCommunityPageState extends State<CreateCommunityPage>{
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
        title: const Text("Create Community"),
        ), 
        body: Container(
          padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Text(
                "Input Community Name Below:",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: userInput,
                style: TextStyle(fontSize: 20,),
                
                onChanged: (value) {
                  setState(() {});
                 }, 
                
                decoration: InputDecoration ( 
                  focusColor: Colors.white,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            TextButton(
            onPressed: () {
               userInput.toString();
               new_community_name = userInput.toString();
               //print(new_community_name);
               //add name to db using the new_community_name variable
               postCommunity(new_community_name);
            },
            child: Text("Submit"),
            ),
          ],
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
