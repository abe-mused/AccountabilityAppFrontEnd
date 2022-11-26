import 'package:linear/util/cognito/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:developer' as developer;

const int usageNotificationTimeInMinutes = 30;
class UserPreferences {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("username", user.username);
    prefs.setString("idToken", user.idToken);
    prefs.setInt("idTokenExpiration", user.idTokenExpiration);
    prefs.setString("refreshToken", user.refreshToken);
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? username = prefs.getString("username");
    String? idToken = prefs.getString("idToken");
    int? idTokenExpiration = prefs.getInt("idTokenExpiration");
    String? refreshToken = prefs.getString("refreshToken");

    if (name != null && email != null && username != null && idToken != null && idTokenExpiration != null && refreshToken != null) {
      return User(
        name: name,
        email: email,
        username: username,
        idToken: idToken,
        idTokenExpiration: idTokenExpiration,
        refreshToken: refreshToken,
      );
    } else {
      developer.log("some or all of the User attributes in localStorage is null");
      developer.log(
          "name: $name email: $email username: $username idToken: $idToken idTokenExpiration: $idTokenExpiration refreshToken: $refreshToken");
    }
    return null;
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("username");
    prefs.remove("idToken");
    prefs.remove("idTokenExpiration");
    prefs.remove("refreshToken");
  }

  Future<int> getActiveTab() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? activeTab = prefs.getInt("linearActiveTab");

    return activeTab?? 0;
  }

  Future<void> setActiveTab(int activeTab) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("linearActiveTab", activeTab);
  }

  Future<bool> shouldShowUsageNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? usageStartTime = prefs.getInt("linearAppUsageStartTime");

    if(usageStartTime != null){
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int timeDifference = currentTime - usageStartTime;
      int timeDifferenceInMinutes = timeDifference ~/ 60000; // 60000 milliseconds = 1 minute
      if(timeDifferenceInMinutes >= usageNotificationTimeInMinutes){
        resetAppUsageStartTime();
        return true;
      }
      return false;
    } 
    resetAppUsageStartTime();
    return false;
  }

  Future<void> resetAppUsageStartTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("linearAppUsageStartTime", DateTime.now().millisecondsSinceEpoch);
  }
}
