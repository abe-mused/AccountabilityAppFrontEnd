import 'package:amazon_cognito_identity_dart_2/cognito.dart';

final userPool = CognitoUserPool(
  'us-east-1_0zwXmnQpN',
  '1ip0kt3c8ohsht5ogt6nr2v9qa',
);

Future<void> signUp({required String username, required String password, required String fullName, required String email}) async {
  final userAttributes = [
    AttributeArg(name: 'name', value: fullName),
    AttributeArg(name: 'email', value: email),
  ];

  CognitoUserPoolData? data;
  try {
    data = await userPool.signUp(
      username,
      password,
      userAttributes: userAttributes,
    );
  } catch (e) {
    // ignore: avoid_print
    print("bad news: $e");
  } finally {
    // ignore: avoid_print
    print("not bad news: $data");
  }
}

Future<void> logIn({required String username, required String password}) async {
  final cognitoUser = CognitoUser(username, userPool);
  final authDetails = AuthenticationDetails(
    username: username,
    password: password,
  );
  CognitoUserSession? session;
  try {
    session = await cognitoUser.authenticateUser(authDetails);
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  // ignore: avoid_print
  print("abe says token is: '${session?.getAccessToken().getJwtToken()}'ABEABE");
}
