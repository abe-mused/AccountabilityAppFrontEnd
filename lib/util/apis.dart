// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linear/constants/themeSettings.dart';
import 'dart:convert';
import 'package:linear/util/cognito/auth_util.dart' as auth_utility;
import 'package:linear/util/cognito/user_preferences.dart';
import 'dart:io';
import 'dart:developer' as developer;

getTokenOrRedirectToLogin(BuildContext context) async {
  dynamic token = await auth_utility.getAuthToken();
  if (token == null) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      barrierColor: MediaQuery.of(context).platformBrightness == Brightness.dark ?
              AppThemes.lightTheme.colorScheme.background
              : AppThemes.darkTheme.colorScheme.background,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
              child: Column(
                children: const [
                  Text(
                    'Oops, it looks like your session has expired.\nRedirecting to login page...',
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.sync_lock_sharp,
                    size: 100,
                  )
                ]
              ),
            ),
          ),
        );
      }
    );
    UserPreferences().removeUser();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
  return token;
}

checkInternetConnection(BuildContext context) async {
  bool isConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 1));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
    }
  } on SocketException catch (_) {
    developer.log('Not connected to the internet!');
  }

  if (!isConnected) {
    showModalBottomSheet(
      context: context,
      barrierColor: MediaQuery.of(context).platformBrightness == Brightness.dark ?
              AppThemes.lightTheme.colorScheme.background
              : AppThemes.darkTheme.colorScheme.background,
      builder: (context) {
        return SizedBox(
          height: 400,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
              child: Column(
                children: const [
                  Text(
                    'Oops! We lost you.\nPlease ensure that you are connected to the internet...',
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.wifi_off,
                    size: 100,
                  )
                ]
              ),
            ),
          ),
        );
      }
    );
  } else {
    checkUsageTime(context);
  }

  return isConnected;
}

checkUsageTime(BuildContext context) async {
  bool shouldDisplayUsageNotification = await UserPreferences().shouldShowUsageNotification();

  if (shouldDisplayUsageNotification) {
    showModalBottomSheet(
      context: context,
      barrierColor: MediaQuery.of(context).platformBrightness == Brightness.dark ?
              AppThemes.lightTheme.colorScheme.background
              : AppThemes.darkTheme.colorScheme.background,
      builder: (context) {
        return SizedBox(
          height: 600,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
              child: Column(
                children: const [
                  Text(
                    "It looks like you've spent more than 30 mins on the app.\nTake a break!",
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.free_breakfast,
                    size: 100,
                  )
                ]
              ),
            ),
          ),
        );
      }
    );
  }
}

Future<Map<String, dynamic>> createCommunity(BuildContext context, String communityName) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community';
  String token = await getTokenOrRedirectToLogin(context);
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
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Community Succesfully Created.'};
      } else if (response.body == '{"message":"The community already exists!"}') {
        return {'status': false, 'message': 'The community already exists!'};
      } else {
        return {'status': false, 'message': 'An error occurred while creating the community, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> getSearchResults(BuildContext context, String searchTerm) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/search?searchTerm=$searchTerm';
  String token = await getTokenOrRedirectToLogin(context);
  try {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return {'status': true, 'searchResults': jsonResponse["searchResults"]};
      }
      return {'status': false, 'message': 'results not found.'};
    });
  } catch (e) {
    developer.log(e.toString());
    return {'status': false, 'message': 'results not found.'};
  }
}

Future<Map<String, dynamic>> getProfile(BuildContext context, String username) async {

  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/profile?username=$username';
  String token = await getTokenOrRedirectToLogin(context);
  try {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var user = jsonResponse['user'];
        var posts = jsonResponse['posts'];
        if (user != null) {
          return {'status': true, 'message': 'User Succesfully Found.', 'user': user, 'posts': posts};
        }
      }
      return {'status': false, 'message': 'User not found.'};
    });
  } catch (e) {
    developer.log(e.toString());
    return {'status': false, 'message': 'User not found.'};
  }
}

Future<Map<String, dynamic>> createPost(BuildContext context, String postTitle, String postBody, String communityName, String? imageUrl) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post';
  String token = await getTokenOrRedirectToLogin(context);
  var body = {
      "postTitle": postTitle,
      "postBody": postBody,
      "communityName": communityName,
    };
  if (imageUrl != null) {
    body['imageUrl'] = imageUrl;
  }
  return await http.post(
    Uri.parse(url),
    body: jsonEncode(body),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return {'status': true, 'message': 'Post Succesfully Created.', 'newPost': jsonResponse['newPost']};
      } else {
        return {'status': false, 'message': 'An error occurred while creating the post, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> deletePost(BuildContext context, String postId) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  const url ='https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.delete(
    Uri.parse(url),
    body: jsonEncode({
      "postId": postId,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Post Succesfully Deleted.'};
      } else {
        return {
          'status': false,
          'message':
              'An error occurred while deleting the post, please try again.'
        };
      }
    },
  );
}

Future<Map<String, dynamic>> likePost(BuildContext context, String postId) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  

  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/like?postId=$postId';
  String token = await getTokenOrRedirectToLogin(context);
  try {
    return await http.patch(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var liked = jsonResponse['liked'];
        return {
          'status': true,
          'liked': liked,
        };
      }
      return {'status': false, 'message': 'Post not found.'};
    });
  } catch (e) {
    developer.log(e.toString());
    return {'status': false, 'message': 'Post not found.'};
  }
}

Future<Map<String, dynamic>> getPostsForCommunity(BuildContext context, String communityName) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  

  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community?communityName=$communityName';
  String token = await getTokenOrRedirectToLogin(context);
  try {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return {
          'status': true,
          'message': 'Community Succesfully Found.',
          'community': jsonResponse['community'],
          'posts': jsonResponse['posts'],
          "goals": jsonResponse['goals'],
        };
      }
      return {'status': false, 'message': 'Community not found.'};
    });
  } catch (e) {
    developer.log(e.toString());
    return {'status': false, 'message': 'Community not found.'};
  }
}

Future<Map<String, dynamic>> getPostWithComments(BuildContext context, String postId) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post?postId=$postId';
  String token = await getTokenOrRedirectToLogin(context);
  try {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var comments = jsonResponse['comments'];
        var post = jsonResponse['post'];
        return {
          'status': true,
          'message': 'Community Succesfully Found.',
          'comments': comments,
          'post': post,
        };
      }
      return {'status': false, 'message': 'Post not found.'};
    });
  } catch (e) {
    developer.log(e.toString());
    return {'status': false, 'message': 'Community not found.'};
  }
}

Future<Map<String, dynamic>> createComment(BuildContext context, String commentBody, String postId) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  

  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/comment';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.post(
    Uri.parse(url),
    body: jsonEncode({
      "postId": postId,
      "commentBody": commentBody,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var comment = jsonResponse['comment'];
        return {'status': true, 'message': 'comment Succesfully Created.', 'comment': comment};
      } else {
        return {'status': false, 'message': 'An error occurred while creating the comment, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> deleteComment(BuildContext context, String postId, String commentId) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  const url ='https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/comment';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.delete(
    Uri.parse(url),
    body: jsonEncode({
      "postId": postId,
      "commentId": commentId,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Comment Succesfully Deleted.'};
      } else {
        return {
          'status': false,
          'message':
              'An error occurred while deleting the comment, please try again.'
        };
      }
    },
  );
}

Future<Map<String, dynamic>> joinAndLeave(BuildContext context, String communityName) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/join?communityName=$communityName';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.patch(
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
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Community joined/left'};
      } else {
        return {'status': false, 'message': 'An error occurred while joining/leaving, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> followAndUnfollow(BuildContext context, String otherUser) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/follow?otherUser=$otherUser';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.patch(
    Uri.parse(url),
    body: jsonEncode({
      "otherUser": otherUser,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'User followed/unfollowed'};
      } else {
        return {'status': false, 'message': 'An error occurred while following/unfollowing, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> createGoal(BuildContext context, int checkInGoal, String goalBody, String communityName) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.post(
    Uri.parse(url),
    body: jsonEncode({
      "checkInGoal": checkInGoal,
      "goalBody": goalBody,
      "communityName": communityName,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Goal Succesfully Created.', 'newGoal': jsonDecode(response.body)['newGoal']};
      } else {
        return {'status': false, 'message': 'An error occurred while creating the post, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> getGoalsForGoalPage(BuildContext context) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal';
  String token = await getTokenOrRedirectToLogin(context);
  try {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var goals = jsonResponse['goals'];
        return {
          'status': true,
          'message': 'Goals Succesfully Found.',
          'goals': goals,
        };
      }
      return {'status': false, 'message': 'Goals not found.'};
    });
  } catch (e) {
    developer.log(e.toString());
    return {'status': false, 'message': 'Goals not found.'};
  }
}

Future<Map<String, dynamic>> deleteGoal(BuildContext context, String goalId) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }  
  
  const url ='https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.delete(
    Uri.parse(url),
    body: jsonEncode({
      "goalId": goalId,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'Goal Succesfully Deleted.'};
      } else {
        return {
          'status': false,
          'message':
              'An error occurred while deleting the goal, please try again.'
        };
      }
    },
  );
}

Future<Map<String, dynamic>> getHomeFeed(BuildContext context, dynamic pageTokens) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/home';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.post(
    Uri.parse(url),
    body: jsonEncode({
      "tokens": pageTokens ?? {}
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body)['postsData'];
        return {
          'status': true,
          'posts': jsonResponse['posts'],
          'tokens': jsonResponse['tokens'],
          'nextPageMightContainMorePosts': jsonResponse['nextPageMightContainMorePosts']
        };
      } else {
        return {'status': false };
      }
    },
  );
}

Future<void> createReport(BuildContext context, dynamic reportBody) async {
  String token = await getTokenOrRedirectToLogin(context);
  http.post(
    Uri.parse('https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/report'),
    body: jsonEncode(reportBody),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  );
}

Future<Map<String, dynamic>> changeProfilePicture(BuildContext context, String imageUrl) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }

  String token = await getTokenOrRedirectToLogin(context);
  return http.post(
    Uri.parse('https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/profile'),
    body: jsonEncode({
      "imageUrl": imageUrl
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {
          'status': true,
        };
      } else {
        return {'status': false };
      }
    },
  );
}

Future<Map<String, dynamic>> finishOrExtend(BuildContext context, String goalId, bool isFinished, int goalExtension) async {
  
  if(! (await checkInternetConnection(context))){
    return {'success': false, 'message': 'No internet connection'};
  }
  
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal?goalId=$goalId&isFinished=$isFinished&goalExtension=$goalExtension';
  String token = await getTokenOrRedirectToLogin(context);
  return await http.patch(
    Uri.parse(url),
    body: jsonEncode({
      "goalId": goalId,
      "goalStatus": isFinished,
      "goalExtension": goalExtension,
    }),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        return {'status': true, 'message': 'User changed status'};
      } else {
        return {'status': false, 'message': 'An error occurred while cheanging goal status, please try again.'};
      }
    },
  );
}