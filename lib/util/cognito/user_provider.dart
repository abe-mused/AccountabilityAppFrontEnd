import 'package:flutter/foundation.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadUserFromPreferences() async {
    User? user = await UserPreferences().getUser();

    print("User loaded fomr preferences: ${user?.email} - ${user?.name} - ${user?.username} - ${user?.idToken}");

    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }
}
