import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:linear/pages/home_page.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/pages/search_page.dart';
import 'package:linear/pages/create_community.dart';
import 'package:linear/pages/get_community.dart';
import 'package:linear/pages/profile_page.dart';
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/make_community.dart';
import 'package:linear/pages/viewPost.dart';
import 'package:linear/pages/createPost.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserProvider userProvider = UserProvider();

  await userProvider.loadUserFromPreferences();

  runApp(
    LinearApp(
      userProvider: userProvider,
    ),
  );
}

class LinearApp extends StatelessWidget {
  const LinearApp({super.key, required this.userProvider});

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    Future<User?> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userProvider),
      ],
      child: MaterialApp(
          title: 'Linear',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (isUserDataLoaded(snapshot)) {
                      return const LoginPage();
                    }
                    return const HomePage();
                }
              }),
              routes: {
                '/home': (context) => const HomePage (),
                '/login': (context) => const LoginPage(),
                '/signup': (context) => const SignUpPage(),
                '/search': (context) => const SearchPage (),
                '/profile': (context) => const ProfilePage (),
                '/community': (context) => const CommunityPage(),
                '/createCommunity': (context) => const CreateCommunityPage(),
                '/viewPost': (context) => const ViewPostPage(),
                '/createPost': (context) => const CreatePostPage(),
                //'sixth': (context) => const SettingsRoute (),
              },),
    );
  }


bool isUserDataLoaded(AsyncSnapshot<User?> snapshot) {
    return snapshot.data?.email == null && snapshot.data?.username == null && snapshot.data?.name == null && snapshot.data?.idToken == null;
  }
}
