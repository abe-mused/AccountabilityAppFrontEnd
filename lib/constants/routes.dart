import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/auth_pages/sign_up.dart';
// import 'package:linear/pages/community_page/community_page.dart';
import 'package:linear/pages/create_community_page/create_community_page.dart';
import 'package:linear/pages/home_page/home_page.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/pages/search_page/search_page.dart';
import 'package:linear/pages/profile_page/comment_page.dart';

Map<String, Widget Function(BuildContext context)> linearRoutes = {
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/signup': (context) => const SignUpPage(),
  '/search': (context) => const SearchPage(),
  '/profile': (context) => const ProfilePage(),
  // '/community': (context) => const CommunityPage(),
  '/createCommunity': (context) => const CreateCommunityPage(),
  '/commentPage': (context) => const CommentPage(),
};
