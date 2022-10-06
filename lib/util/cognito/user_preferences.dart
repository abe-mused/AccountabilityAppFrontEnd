import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("username", user.username);
    prefs.setString("idToken", user.idToken);
    // prefs.setString("accessToken", json.encode(user.accessToken));
    // prefs.setString("idToken", json.encode(user.idToken));
    // prefs.setString("refreshToken", json.encode(user.refreshToken));

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
//
    // prefs.clear();
//
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? username = prefs.getString("username");
    String? idToken = prefs.getString("idToken");
    // String? accessToken = prefs.getString("accessToken");
    // String? idToken = prefs.getString("idToken");
    // String? refreshToken = prefs.getString("refreshToken");

    // if (name != null && email != null && username != null && accessToken != null && idToken != null && refreshToken != null) {
    if (name != null && email != null && username != null && idToken != null) {
      return User(
        name: name,
        email: email,
        username: username,
        idToken: idToken,
        // accessToken: json.decode(accessToken),
        // idToken: json.decode(idToken),
        // refreshToken: json.decode(refreshToken),
      );
    } else {
      print("abe is here");
      print("name: $name email: $email username: $username idToken: $idToken");
      print("end of abe");
    }
    return null;
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("username");
    prefs.remove("accessToken");
    prefs.remove("idToken");
    prefs.remove("refreshToken");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("idToken");
    if (token != null) {
      // return json.decode(token);
      return token;
    } else {
      throw Exception("Token not found");
    }
  }
}
