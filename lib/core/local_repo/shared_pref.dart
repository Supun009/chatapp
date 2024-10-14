import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService extends ChangeNotifier {
  static final SharedPrefService _instance = SharedPrefService._internal();
  SharedPreferences? _preferences;

  String? uid;

  // Private constructor for singleton pattern
  SharedPrefService._internal();

  // Public factory method to access the singleton instance
  factory SharedPrefService() {
    return _instance;
  }

  // Initialize shared preferences (call this once when your app starts)
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    uid = _preferences?.getString('uid'); // Load saved UID
    notifyListeners();
  }

  // Save a string value
  Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
    uid = value;
    notifyListeners();
  }

  // Retrieve a saved string value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Remove a saved string
  Future<void> removeString(String key) async {
    await _preferences?.remove(key);
    uid = null;
  }
}
