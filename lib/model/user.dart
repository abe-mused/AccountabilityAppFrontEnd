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
  });

  factory User.fromJson(Map<String, dynamic> item) {
    print("item followers is ${item['followers']}");
    print("item following is ${item['following']}");
    User user = User(
      username: item['username'],
      name: item['name'],
      communities: item['communities'],
    );
    user.followers = item['followers'];
    user.followers = item['following'];
    return user;
  }
}
