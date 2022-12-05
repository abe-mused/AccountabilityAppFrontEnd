// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/error_screen.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/community_page/create_post_widget.dart';
import 'package:linear/pages/community_page/create_goal_widget.dart';
import 'package:linear/pages/common_widgets/post_widget.dart';
import 'package:linear/pages/common_widgets/goal_widget.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:linear/pages/common_widgets/sort_posts_widget.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({super.key, required this.communityName});

  String communityName;

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  Community _community = Community(
      communityName: '',
      creationDate: 1,
      creator: '',
      members: [],
      checkIns: []);
  List<dynamic> _posts = [];

  String? _currentUsername;
  //TODO: display finished goals somewhere on the page
  List<dynamic> _finishedGoals = [];
  dynamic _unfinishedGoal;

  bool _isUpdatingMembership = false;
  bool _isFetchingCommunity = false;
  bool _isErrorFetchingCommunity = false;
  final String _currentDate = DateFormat("M/d/yyyy").format(DateTime.now());

  bool _showFab = true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(scrollListener);
    
    auth_util.getUserName().then((userName) {
      setState(() {
        _currentUsername = userName;
      });
    });

    doGetCommunity();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  scrollListener() {
    if (_showFab != 
      (scrollController.position.userScrollDirection == ScrollDirection.forward)) {
      setState(() {
        _showFab = !_showFab;
      });
    }
  }

  doesCurrentDateExistInCheckins() {
    return _community.checkIns.isNotEmpty &&
            _community.checkIns[0]['date'] == _currentDate;
  }

  isUserCheckedIn() {
    return doesCurrentDateExistInCheckins() &&
            _community.checkIns[0]['usersCheckedIn'].contains(_currentUsername);
  }

  isMember() {
    return _community.members.contains(_currentUsername);
  }

  doGetCommunity({bool showLoadingIndicator = true}) {
    if(showLoadingIndicator){
      setState(() {
        _isFetchingCommunity = true;
      });
    }

    getPostsForCommunity(context, widget.communityName).then((response) {
      if (response['status'] == true) {
        setState(() {
          _community = Community.fromJson(response['community']);
          _posts = response['posts'];
          _finishedGoals = response['goals']["finishedGoals"];
          _unfinishedGoal = response['goals'] ["unfinishedGoal"];
        });

        setState(() {
          _isFetchingCommunity = false;
          _isErrorFetchingCommunity = false;
        });
      } else {
        setState(() {
          _isFetchingCommunity = false;
          _isErrorFetchingCommunity = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetchingCommunity || _isErrorFetchingCommunity) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Community"),
        ),
        body: _isFetchingCommunity?
          buildLoadingScreen()
          : buildErrorScreen(),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : const Offset(2, 0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showFab ? 1 : 0,
          child: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 10,
            childPadding: const EdgeInsets.all(0),
            spaceBetweenChildren: 15,
            renderOverlay: true,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.post_add),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Create Post',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CreatePostWidget(
                        communityName: widget.communityName,
                        onSuccess: () {
                          Navigator.pop(context);
                          doGetCommunity( showLoadingIndicator: false);
                        },
                      );
                    }
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.moving_rounded),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Create Goal',
                visible: true,
                onTap: () {
                  if(!isMember()){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(("You must be a member of the community to create a goal.")))
                    );
                  } else if(_unfinishedGoal != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(("You already have an unfinished goal in this community.")))
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CreateGoalWidget(
                          communityName: widget.communityName,
                          onSuccess: (newGoal) {
                            setState(() {
                              _unfinishedGoal = newGoal;
                            });
                            Navigator.pop(context);
                          },
                        );
                      }
                    );
                  }
                }, 
                onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
              ),
            ],
          ),          
        ),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              buildCommunityPageHeader(),
              const Divider(
                height: 10,
                thickness: 2,
                indent: 0,
                endIndent: 0,
              ),
              if(_unfinishedGoal != null) ...[
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 10),
                      child: Text(
                        "Unfinished Goal",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    ),
                  ],
                ),
                GoalWidget(
                  goal: Goal.fromJson( _unfinishedGoal),
                  onDelete: () {  
                    setState(() {
                      _unfinishedGoal = null;
                  });
                  }, 
                  onFinish: () {  
                    setState(() {
                      _unfinishedGoal = null;
                  });
                  }, 
                  onExtend: (int extension) {  
                    setState(() {
                      _unfinishedGoal["checkInGoal"] += extension;
                    });
                  }, 
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15,),
                child: SortPosts(
                  posts: _posts,
                  isCommunityPage: true,
                  onSort: (posts) => setState(() {_posts = posts;}),
                ), 
              ),
              if (_posts.isNotEmpty) ...[
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    return PostWidget(
                      onLike: (likes) => setState(() {
                        _posts[index]['likes'] = likes;
                      }),
                      post: Post.fromJson(_posts[index]),
                      onDelete: () {
                        setState(() {
                          _posts.removeAt(index);
                        });
                      },
                      route: CommunityPage(
                        communityName: _community.communityName,
                      ),
                    );
                  },
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Image.asset('assets/empty_mailbox.png'),
                ),
                const Text(
                  "Nothing!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                  child: const Text(
                    "Be the first to check into this community!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ],
          ),
        ),
        onRefresh: () async {
          doGetCommunity();
        },
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
  
  buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  buildErrorScreen() {
    return LinearErrorScreen(
      errorMessage: "We ran into an unexpected error while fetching This community. Please try again later.",
    );
  }
  
  buildCommunityPageHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              UserIcon(radius: 40, username: _community.communityName),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        "u/${_community.communityName}".length < 13? 
                          "u/${_community.communityName}"
                          : "u/${_community.communityName.substring(0, 13)}...",
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        getFormattedDate(_community.creationDate),
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                doesCurrentDateExistInCheckins()? 
                  "${_community.checkIns[0]['usersCheckedIn'].length} check-in${_community.checkIns[0]['usersCheckedIn'].length == 1? "" : "s"} today"
                    : "0 check-ins today",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "${_community.members.length}",
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.people,
                        size: 34.0
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  buildJoinAndLeaveButton(),
                ]
              )
            ],
          ),
        ],
      ),
    );
  }

  buildJoinAndLeaveButton(){
    if (!_isUpdatingMembership) {
      return ElevatedButton(
        onPressed: () async {
          setState(() {
            _isUpdatingMembership = true;
          });
          await joinAndLeave(context, widget.communityName);

          setState(() {
            if (isMember()) {
              _community.members.remove(_currentUsername);
              _community = _community;
            } else {
              _community.members.add(_currentUsername);
              _community = _community;
            }
            _isUpdatingMembership = false;
          });
        },
        style: isMember()
            ? AppThemes.secondaryTextButtonStyle(context)
            : null,
        child: Text(
            isMember() ? "Leave" : "Join"),
      );
    }

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: const SizedBox(
        height: 10.0,
        width: 10.0,
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
