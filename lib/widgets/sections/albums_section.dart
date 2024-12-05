import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../album_detail_page.dart';
import '../../providers/albums_provider.dart';
import './custom_search_bar.dart';

class AlbumsSection extends StatefulWidget {
  const AlbumsSection({super.key});

  @override
  State<AlbumsSection> createState() => _AlbumsSectionState();
}

class _AlbumsSectionState extends State<AlbumsSection> {
  String _searchQuery = '';

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
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Filtrer les albums selon la recherche
        final filteredAlbums = albumsProvider.albums.where((album) {
          return album['title']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();

        // Si aucun résultat, afficher un message avec une option de réinitialisation
        if (filteredAlbums.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Aucun résultat ne correspond à votre recherche.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = ''; // Réinitialiser la recherche
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Réinitialiser la recherche'),
              ),
            ],
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

            // Barre de recherche
            CustomSearchBar(
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),

            const SizedBox(height: 10),

            // Liste des albums filtrés
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: filteredAlbums.length,
              itemBuilder: (context, index) {
                final album = filteredAlbums[index];
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
                        const SizedBox(height: 5),
                        Text(
                          'Artiste : ${album['artist']}',
                          textAlign: TextAlign.center,
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
