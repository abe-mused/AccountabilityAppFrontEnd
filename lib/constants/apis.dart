import 'package:linear/constants/model/community.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<bool> postCommunity(String text, String token) async {
  developer.log("posting community with name $text and token '$token'");

  return await http.post(
    Uri.parse(
        'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community'),
    body: jsonEncode({
      "communityName": text,
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
        return true;
      } else {
        return false;
      }
    },
  );
  // return false;
}

Future<Community> getCommunity(String text, String token) async {
  developer.log("getting community with name $text and token '$token'");

  return await http.get(
    Uri.parse(
        'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community?communityName=$text'),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      developer.log("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var community = jsonResponse['community'];
        if (community != null && community[0] != null) {
            print("Success!: ${community[0]}");
            return Community.fromJson(community[0]);
        } else if (community != null) {
            print("Community Doesn't exist");
        } else {
            print("Something else");
        }
        return Community(
              communityName: "Error @#12", creator: "error 123@#", creationDate: 10000);
      } else {
          return Community(
              communityName: "Error @#12", creator: "error 123@#", creationDate: 10000);
      }
    }
  );
}

