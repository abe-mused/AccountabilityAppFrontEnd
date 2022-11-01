import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/constants/routes.dart';
import 'package:linear/pages/home_page/home_page.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/util/cognito/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear/constants/themeSettings.dart';
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
  LinearApp({super.key, required this.userProvider});

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
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
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
        routes: linearRoutes,
      ),
    );
  }

  bool isUserDataLoaded(AsyncSnapshot<User?> snapshot) {
    return snapshot.data?.email == null &&
        snapshot.data?.username == null &&
        snapshot.data?.name == null &&
        snapshot.data?.idToken == null;
  }
}
