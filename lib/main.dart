import 'package:flutter/material.dart';
import 'package:linear/auth_pages/login_page.dart';
import 'package:linear/constants/routes.dart';
import 'package:linear/pages/home_page.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';
import 'package:linear/constants/themeSettings.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const LinearApp(),
  );
}

class LinearApp extends StatelessWidget {
  const LinearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linear',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      home: FutureBuilder(
          future: UserPreferences().getUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!isUserDataLoaded(snapshot)) {
                  return const LoginPage();
                }
                UserPreferences().setActiveTab(0);
                return const HomePage();
            }
          }),
      routes: linearRoutes,
    );
  }

  bool isUserDataLoaded(AsyncSnapshot<User?> snapshot) {
    return snapshot.data?.email != null &&
        snapshot.data?.username != null &&
        snapshot.data?.name != null &&
        snapshot.data?.idToken != null &&
        snapshot.data?.idTokenExpiration != null &&
        snapshot.data?.refreshToken != null;
  }
}
