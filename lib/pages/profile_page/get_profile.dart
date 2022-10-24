import 'package:flutter/material.dart';
import 'package:linear/model/user.dart';
import 'package:linear/constants/apis.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';

// ignore: must_be_immutable
class GetProfileWidget extends StatefulWidget {
  GetProfileWidget({super.key, required this.token});
  String token;

  @override
  State<GetProfileWidget> createState() => _GetProfileWidgetState();
}

class _GetProfileWidgetState extends State<GetProfileWidget> {
  User _user = User(username: '', name: '', communities: []);
  List<dynamic> _post = [];

  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;
  bool isErrorFetchingUser = false;

  List colors = [Colors.grey, const Color.fromARGB(17, 158, 158, 158)];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    final Future<Map<String, dynamic>> successfulMessage = getProfile(widget.token);
    successfulMessage.then((response) {
      if (response['status'] == true) {
        User user = User.fromJson(response['user']);
        setState(() {
          _user = user;
        });

        List<dynamic> post = (response['posts']);
        setState(() {
          _post = post;
        });
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isErrorFetchingUser = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == false && isErrorFetchingUser == false) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // ignore: unnecessary_string_interpolations
                        "${_user.name}",
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      //add logOut button here: dropDown menu with logOut option
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              UserIcon(radius: 100, username: _user.username),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              Text(
                "@${_user.username}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30.0,
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
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // ignore: prefer_is_empty
                  if (_user.communities?.length != 0) ...[
                    if ((_user.communities?.length ?? 0) < 5) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _user.communities?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: colors[index % colors.length],
                              title: Text(_user.communities![index][0]['communityName']),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ListTile(
                              tileColor: colors[index % colors.length],
                              title: Text(_user.communities![index][0]['communityName']),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('All Communities'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    content: SizedBox(
                                      height: 300,
                                      width: 300,
                                      child: Scrollbar(
                                        thumbVisibility: true,
                                        controller: _scrollController,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          itemCount: _user.communities?.length,
                                          itemBuilder: (context, index) {
                                            return Material(
                                              child: ListTile(
                                                tileColor: colors[index % colors.length],
                                                title: Text(_user.communities![index][0]['communityName']),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Okay'))
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                "Show More",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                        ],
                      ),
                    ],
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: colors[index % colors.length],
                            title: const Text('You are not part of a community, try joining one!'),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  SizedBox(width: 15.0),
                  Text(
                    "Posts",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 23.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              //Posts list builder
              Column(
                children: [
                  // ignore: prefer_is_empty
                  if (_post.length != 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _post.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: colors[index % colors.length],
                            title: Text(_post[index]['title']),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: colors[index % colors.length],
                            title: const Text('You haven\'t made a post, try making one first!'),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      );
    } else if (isLoading == false && isErrorFetchingUser == true) {
      return const Scaffold(
        body: Center(
          child: Text(
            "We ran into an error trying to obtain your profile. \nPlease try again later.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
