import 'package:shared_preferences/shared_preferences.dart';

/// A class to manage session tokens in shared preferences. Used for
/// keeping track of logged in users in eg3
class SessionManager {
  static const String _sessionKey = 'sessionToken';
  static const String _userKey = 'userName';

  // Method to check if a user is logged in (has an active session).
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString(_sessionKey);
    return sessionToken != null;
  }

  // Method to retrieve the session token.
  static Future<String> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return "Bearer ${prefs.getString(_sessionKey) ?? ''}";
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey) ?? '';
  }

  // Method to set the session token.
  static Future<void> setSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, token);
  }

  //Method to set the Session Username
  static Future<void> setUserName(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userId);
  }

  // Method to clear the session token, effectively logging the user out.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
