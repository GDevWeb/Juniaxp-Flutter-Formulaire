import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SongDetailPage extends StatelessWidget {
  final int songId;

  const SongDetailPage({super.key, required this.songId});

  // Fonction pour récup les détails du titre
  Future<Map<String, dynamic>> fetchSongDetail(int id) async {
    final url = Uri.parse('https://s3-4987.nuage-peda.fr/music/api/songs/$id');

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
          'Erreur lors de la récupération des détails de la chanson : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de la chanson'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchSongDetail(songId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final song = snapshot.data!;
            final album = song['album'];
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
                    // cover de l'album
                    base64Image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              base64Decode(base64Image),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.music_note, size: 200),
                    const SizedBox(height: 20),

                    // Titre de la chanson
                    Text(
                      song['title'],
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
                    const SizedBox(height: 10),

                    // Album
                    Text(
                      'Album : ${album['title']}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Durée et Nombre d'écoutes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Durée',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${song['duration']} min',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Écoutes',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${song['listenCount']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
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
