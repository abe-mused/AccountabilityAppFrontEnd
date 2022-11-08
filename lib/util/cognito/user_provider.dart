import 'package:flutter/foundation.dart';
import 'package:linear/util/cognito/user.dart';
import 'package:linear/util/cognito/user_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  int _selectedTab = 0;

  User? get user => _user;
  int get selectedTab => _selectedTab;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setSelectedTab(int selectedTab) {
    _selectedTab = selectedTab;
    notifyListeners();
  }

  Future<void> loadUserFromPreferences() async {
    User? user = await UserPreferences().getUser();

    print("User loaded from preferences: username: ${user?.username}");

    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }
}
