import 'package:linear/util/cognito/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:developer' as developer;

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("username", user.username);
    prefs.setString("idToken", user.idToken);
    prefs.setInt("idTokenExpiration", user.idTokenExpiration);
    prefs.setString("refreshToken", user.refreshToken);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<void> clearPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? username = prefs.getString("username");
    String? idToken = prefs.getString("idToken");
    int? idTokenExpiration = prefs.getInt("idTokenExpiration");
    String? refreshToken = prefs.getString("refreshToken");

    if (name != null && email != null && username != null && idToken != null && idTokenExpiration != null && refreshToken != null) {
      return User(
        name: name,
        email: email,
        username: username,
        idToken: idToken,
        idTokenExpiration: idTokenExpiration,
        refreshToken: refreshToken,
      );
    } else {
      developer.log("some or all of the User attributes in localStorage is null");
      developer.log(
          "name: $name email: $email username: $username idToken: $idToken idTokenExpiration: $idTokenExpiration refreshToken: $refreshToken");
    }
    return null;
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("username");
    prefs.remove("idToken");
    prefs.remove("idTokenExpiration");
    prefs.remove("refreshToken");
  }
}
