// ignore_for_file: avoid_print

import 'dart:async';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';

const userPoolId = 'us-east-1_0zwXmnQpN';
const clientId = '1ip0kt3c8ohsht5ogt6nr2v9qa';

final userPool = CognitoUserPool(userPoolId, clientId);

class AuthUtility {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final cognitoUser = CognitoUser(username, userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );
    CognitoUserSession? session;
    try {
      session = await cognitoUser.authenticateUser(authDetails);

      if (session != null) {
        User user = User.fromCognitoSession(session);

        UserPreferences().saveUser(user);
        return {'status': true, 'message': 'Successful', 'user': user};
      } else {
        throw Exception('Session is null');
      }
    } on CognitoUserNewPasswordRequiredException catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {'status': false, 'message': 'New password required, please reset your password'};
    } on CognitoUserConfirmationNecessaryException catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {'status': false, 'message': 'Please confirm you email address.'};
    } on CognitoClientException catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {'status': false, 'message': 'Please ensure you entered the correct credentials.'};
    } catch (e) {
      print("An error occurred while authenticating user:  $e");
      return {'status': false, 'message': 'Unsuccessful login, an unknown error occurred. Please try again.'};
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
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
      //TODO: add exception handling for user already exists
    } catch (e) {
      print("An error occurred while creating the user's account:  $e");
      return {'status': false, 'message': 'An error occurred while creating the account, please try again.'};
    }
    print("not bad news: $data");

    return {'status': true, 'message': 'Account created successfully, please confirm your email address.'};
  }
}
