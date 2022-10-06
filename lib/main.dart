import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:linear/pages/home_page.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';

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
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignUpPage(),
          }),
    );
=======
import 'package:linear/pages/community_page.dart';
import 'package:linear/pages/search_page.dart'; 
import 'package:linear/pages/profile_page.dart'; 
import 'package:linear/pages/home_page.dart'; 
import 'package:linear/pages/create_community.dart'; 


void main() {
  //runApp(const MyApp());
  runApp(MaterialApp( 
    initialRoute: '/',
    routes: {
      '/': (context) => const HomePage (),
      '/second': (context) => const SearchPage (),
      '/third': (context) => const ProfilePage (),
      '/fourth': (context) => const CommunityPage(),
      '/fifth': (context) => const CreateCommunityPage (),
      //'sixth': (context) => const SettingsRoute (),
    },
    theme:  ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 162, 235, 164),
        primaryColor: Colors.green,
        fontFamily: 'Calibri',
        appBarTheme: AppBarTheme( 
          color: Color.fromARGB(255, 39, 87, 41),
        ),
    ), 
    ));
}

//StatelessWidget cannot use setState, StatefulWidget can
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      //TODO: When we add more widgets to this app that show the colors, add theme based on the
      //color palette we picked in this issue: https://github.com/abe-mused/AccountabilityAppFrontEnd/issues/7
       title: 'Linear Accountability App',
       theme:  ThemeData(
        scaffoldBackgroundColor: Colors.green,
        primaryColor: Colors.green,
        fontFamily: 'Calibri',

        ),
       home: const HomePage(),
      );
  }

  bool isUserDataLoaded(AsyncSnapshot<User?> snapshot) {
    return snapshot.data?.email == null && snapshot.data?.username == null && snapshot.data?.name == null && snapshot.data?.idToken == null;
  }
}
