import 'package:flutter/material.dart';
import 'package:linear/auth_pages/login_page.dart';
import 'package:linear/auth_pages/signup_page.dart';
import 'package:linear/pages/common_widgets/create_community_page.dart';
import 'package:linear/pages/home_page.dart';
import 'package:linear/pages/profile_page/profile_page.dart';
import 'package:linear/pages/search_page.dart';
import 'package:linear/pages/goal_page.dart';

Map<String, Widget Function(BuildContext context)> linearRoutes = {
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginPage(),
  '/signup': (context) => const SignUpPage(),
  '/search': (context) => const SearchPage(),
  '/goals': (context) => const GoalPage(),
  '/profile': (context) => const ProfilePage(),
  '/createCommunity': (context) => const CreateCommunityPage(),
};
