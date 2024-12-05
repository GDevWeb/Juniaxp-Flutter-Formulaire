import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlbumDetailPage extends StatelessWidget {
  final int albumId;

  const AlbumDetailPage({super.key, required this.albumId});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'album_${album['id']}',
                    child: base64Image != null
                        ? Image.memory(
                            base64Decode(base64Image),
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.album,
                            size: 250,
                            color: Colors.orange,
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    album['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Artiste : ${album['artist']['name']}',
                    style: const TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                ],
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
