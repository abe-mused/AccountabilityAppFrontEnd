class Post {
  String communityName;
  String postId;
  String creator;
  String? creatorProfileImageUrl;
  int creationDate;
  int commentCount;
  String title;
  String body;
  String? imageUrl;
  List<dynamic>? likes;

  Post({
    required this.communityName,
    required this.postId,
    required this.creator,
    required this.creationDate,
    required this.title,
    required this.body,
    required this.commentCount,
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
      commentCount: item['commentCount'] is int ? item['commentCount'] : int.parse(item['commentCount']),
    );
    
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
