import 'package:flutter/material.dart';
import 'package:linear/pages/common_widgets/error_screen.dart';
import 'package:linear/pages/common_widgets/navbar.dart';
import 'package:linear/util/apis.dart' as api_util;
import 'package:linear/model/post.dart';
import 'package:linear/pages/common_widgets/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  List<dynamic> _posts = [];
  dynamic _tokens = {};
  bool _nextPageContainsMorePosts = false;

  bool isLoading = false;
  bool isLoadingMorePosts = false;
  bool isErrorFetchingUser = false;

  scrollListener() {
    if (scrollController.position.extentAfter < 500 && _nextPageContainsMorePosts && !isLoadingMorePosts) {
      fetchMorePosts();
    }
  }

  getHomeFeed({bool showLoadingIndicator = true}){
    if(showLoadingIndicator){
      setState(() {
        isLoading = true;
      });
    }

    final Future<Map<String, dynamic>> responseMessage = api_util.getHomeFeed(context, {});
    responseMessage.then((response) {
      if (response['status'] == true) {
        setState(() {
          _posts = response['posts'];
          _tokens = response['tokens'];
          _nextPageContainsMorePosts = response['nextPageMightContainMorePosts'];
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
          _nextPageContainsMorePosts = response['nextPageMightContainMorePosts'];
          isLoadingMorePosts = false;
        });

      } else {
        setState(() {
          isLoadingMorePosts = false;
          _nextPageContainsMorePosts = false;
        });
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Linear Home Page!"),
        elevation: 0.1,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: buildHomePageScreen(),
      ),
      bottomNavigationBar: const LinearNavBar(),
    );
  }
  
  buildHomePageScreen() {
    if (isLoading) {
      return buildHomePageLoadingScreen();
    } else if (isErrorFetchingUser) {
      return buildHomePageErrorScreen();
    } else {
      return buildHomePageContent();
    }
  }

  buildHomePageLoadingScreen() {
    return const CircularProgressIndicator();
  }

  buildHomePageErrorScreen() {
    return LinearErrorScreen(
        errorMessage: "We ran into an unexpected error while fetching your home feed. Please try again later.",
      );
  }

  buildHomePageContent() {
    return RefreshIndicator(
      child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
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
                      route: const HomePage(),
                    );
                  },
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Image.asset('assets/no_posts_home_page.png'),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                    "So empty...\nJoin communities to see posts and make progress!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
              if(!_nextPageContainsMorePosts && _posts.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 15.0, bottom: 15.0),
                  child: Text(
                      'That\'s it! Join more communities to see their posts here.',
                      textAlign: TextAlign.center,
                    ),
                ),
              ] else if(_nextPageContainsMorePosts) ...[
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
        onRefresh: () async {
          getHomeFeed(showLoadingIndicator: true);
        },
      );
  }
}
