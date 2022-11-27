import 'package:flutter/material.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/pages/common_widgets/error_screen.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/goal_widget.dart';
import 'package:linear/util/apis.dart' as api;
 
enum SortType { newest, oldest, completionAscending, completionDescending, communitiesAtoZ, communitiesZtoA }
enum FilterType { open, overdue, finished, all }
class GoalPage extends StatefulWidget {
 const GoalPage({super.key});
 
 
 @override
 State<GoalPage> createState() => GoalPageState();
}
 
class GoalPageState extends State<GoalPage> {

  List<Goal> _allGoals= [];
  List<Goal> _searchResults = [];
  List<Goal> _displayedGoals = [];
  
  SortType _sortType = SortType.newest;
  FilterType _filterType= FilterType.open;

  TextEditingController searchInput = TextEditingController();
  String _searchQuery = ''; // this will be used to prevent searchbar from accidentally resetting filters & sorting

  bool _isLoading = false;
  bool _isErrorFetchingGoals = false;
 
  @override
  void initState() {
    super.initState();
    fetchGoals();
  }
 
 Future<void> fetchGoals({bool showSpinner = true}) async {
  searchInput.clear();
  if(showSpinner) {
    setState(() {
      _isLoading = true;
    });
  }
  
  Map<String, dynamic> response = await api.getGoalsForGoalPage(context);
  
  if (response['status'] == true) {
    List<Goal> tempGoalList = [];
    for(int i = 0; i < response['goals'].length; i++){
      tempGoalList.add(Goal.fromJson(response['goals'][i]));
    }
    setState(() {
      _allGoals = tempGoalList;
      _searchResults = tempGoalList;
      _isErrorFetchingGoals = false;
      _isLoading = false;
    });
    applyFilterAndSort();
  } else {
    setState(() {
      _allGoals = [];
      _searchResults = [];
      _displayedGoals = [];
      _isLoading = false;
      _isErrorFetchingGoals = true;
    });
  }
 }

  filterExpression(Goal checkGoal){
    if (_filterType == FilterType.open) {
      return !checkGoal.isFinished;
    } else if (_filterType == FilterType.overdue){
      return (!(checkGoal.isFinished) && (checkGoal.completedCheckIns >= checkGoal.checkInGoal));
    } else if (_filterType == FilterType.finished) {
      return checkGoal.isFinished;
    }
    return true;
  }

  applyFilterAndSort(){
    List<Goal> tempFilteredGoals = [];
    for(int i = 0; i < _searchResults.length; i++){
      if(filterExpression(_searchResults[i])){
        tempFilteredGoals.add(_searchResults[i]);
      }
    }
    setState(() {
      _displayedGoals = tempFilteredGoals;
    });
    applySort();
  }

  void performSearch(String searchTerm){
    // This prevents resetting filters & sorting when user clicks away from searchbar
    if(searchTerm == _searchQuery){
      return;
    }

    if(searchTerm.isEmpty) {
      setState(() {
        _searchResults = _allGoals;
        _sortType = SortType.newest;
        _filterType = FilterType.all;
      });
    } else { 
      List<Goal> tempSearchResults = [];
      for(int i = 0; i < _allGoals.length; i++){
        if((_allGoals[i].communityName).contains(searchTerm)){
          tempSearchResults.add(_allGoals[i]);
        }
      }
      setState(() {
        _searchResults = tempSearchResults;
        _sortType = SortType.newest;
        _filterType = FilterType.all;
      });
    }
    _searchQuery = searchTerm;
    applyFilterAndSort();
  }

  clearSearch(){
    searchInput.clear();
    performSearch("");
  }

  applySort(){
    if (_sortType == SortType.newest) {
      setState(() {
          _displayedGoals.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      });
    } else if (_sortType == SortType.oldest) {
      setState(() {
          _displayedGoals.sort((a, b) => a.creationDate.compareTo(b.creationDate));
      });
    } else if (_sortType == SortType.completionAscending) {
      setState(() {
          _displayedGoals.sort((a, b) => ((b.completedCheckIns/b.checkInGoal)).compareTo((a.completedCheckIns/a.checkInGoal)));
      });
    } else if (_sortType == SortType.completionDescending) {
      setState(() {
          _displayedGoals.sort((a, b) => ((a.completedCheckIns/a.checkInGoal)).compareTo((b.completedCheckIns/b.checkInGoal)));
      });
    } else if (_sortType == SortType.communitiesAtoZ){
      setState(() {
          _displayedGoals.sort((a, b) => a.communityName.compareTo(b.communityName)); 
      });
    } else if (_sortType == SortType.communitiesZtoA){
      setState(() {
          _displayedGoals.sort((a, b) => b.communityName.compareTo(a.communityName));
      });
    }
  }

  String getAppliedFilterAndSortDisplayStatement(){
    Map <FilterType, String> filterTypeToDisplayString = {
      FilterType.open: "open",
      FilterType.overdue: "overdue",
      FilterType.finished: "finished",
      FilterType.all: "all"
    };
    Map <SortType, String> sortTypeToDisplayString = {
      SortType.newest: "newest",
      SortType.oldest: "oldest",
      SortType.completionAscending: "completion (ascending)",
      SortType.completionDescending: "completion (descending)",
      SortType.communitiesAtoZ: "communities (A to Z)",
      SortType.communitiesZtoA: "communities (Z to A)"
    };
    return "Showing ${filterTypeToDisplayString[_filterType]} goals sorted by ${sortTypeToDisplayString[_sortType]}";
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
          const SizedBox(
            height: 123,
            child:
              DrawerHeader(
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
        setState(() {
          _filterType = FilterType.open;
        });
        applyFilterAndSort();
        Navigator.pop(context);
      },
      child: const Text('Open'),
    ),
    TextButton(
      onPressed: () {
        setState(() {
          _filterType = FilterType.overdue;
        });
        applyFilterAndSort();
        Navigator.pop(context);
      },
      child: const Text('Overdue'),
    ),
    TextButton(
      onPressed: () {
        setState(() {
          _filterType = FilterType.finished;
        });
        applyFilterAndSort();
        Navigator.pop(context);
      },
      child: const Text('Finished'),
    ),
    TextButton(
      onPressed: () {
        setState(() {
          _filterType = FilterType.all;
        });
        applyFilterAndSort();
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
                setState(() {
                  _sortType = SortType.newest;
                });
                applySort();
                Navigator.pop(context);
              },
              child: const Text('Newest'),
            ),
            TextButton(
               onPressed: () {
                setState(() {
                  _sortType = SortType.oldest;
                });
                applySort();
                Navigator.pop(context);
              },
              child: const Text('Oldest'),
            ),
            TextButton(
               onPressed: () {
                setState(() {
                  _sortType = SortType.completionAscending;
                });
                applySort();
                Navigator.pop(context);
              },
              child: const Text('Completion (Ascending)'),
            ),
            TextButton(
               onPressed: () {
                setState(() {
                  _sortType = SortType.completionDescending;
                });
                applySort();
                Navigator.pop(context);
              },
              child: const Text('Completion (Descending)'),
            ),
             TextButton(
               onPressed: () {
                setState(() {
                  _sortType = SortType.communitiesAtoZ;
                });
                applySort();
                Navigator.pop(context);
              },
              child: const Text('Communities A to Z'),
            ),
             TextButton(
               onPressed: () {
                setState(() {
                  _sortType = SortType.communitiesZtoA;
                });
                applySort();
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
   return const Center(
       child: CircularProgressIndicator()
     );
 }
 
 buildGoalsPageErrorScreen(){
  return LinearErrorScreen(
    errorMessage: "We ran into an unexpected error while fetching your goals. Please try again later.",
  );
 }
 
 buildGoalsPageContent(){
  return Column(
      children: [
        buildSearchBar(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide( 
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Text(
            getAppliedFilterAndSortDisplayStatement(),
            textAlign: TextAlign.center,
            ),
        ),
        buildGoalsList(),
      ],
    );
 }
 
  buildSearchBar(){
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10 , 10, 3),
      child: TextFormField(
        controller: searchInput,
        onChanged: performSearch,
        style: const TextStyle(
            fontSize: 16,
          ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          hintText: "Search by community name...",
          suffixIcon: searchInput.text.isEmpty? 
            null 
            : IconButton(
                icon: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Icons.close)
                  ),
                onPressed: (){
                  clearSearch();
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
        ),
      ),
    );
  }
 
 buildGoalsList() {
     return
       Expanded(
         child: RefreshIndicator(
         onRefresh: () async {
           await fetchGoals(showSpinner: false);
         },
         child: SingleChildScrollView(
           physics: const BouncingScrollPhysics(),
           child: _displayedGoals.isEmpty?
            buildNoGoalsFoundMessage()
            : Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _displayedGoals.length,
                    itemBuilder: (context, index) {
                      return GoalWidget(
                        goal: _displayedGoals[index],
                        onDelete: () { 
                          setState(() {
                            _displayedGoals.removeAt(index);
                          });
                        },
                        onFinish: () {
                          setState(() {
                            _displayedGoals[index].isFinished = true;
                            searchInput.clear();
                          });
                        },
                        onExtend: (int extension) {
                          setState(() {
                            _displayedGoals[index].checkInGoal += extension;
                            searchInput.clear();
                          });
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
  
  buildNoGoalsFoundMessage() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Image.asset('assets/no_search_results.png'),
        ),
        const Text(
          "We found no goals.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        
        Container(
          margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
          child: const Text(
            "Try adjusting your sort and filter settings.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ]
    );
  }
}