import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:linear/util/cognito/auth_util.dart' as auth_utility;

getTokenOrRedirectToLogin(BuildContext context) async {
  dynamic token = await auth_utility.getAuthToken();
  if (token == null) {
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/login');
  }
  return token;
}

Future<Map<String, dynamic>> createCommunity(BuildContext context, String communityName) async {
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
        return {'status': true, 'message': 'results returned', 'searchResults': jsonResponse};
      }
      throw "results not found";
    });
  } catch (e) {
    print(e);
    return {'status': false, 'message': 'results not found.'};
  }
}

Future<Map<String, dynamic>> getProfile(BuildContext context, String username) async {
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
    print(e);
    return {'status': false, 'message': 'User not found.'};
  }
}

Future<Map<String, dynamic>> createPost(BuildContext context, String postTitle, String postBody, String communityName, String? imageUrl) async {
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
      print(response.body.toString());
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
    print(e);
    return {'status': false, 'message': 'Post not found.'};
  }
}

Future<Map<String, dynamic>> getPostsForCommunity(BuildContext context, String communityName) async {
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
    print(e);
    return {'status': false, 'message': 'Community not found.'};
  }
}

Future<Map<String, dynamic>> getPostWithComments(BuildContext context, String postId) async {
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
    print(e);
    return {'status': false, 'message': 'Community not found.'};
  }
}

Future<Map<String, dynamic>> createComment(BuildContext context, String commentBody, String postId) async {
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
    print(e);
    print('Goals[] is null');
    return {'status': false, 'message': 'Goals not found.'};
  }
}

Future<Map<String, dynamic>> deleteGoal(BuildContext context, String goalId) async {
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
        print("Success!");
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
      print("Response body: ${response.body} code: ${response.statusCode}");
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