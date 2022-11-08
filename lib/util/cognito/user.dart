import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import 'dart:developer' as developer;

class User {
  String name;
  String email;
  String username;
  String idToken;
  int idTokenExpiration;
  String refreshToken;

  User({
    required this.name,
    required this.email,
    required this.username,
    required this.idToken,
    required this.idTokenExpiration,
    required this.refreshToken,
  });

  factory User.fromCognitoSession(CognitoUserSession session) {
    return User(
      name: session.idToken.payload['name'],
      email: session.idToken.payload['email'],
      username: session.idToken.payload['cognito:username'],
      idToken: session.getIdToken().getJwtToken().toString(),
      idTokenExpiration: session.idToken.payload['exp'] * 1000, // convert to milliseconds
      refreshToken: session.getRefreshToken()!.getToken() ?? '',
    );
  }

  void printUser() {
    developer.log("===================================");
    developer.log("name is '$username' email is '$email' name is '$name'");
    developer.log("idToken is '${idToken.substring(idToken.length - 20, idToken.length)}'");
    developer.log("idTokenExpiration is '$idTokenExpiration' date is  '${DateTime.fromMillisecondsSinceEpoch(idTokenExpiration)}' ");
    developer.log("refreshToken is '${refreshToken.substring(refreshToken.length - 20, refreshToken.length)}'");
    developer.log("===================================");
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, username: $username, idToken: $idToken}';
  }
}
