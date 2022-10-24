class User {
  String username;
  String name;
  List<dynamic>? communities;

  User({required this.username, required this.name, required this.communities});

  factory User.fromJson(Map<String, dynamic> item) {
    User user = User(
      username: item['username'],
      name: item['name'],
      communities: item['communities'],
    );
    return user;
  }
}
