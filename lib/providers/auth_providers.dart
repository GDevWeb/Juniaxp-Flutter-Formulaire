import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token; // Token

  // accéder au token
  String? get token => _token;

  // sauvegarder le token
  void setToken(String token) {
    _token = token;
    notifyListeners(); //notif de changements auw widgets
  }

  // l'utilisateur est connecté ?
  bool isAuthenticated() {
    return _token != null;
  }

  // logout de l'utilisateur
  void logout() {
    _token = null;
    notifyListeners();
  }
}
