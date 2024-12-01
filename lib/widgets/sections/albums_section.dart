import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../album_detail_page.dart';
import '../../providers/albums_provider.dart';

class AlbumsSection extends StatelessWidget {
  const AlbumsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumsProvider>(
      builder: (context, albumsProvider, _) {
        if (albumsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (albumsProvider.albums.isEmpty) {
          return const Center(
            child: Text(
              'Aucun album disponible pour le moment.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Albums',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: albumsProvider.albums.length,
              itemBuilder: (context, index) {
                final album = albumsProvider.albums[index];
                String? base64Image = album['cover'];

                if (base64Image != null &&
                    base64Image.startsWith('data:image')) {
                  base64Image = base64Image.split(',').last;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AlbumDetailPage(albumId: album['id']),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: base64Image != null
                              ? Image.memory(
                                  base64Decode(base64Image),
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.album,
                                  size: 100,
                                  color: Colors.orange,
                                ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          album['title'],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Artiste : ${album['artist']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
