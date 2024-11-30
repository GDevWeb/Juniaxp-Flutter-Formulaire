import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArtistsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _artists = [];
  bool _isLoading = false;

  // Get pour accéder aux artistes
  List<Map<String, dynamic>> get artists => _artists;

  // Get pour vérifier si les données sont en cours de chargement
  bool get isLoading => _isLoading;

  // Méthode pour récup les artistes
  Future<void> fetchArtists({int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://s3-4987.nuage-peda.fr/music/api/artists?page=$page');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/ld+json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['member'] != null && data['member'].isNotEmpty) {
          _artists =
              List<Map<String, dynamic>>.from(data['member'].map((artist) {
            return {
              'id': artist['id'],
              'name': artist['name'],
              'image': artist['image_base64'],
            };
          }));

          print('Artistes récupérés : ✅');
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
      print('Erreur lors de la récupération des artistes : $e');
    }
  }
}
