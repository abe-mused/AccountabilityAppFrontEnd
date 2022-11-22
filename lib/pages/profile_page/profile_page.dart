import 'package:flutter/material.dart';
import 'package:linear/constants/themeSettings.dart';
import 'package:linear/model/post.dart';
import 'package:linear/model/user.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/common_widgets/post_widget.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/image_related_widgets/upload_image_widget.dart';
import 'package:linear/pages/profile_page/community_list.dart';
import 'package:linear/pages/profile_page/view_follows.dart';
import 'package:linear/util/apis.dart' as api;
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;
import 'package:linear/util/date_formatter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.usernameToDisplay}) : super(key: key);
  final String? usernameToDisplay;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  String? _currentUsername;
  User? _userToDisplay;
  List<dynamic> _posts = [];


  bool _isLoadingUser = true;
  bool _isErrorFetchingUser = false;
  bool _isUpdatingFollow = false;
  bool _isChangingProfilePicture = false;
  
  getUsernameToDisplay() {
    if (!isViewingOwnProfile()) {
      return widget.usernameToDisplay;
    } else {
      return _currentUsername;
    }
  }

  isViewingOwnProfile() {
    return widget.usernameToDisplay == null;
  }

  isAFollower() {
    if (_userToDisplay == null) {
      return false;
    }
    return _userToDisplay!.followers!.contains(_currentUsername);
  }

  logout() {
    UserPreferences().setActiveTab(0);
    UserPreferences().removeUser();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void onImageWidgetSubmit(String? url) async {
    if(_isChangingProfilePicture || url == null) {
      return;
    }
    setState(() {
      _isChangingProfilePicture = true;
    });

    api.changeProfilePicture(context, url).then((response) {
      setState(() {
        _isChangingProfilePicture = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              usernameToDisplay: widget.usernameToDisplay,
            ),
          ),
        );
    });
  }

  fetchUser() {
    api.getProfile(context, getUsernameToDisplay()).then((response) {
      if (response['status'] == true) {
        User user = User.fromJson(response['user']);
        
        setState(() {
          _userToDisplay = user;
          _posts = response['posts'];
          _isLoadingUser = false;
        });

      } else {
        setState(() {
          _isLoadingUser = false;
          _isErrorFetchingUser = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    auth_util.getUserName().then((userName) {
      setState(() {
        _currentUsername = userName;
      });
      fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("u/${getUsernameToDisplay()}"),
        automaticallyImplyLeading: !isViewingOwnProfile(),
        actions: <Widget>[
          if(isViewingOwnProfile()) ...[
            buildOwnProfileAppBarActions(),
          ] else ...[
            buildOtherProfileAppBarActions()
          ],
        ],
      ),
      body: Center(
        child: _isLoadingUser?
          const CircularProgressIndicator()
          : _isErrorFetchingUser?
            const Text(
              "We ran into an error trying to obtain the profile. \nPlease try again later.",
              textAlign: TextAlign.center,
            )
            : buildProfilePageContent(),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
  
  buildOwnProfileAppBarActions() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: 0,
            child: Text("Logout"),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text("Change profile picture"),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to log out?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (value == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Logout'),
              content: 
              Stack(
                children: [
                  UploadImageWidget(
                    onLoading: () => true,
                    onSuccess: onImageWidgetSubmit,
                    onCancel: () {
                      setState(() {
                        _isChangingProfilePicture = false;
                      });
                      Navigator.pop(context, 'Cancel');
                    },
                  ),
                ]
              ),
              actions: const <Widget>[],
            ),
          );
        }
      },
    );
  }

  buildOtherProfileAppBarActions() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: 1,
            child: Text("Report"),
          ),
        ];
      },
      onSelected: (value) {
        if(value == 1) {
          api.createReport(context, {"username": widget.usernameToDisplay});
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('User reported!'),
              content: const Text(
                  'This user has been reported and will be reviewed by our moderators.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, 'Ok'),
                  child: const Text('Ok'),
                ),
              ],
            ),
          );
        }
      }
    );
  }
  
  buildProfilePageContent() {
    return RefreshIndicator(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if(_userToDisplay!.imageUrl == null) ...[
                    UserIcon(radius: 50, username: _userToDisplay!.username),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(50),
                        child: Image.network(_userToDisplay!.imageUrl!, fit: BoxFit.cover),
                      ),
                    )
                  ],
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 20),
                          buildFollowersButton("followers", _userToDisplay!.followers!.length),
                          const SizedBox(width: 20),
                          buildFollowersButton("following", _userToDisplay!.following!.length),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          buildFollowButton(),
                        ]
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _userToDisplay!.name,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "u/${_userToDisplay!.username}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 15.0),
                Text(
                  "Communities",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 23.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            CommunityListWidget(
              user: _userToDisplay!,
              communityLength: _userToDisplay!.communities?.length,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 15.0),
                Text(
                  "Posts",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 23.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            //Posts list builder
            Column(
              children: [
                // ignore: prefer_is_empty
                if (_posts.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 5.0),
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
                          route: const ProfilePage(),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child:
                          Text('${_userToDisplay!.name} hasn\'t made a post!')),
                ],
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      onRefresh: () async {
        setState(() {
          _isLoadingUser = true;
        });
        await fetchUser();
      },
    );
  }

  buildFollowButton(){
    if(isViewingOwnProfile()){
      return Container();
    }
    if (!_isUpdatingFollow){
      return ElevatedButton(
        onPressed: () async {
          setState(() {
            _isUpdatingFollow = true;
          });
          await api.followAndUnfollow(context, widget.usernameToDisplay!);
          setState(() {
            if (isAFollower()) {
              _userToDisplay!.followers!.remove(_currentUsername);
            } else {
              _userToDisplay!.followers!.add(_currentUsername);
            }
            _userToDisplay = _userToDisplay;
            _isUpdatingFollow = false;
          });
        },
        style: isAFollower()?
            AppThemes.secondaryTextButtonStyle(context)
            : null,
        child: Text(isAFollower() ? "Unfollow" : "Follow"),
      );
    } else if (_isUpdatingFollow) {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: const SizedBox(
          height: 10.0,
          width: 10.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }
  }
  
  buildFollowersButton(String label, int count){
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewFollowsPage(
                user: _userToDisplay!,
                type: label),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
              label,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
        ]
      ), 
    );
  }
}
