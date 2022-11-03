class User {
  String username;
  String name;
  List<dynamic>? communities;
  List<dynamic>? following;
  List<dynamic>? followers;

  User({
    required this.username,
    required this.name,
    required this.communities,
    required this.followers,
    required this.following
  });

  factory User.fromJson(Map<String, dynamic> item) {
    print("item followers is ${item['followers']}");
    print("item following is ${item['following']}");
    User user = User(
      username: item['username'],
      name: item['name'],
      communities: item['communities'],
      followers: item['followers'] ?? [],
      following: item['following'] ?? [],
    );
    return user;
  }
}
