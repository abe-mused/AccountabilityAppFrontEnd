class Post {
  String communityName;
  String postId;
  String creator;
  String? creatorProfileImageUrl;
  int creationDate;
  String title;
  String body;
  String? imageUrl;
  List<dynamic>? comments;
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
      creationDate: item['creationDate'] is int ? item['creationDate'] : int.parse(item['creationDate']),
      title: item['title'],
      body: item['body'],
    );
    if (item['comments'] != null) {
      post.comments = item['comments'];
    }
    if (item['likes'] != null) {
      post.likes = item['likes'];
    }
    if (item['imageUrl'] != null && item['imageUrl'] != "NONE") {
      post.imageUrl = item['imageUrl'];
    }
    if (item['creatorImageUrl'] != null && item['creatorImageUrl'] != "NONE") {
      post.creatorProfileImageUrl = item['creatorImageUrl'];
    }

    return post;
  }
}
