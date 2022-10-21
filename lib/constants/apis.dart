import 'dart:developer' as developer;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> postCommunity(
    String communityName, String token) async {
  const url =
      'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community';
  return await http.post(
    Uri.parse(url),
    body: jsonEncode({
      "communityName": communityName,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      developer.log("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        print("Success!");
        return {'status': true, 'message': 'Community Succesfully Created.'};
      } else {
        return {
          'status': false,
          'message':
              'An error occurred while creating the community, please try again.'
        };
      }
    },
  );
}

Future<Map<String, dynamic>> getCommunity(
    String communityName, String token) async {
  var url =
      'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/search?communityName=$communityName';
  try {return await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then((response) {
      developer.log("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var community = jsonResponse['community'];
        if (community != null && community[0] != null) {
          print("Success!: ${community[0]}");
          return {
            'status': true,
            'message': 'Community Succesfully Found.',
            'community': community[0]
          };
        }
      }
      return {
      'status': false,
      'message': 'Community not found.'
    };
  });}
  catch (e) {
    print(e);
    print('Communuity[] is null');
    return {
      'status': false,
      'message': 'Community not found.'
    };
  }
}

Future<Map<String, dynamic>> getProfile(
    String token) async {
  var url =
      'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/profile';
  try {return await http.get(
    Uri.parse(url),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then((response) {
      developer.log("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var user = jsonResponse['user'];
        if (user != null && user[0] != null) {
          print("Success!: ${user[0]}");
          return {
            'status': true,
            'message': 'User Succesfully Found.',
            'user': user[0]
          };
        }
      }
      return {
      'status': false,
      'message': 'User not found.'
    };
  });}
  catch (e) {
    print(e);
    print('User[] is null');
    return {
      'status': false,
      'message': 'User not found.'
    };
  }
}
