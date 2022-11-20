import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/image_related_widgets/upload_image_widget.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/pages/profile_page/get_profile.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/auth_util.dart' as auth_util;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.username = ''}) : super(key: key);
  final String username;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  String? _currentUsername;
  bool _isChangingProfilePicture = false;
  bool _showLoadingSpinner = false;

  logout() {
    UserPreferences().setActiveTab(0);
    UserPreferences().removeUser();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();

    auth_util.getUserName().then((userName) {
      setState(() {
        _currentUsername = userName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    bool shouldUploadImage() {
      setState(() {
        _showLoadingSpinner = true;
      });
      return true;
    }

    void onImageWidgetSubmit(String? url) async {
      if(_isChangingProfilePicture || url == null) {
        return;
      }

      setState(() {
        _isChangingProfilePicture = true;
      });

      final Future<Map<String, dynamic>> responseMessage = changeProfilePicture(context, url);

      responseMessage.then((response) {
        setState(() {
          _isChangingProfilePicture = false;
          _showLoadingSpinner = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                username: widget.username,
              ),
            ),
          );
      });

    }

    if (widget.username == '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            if (widget.username == '') ...[
              PopupMenuButton(itemBuilder: (context) {
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
              }, onSelected: (value) {
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
                            onLoading: shouldUploadImage,
                            onSuccess: onImageWidgetSubmit,
                            onCancel: () {
                              setState(() {
                                _isChangingProfilePicture = false;
                              });
                              Navigator.pop(context, 'Cancel');
                            },
                          ),
                          if(_showLoadingSpinner) ...[
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ]
                      ),
                      actions: const <Widget>[],
                    ),
                  );
                }
              }),
            ]
          ],
        ),
        body: Center(
          child: _currentUsername != null?
            GetProfileWidget(username: _currentUsername!)
            : Container(),
          ),
        bottomNavigationBar: const LinearNavBar(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            PopupMenuButton(
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
                  createReport(context, {"username": widget.username});
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
            ),
          ],
        ),
        body: Center(child: GetProfileWidget(username: widget.username)),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
  }
}
