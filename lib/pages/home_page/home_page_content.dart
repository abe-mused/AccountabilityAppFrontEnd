import 'package:flutter/material.dart';
import 'package:linear/pages/home_page/home_page.dart';
import 'package:linear/util/apis.dart' as api_util;
import 'package:linear/pages/post_widgets/post_widget.dart';
import 'package:linear/model/post.dart';

// ignore: must_be_immutable
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key, required this.username});
  final String username;

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  ScrollController scrollController = ScrollController();
  List<dynamic> _posts = [];
  dynamic _tokens = {};
  bool _nextPageMightContainMorePosts = false;

  bool isLoading = false;
  bool isLoadingMorePosts = false;
  bool isErrorFetchingUser = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(scrollListener);
    getHomeFeed();
  }
  
  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  scrollListener() {
    if (scrollController.position.extentAfter < 500 && _nextPageMightContainMorePosts && !isLoadingMorePosts) {
      fetchMorePosts();
    }
  }

  getHomeFeed() {
    setState(() {
        isLoading = true;
      });
    final Future<Map<String, dynamic>> responseMessage = api_util.getHomeFeed(context, {});
    responseMessage.then((response) {
      if (response['status'] == true) {
        setState(() {
          _posts = response['posts'];
          _tokens = response['tokens'];
          _nextPageMightContainMorePosts = response['nextPageMightContainMorePosts'];
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

  fetchMorePosts() {
    setState(() {
        isLoadingMorePosts = true;
      });
    final Future<Map<String, dynamic>> responseMessage = api_util.getHomeFeed(context, _tokens);
    responseMessage.then((response) {
      if (response['status'] == true) {
        List<dynamic> posts = (response['posts']);
        setState(() {
          _posts = [..._posts, ...posts];
          _tokens = response['tokens'];
          _nextPageMightContainMorePosts = response['nextPageMightContainMorePosts'];
          isLoadingMorePosts = false;
        });

      } else {
        setState(() {
          isLoadingMorePosts = false;
          _nextPageMightContainMorePosts = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading == false && isErrorFetchingUser == false) {
      return RefreshIndicator(
        child: Scaffold(
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Column(
                  children: [
                    // ignore: prefer_is_empty
                    if (_posts.length != 0) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
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
                            }, route: const HomePage(),
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
                if(!_nextPageMightContainMorePosts) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 15.0, bottom: 15.0),
                    child: Text(
                        'That\'s it! Join more communities to see their posts here.',
                        textAlign: TextAlign.center,
                      ),
                  ),
                ] else ...[
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 15.0, bottom: 15.0),
                      child: Text(
                        'Loading more posts...',
                        textAlign: TextAlign.center,
                        ),
                    ),
                ],
              ],
            ),
          ),
        ),
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          getHomeFeed();
        },
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
