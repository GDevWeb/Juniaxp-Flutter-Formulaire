import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlbumsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _albums = [];
  bool _isLoading = false;

  // Get pour accéder aux albums
  List<Map<String, dynamic>> get albums => _albums;

  // Get pour vérifier si les données sont en cours de chargement
  bool get isLoading => _isLoading;

  // Récup les albums
  Future<void> fetchAlbums({int page = 1}) async {
    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://s3-4987.nuage-peda.fr/music/api/albums?page=$page');

    try {
      // print('Envoi de la requête à $url');
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/ld+json',
          'Content-Type': 'application/json',
        },
      );

      // print('Statut de la réponse : ${response.statusCode}');
      // print('Corps de la réponse : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['member'] != null && data['member'].isNotEmpty) {
          _albums = List<Map<String, dynamic>>.from(data['member'].map((album) {
            return {
              'id': album['id'],
              'title': album['title'],
              'releaseDate': album['releaseDate'],
              'cover': album['cover_image_base64'] ?? album['cover'],
              'artist': album['artist']['name'],
            };
          }));

          // print('Albums récupérés : $_albums');
          print('Albums récupérés : Récupération des albums ok✅');
        } else {
          print('Pas d\'albums disponibles.❗');
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
      print('Erreur lors de la récupération des albums : $e');
    }
  }
}
