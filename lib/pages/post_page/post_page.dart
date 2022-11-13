import 'package:flutter/material.dart';
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/pages/post_page/create_comment_widget.dart';
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/util/apis.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:linear/util/date_formatter.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/common_widgets/user_icon.dart';

class PostPage extends StatefulWidget {
  PostPage({super.key, required this.postId, required this.token, required this.route});

  String postId;
  String token;
  Widget route;
  @override
  State<PostPage> createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  Post _post = Post(
      title: '',
      body: '',
      communityName: '',
      postId: '',
      creationDate: 1,
      creator: '',
      likes: [],
      comments: []);
  List<dynamic> _comments = [];

  User? user = UserProvider().user;

  bool _isloading = true;
  List<dynamic> _likedPosts = [];

  @override
  void initState() {
    super.initState();
    doGetPost();
  }

  delete(context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.route));
  }

  doGetPost() {
    final Future<Map<String, dynamic>> responseMessage =
        getPostWithComments(widget.postId, widget.token);
    responseMessage.then((response) {
      if (response['status'] == true) {
        response['post']['creationDate'] =
            int.parse(response['post']['creationDate']);
        Post post = Post.fromJson(response['post']);
        List<dynamic> likedPosts = [];

        likedPosts.add(post.likes?.contains(user!.username));
        setState(() {
          _likedPosts = likedPosts;
        });

        setState(() {
          _post = post;
        });

        List<dynamic> comments = (response['comments']);
        setState(() {
          _comments = comments;
          _isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    if (_isloading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: const LinearNavBar(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          // removes bottom overflow pixel error
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.height,
                child: PostWidget(
                  liked: _likedPosts[0],
                  onLike: () {
                    setState(() {
                      _likedPosts[0] = !_likedPosts[0];
                    });
                  },
                  token: widget.token,
                  post: _post,
                  onDelete: () {
                    delete(context);
                  }, route: widget.route,
                ),
              ),
              const SizedBox(height: 10),
              CreateCommentWidget(
                token: widget.token,
                postId: widget.postId,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                              username: _comments[index]
                                                  ['creator'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: UserIcon(
                                        username: _comments[index]['creator'],
                                        radius: 45,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "u/${_comments[index]['creator']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                        Text(
                                          getFormattedDate(int.parse(
                                              _comments[index]['creationDate']
                                                  .toString())),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 10,
                              thickness: 0.6,
                              indent: 0,
                              endIndent: 0,
                            ),
                            Row(
                              children: [
                                Text(
                                  _comments[index]['body'],
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        onRefresh: () async {
          setState(() {
            _isloading = true;
          });
          doGetPost();
        },
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
}
