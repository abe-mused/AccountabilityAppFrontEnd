class User {
  String username;
  String name;
  List<dynamic>? communities;
  List<dynamic>? following;
  List<dynamic>? followers;
  String? imageUrl;

  User({
    required this.username,
    required this.name,
    required this.communities,
    required this.followers,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> item) {
    User user = User(
      username: item['username'],
      name: item['name'],
      communities: item['communities'],
      followers: item['followers'] ?? [],
      following: item['following'] ?? [],
    );

    if(item["imageUrl"] != null) {
      user.imageUrl = item["imageUrl"];
    }

    return user;
  }
}
