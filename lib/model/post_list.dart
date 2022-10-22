class PostList {

  List<dynamic> posts;

  PostList({required this.posts});

  factory PostList.fromJson(Map<String, dynamic> item) {
    PostList list = PostList(
      posts: item['posts'],
    );
    return list;
  }
}
