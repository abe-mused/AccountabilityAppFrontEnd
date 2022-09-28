import 'package:flutter/material.dart';
import 'package:linear/main.dart'; 
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/home_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/widgets/post.dart'; 
import 'package:linear/nonwidget_files/dummy_data.dart';
import 'package:linear/constants/apis.dart';

class  SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
 
  @override
  State<SearchPage> createState() => SearchPageState();
}


class SearchPageState extends State<SearchPage>{
  int selected_icon = 1; //variable for nav bar

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
              showSearch(
                context: context,
                delegate: DelegatingSearch()
              );
            },
            icon: const Icon(Icons.search),
            )
        ],
        ), 
        body: Center(
            child: TextButton(
            onPressed: () {
               Navigator.pushNamed(context, '/fifth');
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

class DelegatingSearch extends SearchDelegate {
  int found = 0;
  String foundCommunity = "";

  //dummy input to be replaced later:
  /**** 
  List<String> dummyInput = [
    "Spanish",
    "Leetcode",
    "Fitness"
  ];
  ****/

  //delete text in search bar
  @override 
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton( 
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

//exit search menu
 @override 
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back),
      );
  }

  //show search results
  @override 
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = []; 
    
    foundCommunity = getCommunity(query).toString();
    print(foundCommunity);
      if (foundCommunity.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(foundCommunity);
        print(foundCommunity);
      }
    
    /**** 
    if (foundCommunity == query) {
      matchQuery.add(foundCommunity);
    }
    ***/
   
    /*****
    for (var example in dummyInput) {
      if (example.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(example);
        found = 1;
      }
    ******/
    
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        //var result = matchQuery[index];
        var result = foundCommunity;
        return ListTile( 
          title: Text(result),
        );
      },
    );
  }

  //show suggestions for search
  @override 
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
     if (foundCommunity.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(foundCommunity);
        found = 1;
      }
    /****** 
    if (foundCommunity == query) {
      matchQuery.add(foundCommunity);
    }
    *******/

    /****** 
    for (var example in dummyInput) {
      if (example.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(example);
      }
    }
    ******/

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        //var result = matchQuery[index];
        var result = foundCommunity;
        return ListTile( 
          title: Text(result),
        );
      },
    );
  }
  
}