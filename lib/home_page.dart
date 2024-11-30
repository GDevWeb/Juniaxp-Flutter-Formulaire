import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/albums_provider.dart';
import './providers/artists_provider.dart';
import './providers/auth_providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Charger les albums et les artistes lors de l'ouverture de la page
      Provider.of<AlbumsProvider>(context, listen: false).fetchAlbums();
      Provider.of<ArtistsProvider>(context, listen: false).fetchArtists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music App'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isAuthenticated()) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authProvider.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Albums
          Consumer<AlbumsProvider>(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: albumsProvider.albums.length,
                      itemBuilder: (context, index) {
                        final album = albumsProvider.albums[index];
                        String? base64Image = album['cover'];

                        if (base64Image != null &&
                            base64Image.startsWith('data:image')) {
                          base64Image = base64Image.split(',').last;
                        }

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              base64Image != null
                                  ? Image.memory(
                                      base64Decode(base64Image),
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.album, size: 100),
                              const SizedBox(height: 10),
                              Text(
                                album['title'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Artiste : ${album['artist']}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Section Artistes
// Section Artistes
          Consumer<ArtistsProvider>(
            builder: (context, artistsProvider, _) {
              if (artistsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (artistsProvider.artists.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun artiste disponible pour le moment.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Artistes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: artistsProvider.artists.length,
                      itemBuilder: (context, index) {
                        final artist = artistsProvider.artists[index];
                        String? base64Image = artist['image'];

                        if (base64Image != null &&
                            base64Image.startsWith('data:image')) {
                          base64Image = base64Image.split(',').last;
                        }

                        return SizedBox(
                          width: 80,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: base64Image != null
                                    ? MemoryImage(base64Decode(base64Image))
                                    : null,
                                child: base64Image == null
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                artist['name'],
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // Tronquer
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
