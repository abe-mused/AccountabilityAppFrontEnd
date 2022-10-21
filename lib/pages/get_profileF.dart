import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/constants/apis.dart';

// ignore: must_be_immutable
class GetProfileWidget extends StatefulWidget {
  GetProfileWidget({super.key, required this.token});
  String token;

  @override
  State<GetProfileWidget> createState() => _GetProfileWidgetState();
}

class _GetProfileWidgetState extends State<GetProfileWidget> {
  User _user = User(username: 'didnt', name: 'work');

  doGetUser() {
    final Future<Map<String, dynamic>> successfulMessage =
        getProfile(widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        User user = User.fromJson(response['user']);
        setState(() {
          _user = user;
        });
        print("success running getProfile");
      } else {
        User user = User(username: 'error', name: 'error');
        setState(() {
          _user = user;
        });
        print("error return");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error!"),
                content: const Text("No results found."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: doGetUser(), // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Please wait its loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else if (snapshot.hasData) {
              return Scaffold(
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_user.name}",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_horiz,
                                size: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 70.0),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://free2music.com/images/singer/2019/02/10/troye-sivan_2.jpg"),
                      radius: 70.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "@${_user.username}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 20.0),
                        Column(
                          children: [
                            Text(
                              "29",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              "Following",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "121.9k",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              "Followers",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "7.5M",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              "Like",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.0),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Follow",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(140.0, 55.0),
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.0),
                        OutlinedButton(
                          onPressed: () {},
                          child: Icon(Icons.mail_outline_outlined),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.black,
                              backgroundColor: Colors.black12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              fixedSize: Size(50.0, 60.0)),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 50.0),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ); // snapshot.data  :- get your object which is pass from your downloadData() function
            } else {
              return const CircularProgressIndicator();
            }
          }
        });
  }
}
