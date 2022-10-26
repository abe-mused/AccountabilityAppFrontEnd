class Post {
  String communityName;
  String postId;
  String creator;
  int creationDate;
  String title;
  String body;
  List<String>? comments;
  List<dynamic>? likes;

  Post({
    required this.communityName,
    required this.postId,
    required this.creator,
    required this.creationDate,
    required this.title,
    required this.body,
    this.comments,
    this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> item) {
    Post post = Post(
      communityName: item['community'],
      postId: item['postId'],
      creator: item['creator'],
      creationDate: item['creationDate'],
      title: item['title'],
      body: item['body'],
    );
    if (item['comments'] != null) {
      post.comments = item['comments'];
    }
    if (item['likes'] != null) {
      post.likes = item['likes'];
    }
    return post;
  }
}
