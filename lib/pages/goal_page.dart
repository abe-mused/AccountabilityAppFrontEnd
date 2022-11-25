import 'package:flutter/material.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/goal_widget.dart';
import 'package:linear/util/apis.dart' as api;
 
enum sortingBy{Newest, Oldest, CompletionHigh, CompletionLow, CommunitiesAZ, CommunitiesZA  }
enum filteringBy{Open, Overdue, Finished, All}

// ignore: must_be_immutable
class GoalPage extends StatefulWidget {
 const GoalPage({super.key});
 
 
 @override
 State<GoalPage> createState() => GoalPageState();
}
 
class GoalPageState extends State<GoalPage> {
 
    List<dynamic> _allGoals= [];
    List<dynamic> _displayedGoals = [];
    String sortingBy = "Newest";
    String filteringBy= "Open";
    bool isSorting = true;

    TextEditingController searchInput = TextEditingController();

  List<dynamic> _searchResults = [];
  bool _isSearching = false;
 
 bool _isLoading = false;
 bool _isErrorFetchingGoals = false;
 
 @override
 void initState() {
   super.initState();
   fetchGoals();
 }
 
 fetchGoals() {
   setState(() {
         _isLoading = true;
   });
   api.getGoalsForGoalPage(context).then((response) {
     if (response['status'] == true) {
       setState(() {
         _allGoals = response['goals'];
         _isErrorFetchingGoals = false;
       });
     applyFilter(0);
     isSorting = true;
     setState(() {
         _isLoading = false;
      });
 
     } else {
       setState(() {
          _allGoals = [];
         _isLoading = false;
         _isErrorFetchingGoals = true;
       });
     }
   });
 }

filterExpression(Goal checkGoal, int value){
  if (value == 0) {
    filteringBy = "Open";
    return !checkGoal.isFinished;
  } else if (value == 1){
    filteringBy = "Overdue";
    return (!(checkGoal.isFinished) && (checkGoal.completedCheckIns >= checkGoal.checkInGoal));
  } else if (value == 2) {
    filteringBy = "Finshed";
    return checkGoal.isFinished;
  }
}

applyFilter(int value){
 //
  if(value == 3){
    filteringBy = "All";
    setState(() {
      _displayedGoals = _allGoals.toList();
    });
    return;
  }

  _displayedGoals.clear();
   if(_allGoals.isEmpty)
   return;

   Goal checkGoal = Goal.fromJson(_allGoals[0]);
      for(int i = 0; i < _allGoals.length; i++){
       checkGoal = Goal.fromJson(_allGoals[i]);
       if(filterExpression(checkGoal, value)){
            setState(() {
              _displayedGoals.add(_allGoals[i]);
           });
       }
     }
}

 findIncompleteSearchResults(){
  String community = "";
   if(searchInput.text.isEmpty) {
      return;
    }else{
      community = searchInput.text.toString().toLowerCase();
    }
  setState(() {
    _displayedGoals.clear();
    _isSearching = true;
    isSorting = false;
  });
   if(_allGoals.isEmpty)
   return;
   Goal checkGoal = Goal.fromJson(_allGoals[0]);
      for(int i = 0; i < _allGoals.length; i++){
       checkGoal = Goal.fromJson(_allGoals[i]);
       if((checkGoal.communityName).contains(community)){
            setState(() {
             _displayedGoals.add(_allGoals[i]);
           });
       }
     }
     setState(() {
    _isSearching = false;
  });
 }

findSearchResults(){
  String community = "";
   if(searchInput.text.isEmpty || _allGoals.isEmpty) {
    setState(() {
      _displayedGoals = _allGoals.toList();
    });
    return;
    }else{
      community = searchInput.text.toString().toLowerCase();
    }
  setState(() {
    _displayedGoals.clear();
    _isSearching = true;
    isSorting = false;
  });
  Goal checkGoal = Goal.fromJson(_allGoals[0]);
      for(int i = 0; i < _allGoals.length; i++){
       checkGoal = Goal.fromJson(_allGoals[i]);
       if((checkGoal.communityName) == community){
            setState(() {
             _displayedGoals.add(_allGoals[i]);
           });
       }
     }
     setState(() {
    _isSearching = false;
  });
 }

 applySort(int value){
  if (value == 0) {
      setState(() {
         _displayedGoals.sort((a, b) => b['creationDate'].compareTo(a['creationDate']));
         sortingBy = "Newest";
      });
    } else if (value == 1) {
      setState(() {
         _displayedGoals.sort((a, b) => a['creationDate'].compareTo(b['creationDate']));
         sortingBy = "Oldest";
      });
    } else if (value == 2) {
      setState(() {
         _displayedGoals.sort((a, b) => ((b['completedCheckIns']/b['checkInGoal'])).compareTo((a['completedCheckIns']/a['checkInGoal'])));
         sortingBy = "Completion↑"; 
      });
    } else if (value == 3) {
      setState(() {
         _displayedGoals.sort((a, b) => ((a['completedCheckIns']/a['checkInGoal'])).compareTo((b['completedCheckIns']/b['checkInGoal'])));
         sortingBy = "Completion↓"; 
      });
    } else if (value == 4){
      setState(() {
         _displayedGoals.sort((a, b) => a['community'].compareTo(b['community'])); 
         sortingBy = "Communities A to Z";
      });
    }else if (value == 5){
      setState(() {
         _displayedGoals.sort((a, b) => b['community'].compareTo(a['community']));
         sortingBy = "Communities Z to A";
      });
    }
 }
 
@override
 Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text("Goals"),
       ),
       drawer: Drawer(
        child: drawerSortAndSearch(context),
      ),
       body:  buildGoalsPageScreen(),
    bottomNavigationBar: const LinearNavBar(),
   );
 }

 drawerSortAndSearch(context){
  return ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 123,
            child:
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 38, 127, 41),
                ),
                child: Text('Goals', style: TextStyle(color: Colors.white)),
              ),
          ),
          ExpansionTile(
            title: const Text("Filter By:"),
            children: filterChildren(context)
          ),
           ExpansionTile(
            title: const Text("Sort By:"),
            children: sortChildren(context)
          ),
        ],
      );
}

 List<Widget> filterChildren(context) {
   return [
            TextButton(
              onPressed: () {
                applyFilter(0);
                Navigator.pop(context);
              },
              child: const Text('Open'),
            ),
            TextButton(
               onPressed: () {
                 applyFilter(1);
                Navigator.pop(context);
              },
              child: const Text('Overdue'),
            ),
            TextButton(
               onPressed: () {
                applyFilter(2);
                Navigator.pop(context);
              },
              child: const Text('Finished'),
            ),
            TextButton(
               onPressed: () {
                 applyFilter(3);
                Navigator.pop(context);
              },
              child: const Text('All'),
            ),
          ];
 }

 List<Widget> sortChildren(context) {
   return [
            TextButton(
              onPressed: () {
                applySort(0);
                Navigator.pop(context);
              },
              child: const Text('Newest'),
            ),
            TextButton(
               onPressed: () {
                applySort(1);
                Navigator.pop(context);
              },
              child: const Text('Oldest'),
            ),
            TextButton(
               onPressed: () {
                applySort(2);
                Navigator.pop(context);
              },
              child: const Text('Completion↑'),
            ),
            TextButton(
               onPressed: () {
                applySort(3);
                Navigator.pop(context);
              },
              child: const Text('Completion↓'),
            ),
             TextButton(
               onPressed: () {
                applySort(4);
                Navigator.pop(context);
              },
              child: const Text('Communities A to Z'),
            ),
             TextButton(
               onPressed: () {
                applySort(5);
                Navigator.pop(context);
              },
              child: const Text('Communities Z to A'),
            ),
          ];
 }
 
 buildGoalsPageScreen(){
   if (_isLoading) {
     return buildGoalsPageLoadingScreen();
   } else if (_isErrorFetchingGoals) {
     return buildGoalsPageErrorScreen();
   } else {
     return buildGoalsPageContent();
   }
 }
 
 buildGoalsPageLoadingScreen(){
   return
     Center(
       child: const CircularProgressIndicator()
     );
 }
 
 buildGoalsPageErrorScreen(){
   return const Scaffold(
       body: Center(
         child: Text(
           "We ran into an error trying to obtain the goals. \nPlease try again later.",
           textAlign: TextAlign.center,
         ),
       ),
     );
 }
 
 buildGoalsPageContent(){
   return
      Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
      const SizedBox(height: 10),
      buildSearchBar(),
      Row(children: [
        Spacer(),
        if(isSorting == true)
        Text("Showing ${filteringBy} goals sorted by ${sortingBy}"),
        Spacer(),
      ]),
       buildGoalsList(_displayedGoals),
     ],
    );
 }
 
  buildSearchBar(){
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: searchInput,
        onChanged: (String community){
              findIncompleteSearchResults();
            },
        style: const TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          hintText: "Search community name",
          suffixIcon: IconButton(
            icon: Container(
                padding: const EdgeInsets.all(5),
                child: !_isSearching? 
                  const Icon(Icons.search)
                  : const CircularProgressIndicator(),
              ),
            onPressed: (){
              findSearchResults();
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
 
 buildGoalsList(List tabGoals) {
     return
       Expanded(
         child: RefreshIndicator(
         onRefresh: () async {
           setState(() {
             _isLoading = true;
           });
           fetchGoals();
         },
         child: SingleChildScrollView(
           physics: const BouncingScrollPhysics(),
           child: Column(
             children: [
               ListView.builder(
                 physics: const NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemCount: tabGoals.length,
                 itemBuilder: (context, index) {
                   return GoalWidget(
                     goal: Goal.fromJson(tabGoals[index]),
                     onDelete: () { 
                       setState(() {
                       tabGoals.removeAt(index);
                     });
                     },
                     onFinish: () {
                       setState(() {
                       tabGoals.removeAt(index);
                       searchInput.clear();
                     });
                       fetchGoals();
                     },
                     onExtend: () {
                       setState(() {
                       _isLoading = true;
                       searchInput.clear();
                     });
                       fetchGoals();
                     }
                   );
                 },
               ),
         ],
       ),
     ),
     ),
   );
   }
}