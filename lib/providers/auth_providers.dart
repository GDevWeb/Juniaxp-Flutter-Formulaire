import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _userInfo;

  // Get pour le token
  String? get token => _token;

  // Get pour les infos utilisateur
  Map<String, dynamic>? get userInfo => _userInfo;

  // Vérif si l'utilisateur est auth
  bool isAuthenticated() {
    return _token != null;
  }

  // Déf le token et les infos utilisateur
  Future<void> setAuthData(String token, Map<String, dynamic> userInfo) async {
    _token = token;
    _userInfo = userInfo;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userInfo', jsonEncode(userInfo));

    notifyListeners();
  }

  // Loading des données utilisateur depuis SharedPreferences
  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final savedUserInfo = prefs.getString('userInfo');
    if (savedUserInfo != null) {
      _userInfo = jsonDecode(savedUserInfo);
    }
    notifyListeners();
  }

  // Logout de l'utilisateur
  Future<void> logout() async {
    _token = null;
    _userInfo = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userInfo');

    notifyListeners();
  }
}
