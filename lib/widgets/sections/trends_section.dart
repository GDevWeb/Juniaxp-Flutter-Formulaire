import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/songs_provider.dart';

class TrendsSection extends StatelessWidget {
  const TrendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongsProvider>(
      builder: (context, songsProvider, _) {
        if (songsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (songsProvider.songs.isEmpty) {
          return const Center(
            child: Text(
              'Aucune chanson disponible pour le moment.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tendances',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songsProvider.songs.length,
                itemBuilder: (context, index) {
                  final song = songsProvider.songs[index];
                  final album = song['album'];
                  String? base64Image = album['cover_image_base64'];

                  if (base64Image != null &&
                      base64Image.startsWith('data:image')) {
                    base64Image = base64Image.split(',').last;
                  }

                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SizedBox(
                        width: 120,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: base64Image != null
                                  ? Image.memory(
                                      base64Decode(base64Image),
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.music_note, size: 100),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              song['title'],
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '(${song['listenCount']} écoutes)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
