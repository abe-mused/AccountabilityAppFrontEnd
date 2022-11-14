import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> postCommunity(String communityName, String token) async {
  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community';
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

Future<Map<String, dynamic>> getSearchResults(String searchTerm, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/search?searchTerm=$searchTerm';
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

Future<Map<String, dynamic>> getProfile(String username, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/profile?username=$username';
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

Future<Map<String, dynamic>> createPost(String postTitle, String postBody, String communityName, String token, String? imageUrl) async {
  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post';
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
        var postId = jsonResponse['postId'];
        var creationDate = jsonResponse['creationDate'];
        return {'status': true, 'message': 'Post Succesfully Created.', 'postId':postId, 'creationDate': creationDate};
      } else {
        return {'status': false, 'message': 'An error occurred while creating the post, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> deletePost(String postId, String token) async {
  const url ='https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post';
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

Future<Map<String, dynamic>> likePost(String postId, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/like?postId=$postId';
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

Future<Map<String, dynamic>> getPostsForCommunity(String communityName, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/community?communityName=$communityName';
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
        var community = jsonResponse['community'];
        var posts = jsonResponse['posts'];
        return {
          'status': true,
          'message': 'Community Succesfully Found.',
          'community': community,
          'posts': posts,
        };
      }
      return {'status': false, 'message': 'Community not found.'};
    });
  } catch (e) {
    print(e);
    return {'status': false, 'message': 'Community not found.'};
  }
}

Future<Map<String, dynamic>> getPostWithComments(String postId, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/post?postId=$postId';
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

Future<Map<String, dynamic>> createComment(String commentBody, String postId, String token) async {
  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/comment';
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

Future<Map<String, dynamic>> deleteComment(String postId, String commentId, String token) async {
  const url ='https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/comment';
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

Future<Map<String, dynamic>> joinAndLeave(String communityName, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/join?communityName=$communityName';
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

Future<Map<String, dynamic>> followAndUnfollow(String otherUser, String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/follow?otherUser=$otherUser';
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

Future<Map<String, dynamic>> createGoal(int checkInGoal, String goalBody, String communityName, String token) async {
  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal';
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
        return {'status': true, 'message': 'Goal Succesfully Created.'};
      } else {
        return {'status': false, 'message': 'An error occurred while creating the post, please try again.'};
      }
    },
  );
}

Future<Map<String, dynamic>> getGoalsForGoalPage(String token) async {
  var url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal';
  try {
    return await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    ).then((response) {
      print("Response body goalsForGoalPage: ${response.body}");
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

Future<Map<String, dynamic>> deleteGoal(String goalId, String token) async {
  const url ='https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/goal';
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

Future<Map<String, dynamic>> getHomeFeed(String token, dynamic pageTokens) async {
  const url = 'https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/home';
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

Future<void> createReport(dynamic reportBody, String token) async {
  http.post(
    Uri.parse('https://qgzp9bo610.execute-api.us-east-1.amazonaws.com/prod/report'),
    body: jsonEncode(reportBody),
    headers: {
      "Authorization": token,
      "Content-Type": "application/json",
    },
  );
}
