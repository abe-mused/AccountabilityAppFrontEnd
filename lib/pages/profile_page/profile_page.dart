import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/image_related_widgets/upload_image_widget.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/profile_page/get_profile.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/auth_util.dart' as authUtil;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.username = ''}) : super(key: key);
  final String username;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  bool _isChangingProfilePicture = false;

  logout() {
    final UserPreferences userPreferences = UserPreferences();
    userPreferences.clearPreferences();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();

    authUtil.refreshTokenIfExpired().then((response) => {
          if (response['refreshed'] == true)
            {
              Provider.of<UserProvider>(context, listen: false).setUser(response['user']),
            }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    bool shouldUploadImage() {
      setState(() {
        _isChangingProfilePicture = true;
      });
      return true;
    }

    void onImageWidgetSubmit(String? url) async {
      if(_isChangingProfilePicture){
        return;
      }

      final Future<Map<String, dynamic>> responseMessage = changeProfilePicture(user!.idToken, url! );

      responseMessage.then((response) {
        if (response['status'] == true) {
          _isChangingProfilePicture = false;
        }
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
                            token: user?.idToken ?? '',
                            onLoading: shouldUploadImage,
                            onSuccess: onImageWidgetSubmit,
                            onCancel: () {
                              Navigator.pop(context, 'Cancel');
                            },
                          ),
                          if(_isChangingProfilePicture) ...[
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
        body: Center(child: GetProfileWidget(token: user?.idToken ?? "INVALID TOKEN", username: user?.username ?? "INVALID USERNAME")),
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
                  createReport({"username": widget.username}, user?.idToken ?? "INVALID TOKEN");
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
        body: Center(child: GetProfileWidget(token: user?.idToken ?? "INVALID TOKEN", username: widget.username)),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
  }
}
