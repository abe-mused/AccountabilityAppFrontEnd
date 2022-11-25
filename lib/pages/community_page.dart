import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:linear/model/community.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/create_post.dart';
import 'package:linear/pages/common_widgets/create_goal_widget.dart';
import 'package:linear/pages/common_widgets/post_widget.dart';
import 'package:linear/pages/common_widgets/goal_widget.dart';
import 'package:linear/model/goal.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:linear/pages/common_widgets/sortPosts.dart';

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
  final String _currentDate = DateFormat("MM/dd/yyyy").format(DateTime.now());

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
        });
      } else {
        setState(() {
          _isErrorFetchingCommunity = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetchingCommunity) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Community"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
    if (_isErrorFetchingCommunity) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Community"),
        ),
        body: const Center(
          child: Center(
            child: Text(
              "We ran into an error trying to obtain the community. \nPlease try again later.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
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
                onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "c/${_community.communityName}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Created on ${getFormattedDate(_community.creationDate)}",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // ignore: unrelated_type_equality_checks
                        "${_community.members.length} members",
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      if (doesCurrentDateExistInCheckins()) ...[
                        Text(
                          // ignore: unrelated_type_equality_checks
                          "${_community.checkIns[0]['usersCheckedIn'].length} check-ins today",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ] else ...[
                        const Text(
                          "0 check-ins today",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 10),
                      if (!_isUpdatingMembership)
                        ElevatedButton(
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
                              isMember() ? "Leave community" : "Join community"),
                        ),
                      if (_isUpdatingMembership)
                        ElevatedButton(
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
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if(_unfinishedGoal != null)
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
                  onExtend: () {  
                    setState(() {
                     
                  });
                    doGetCommunity();
                  }, 
                ),
              const SizedBox(height: 10),
              Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
              child:   
                SortPosts(posts: _posts, isCommunityPage: true, onSort: (posts) => setState(() {_posts = posts;}),), 
            ),
              // ignore: prefer_is_empty
              if ((_posts.length) > 0) ...[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: ListView.builder(
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
                ),
              ] else ...[
                const Center(
                  child: Text("No posts yet"),
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
}
