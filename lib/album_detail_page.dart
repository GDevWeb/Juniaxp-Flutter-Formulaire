import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AlbumDetailPage extends StatelessWidget {
  final int albumId;

  const AlbumDetailPage({super.key, required this.albumId});

  // Fonction pour formater la date
  String formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return DateFormat('dd MMMM yyyy', 'fr_FR').format(date); // Français
    } catch (e) {
      return timestamp; // En cas d'erreur, retourner la valeur brute
    }
  }

  // Fonction pour récupérer les détails d'un album
  Future<Map<String, dynamic>> fetchAlbumDetail(int id) async {
    final url = Uri.parse('https://s3-4987.nuage-peda.fr/music/api/albums/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/ld+json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Erreur : ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération des détails de l\'album : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'album'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchAlbumDetail(albumId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final album = snapshot.data!;
            String? base64Image = album['cover_image_base64'];

            if (base64Image != null && base64Image.startsWith('data:image')) {
              base64Image = base64Image.split(',').last;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image de couverture
                    base64Image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(
                              base64Decode(base64Image),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.album, size: 200),
                    const SizedBox(height: 20),

                    // Titre de l'album
                    Text(
                      album['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Artiste
                    Text(
                      'Artiste : ${album['artist']['name']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date de sortie
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date de sortie :',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              formatDate(album['releaseDate']),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.orange.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Bouton de retour
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Retour'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Aucune donnée disponible.'));
          }
        },
      ),
    );
  }
}
