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
    print (item['communities']);
    if (item['communities'] == null) {
      print('it ran');

      user.communities = item['communities'];
      print(user.communities);
    }
    return user;
  }
}
