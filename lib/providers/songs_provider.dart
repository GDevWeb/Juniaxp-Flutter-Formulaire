import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SongsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _songs = [];
  bool _isLoading = false;

  // Get pour accéder aux titres
  List<Map<String, dynamic>> get songs => _songs;

  // Get pour vérifier si les données sont en cours de chargement
  bool get isLoading => _isLoading;

  // Méthode pour récup les chansons
  Future<void> fetchSongs(int page) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'https://s3-4987.nuage-peda.fr/music/api/songs?page=$page&order[listenCount]=desc');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/ld+json',
          'Content-Type': 'application/ld+json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['member'] != null && data['member'].isNotEmpty) {
          _songs = List<Map<String, dynamic>>.from(data['member']);
        } else {
          _songs = [];
        }
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception(
            'Erreur : ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Erreur lors de la récupération des chansons : $e');
    }
  }
}
