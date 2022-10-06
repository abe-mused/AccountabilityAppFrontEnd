import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class CreateCommunityWidget extends StatefulWidget {
  CreateCommunityWidget({super.key, required this.token});
  String token;

  @override
  State<CreateCommunityWidget> createState() => _CreateCommunityWidgetState();
}

class _CreateCommunityWidgetState extends State<CreateCommunityWidget> {
  TextEditingController userInput = TextEditingController();
  bool _success = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(
        child: Text(
          "Create a Community:",
          style: TextStyle(fontSize: 24),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: TextFormField(
          controller: userInput,
          style: const TextStyle(
            fontSize: 20,
          ),
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            focusColor: Colors.white,
            fillColor: Colors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Enter the name of your community",
          ),
        ),
      ),
      TextButton(
        onPressed: () async {
          //add name to db using the new_community_name variable
          bool tempSuccess = await postCommunity(userInput.text, widget.token);

          print("this should be after");
          setState(() {
            _success = tempSuccess;
            _error = !tempSuccess;
          });
        },
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
          onSurface: Colors.grey,
        ),
        child: Text(_success
            ? "Success!"
            : _error
                ? "Error!"
                : "Create Community"),
      ),
    ]);
  }

  Future<bool> postCommunity(String text, String token) async {
    developer.log("posting community with name $text and token '$token'");

    return await http.post(
      Uri.parse('https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community'),
      body: jsonEncode({
        "communityName": text,
      }),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then(
      (response) {
        developer.log("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        if (response.statusCode == 200) {
          print("Success!");
          return true;
        } else {
          return false;
        }
      },
    );

    // return false;
=======
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
