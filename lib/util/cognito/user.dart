import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class User {
  String name;
  String email;
  String username;
  String idToken;
  // CognitoAccessToken accessToken;
  // CognitoIdToken idToken;
  // CognitoRefreshToken? refreshToken;

  User({
    required this.name,
    required this.email,
    required this.username,
    required this.idToken,
    // required this.accessToken,
    // required this.idToken,
    // this.refreshToken,
  });

  factory User.fromCognitoSession(CognitoUserSession session) {
    return User(
      name: session.idToken.payload['name'],
      email: session.idToken.payload['email'],
      username: session.idToken.payload['cognito:username'],
      idToken: session.getIdToken().getJwtToken().toString(),
      // accessToken: session.getAccessToken(),
      // idToken: session.getIdToken(),
      // refreshToken: session.getRefreshToken(),
    );
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, username: $username, idToken: $idToken}';
  }
}
