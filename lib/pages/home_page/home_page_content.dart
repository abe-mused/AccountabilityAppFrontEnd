import 'package:flutter/material.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/model/post.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/util/cognito/user.dart' as cognito_user;

// ignore: must_be_immutable
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key, required this.token, required this.username});
  final String token;
  final String username;

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  cognito_user.User? user = UserProvider().user;
  List<dynamic> _post = [];
  List<dynamic> _likedPosts = [];

  bool isLoading = true;
  bool isErrorFetchingUser = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  isViewingOwnProfile() {
    return user!.username == widget.username;
  }

  getUser() {
    //TODO: use the homepage endpoint once it up and running
    final Future<Map<String, dynamic>> responseMessage = getProfile(widget.username, widget.token);
    responseMessage.then((response) {
      if (response['status'] == true) {
        List<dynamic> posts = (response['posts']);
        setState(() {
          _post = posts;
          isLoading = false;
        });

        if (_post.isNotEmpty) {
          List<dynamic> likedPosts = [];
          for (var i = 0; i < _post.length; i++) {
            likedPosts.add(_post[i]['likes'].contains(user?.username));
            print(likedPosts[i]);
          }
          setState(() {
            _likedPosts = likedPosts;
          });
        }
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
    user = Provider.of<UserProvider>(context).user;

    if (isLoading == false && isErrorFetchingUser == false) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                          return PostWidget(
                            liked: _likedPosts[index],
                            onLike: () {
                              setState(() {
                                _likedPosts[index] = !_likedPosts[index];
                              });
                            },
                            token: widget.token,
                            post: Post(
                              communityName: _post[index]['community'],
                              postId: _post[index]['postId'],
                              creator: _post[index]['creator'],
                              creationDate: int.parse(_post[index]['creationDate']),
                              title: _post[index]['title'],
                              body: _post[index]['body'],
                              likes: _post[index]['likes'],
                            ), onDelete: () {  
                              setState(() {
                                _post.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: Text('No posts yet!'),
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
            "We ran into an error trying to obtain the profile. \nPlease try again later.",
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
