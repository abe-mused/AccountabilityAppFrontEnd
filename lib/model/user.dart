class User {
  String username;
  String name;
  List<Map<String, String>>? communities;

  User({required this.username, required this.name});

  factory User.fromJson(Map<String, dynamic> item) {
    User user = User(
      username: item['username'],
      name: item['name'],
    );
    if (item['communities'] == null) {
      print('it ran');

      user.communities = item['communities'];
      print(user.communities);
    }
    return user;
  }
}
