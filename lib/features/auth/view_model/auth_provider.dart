import 'dart:convert';

import 'package:chatapp/core/connection/connection_checker.dart';
import 'package:chatapp/core/local_repo/shared_pref.dart';
import 'package:chatapp/core/widgets/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final connectionChecker = Connectionchecker();

  SharedPrefService prefService = SharedPrefService();
  bool _isVerified = false;
  bool _isLoading = false;

  bool get isVerified => _isVerified;
  bool get isLoading => _isLoading;

  void saveUser(String phoneNumber) async {
    await prefService.saveString('uid', phoneNumber);
    notifyListeners();
  }

  void removeUser() async {
    _isVerified = false;
    await prefService.removeString('uid');
    phoneNumber = null;
    notifyListeners();
  }

  String? phoneNumber;

  void loadPhonenumber() {
    phoneNumber = prefService.uid;
  }

  //verify number
  Future<String> verifyNumber(String phoneNumber, String password) async {
    try {
      if (!await connectionChecker.isConnected) {
        return "No internet connection";
      }
      _isLoading = true;
      final res = await http.post(
        Uri.parse('$baseUrl/verify-number'),
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final resbody = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 200) {
        saveUser(resbody['phoneNumber'].toString());
        this.phoneNumber = resbody['phoneNumber'].toString();
        notifyListeners();
        _isVerified = true;
        _isLoading = false;
        return 'Verification completed';
      }
      _isLoading = false;
      return resbody['msg'];
    } catch (e) {
      _isLoading = false;
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> signU(String phoneNumber, String password) async {
    try {
      if (!await connectionChecker.isConnected) {
        return "No internet connection";
      }
      _isLoading = true;
      final res = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final resbody = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode == 201) {
        _isLoading = false;
        return 'Sign up success!';
      }
      _isLoading = false;
      return resbody['msg'];
    } catch (e) {
      return 'error';
    }
  }
}
