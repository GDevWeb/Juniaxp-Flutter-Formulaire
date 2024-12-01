import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './album_detail_page.dart';
import './providers/albums_provider.dart';
import './providers/artists_provider.dart';
import './providers/auth_providers.dart';
import './providers/songs_provider.dart';

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
      // Charge les données dès l'ouverture de la page
      Provider.of<AlbumsProvider>(context, listen: false).fetchAlbums();
      Provider.of<ArtistsProvider>(context, listen: false).fetchArtists();
      Provider.of<SongsProvider>(context, listen: false)
          .fetchSongs(1); // Page 1
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
        children: const [
          // Section Albums
          AlbumsSection(),

          SizedBox(height: 20),

          // Section Artistes
          ArtistsSection(),

          SizedBox(height: 20),

          // Section Tendances
          TrendsSection(),
        ],
      ),
    );
  }
}

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
              style: TextStyle(fontSize: 16),
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
                  color: Colors.orange),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4, // Ratio
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
                        const SizedBox(height: 5),
                        Text(
                          'Artiste : ${album['artist']}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.orange),
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

class ArtistsSection extends StatelessWidget {
  const ArtistsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistsProvider>(
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
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.orange),
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
    );
  }
}

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
                  color: Colors.orange),
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
                    // onTap: () {
                    //   var id;
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => SongDetailPage(
                    //           songId: id), // Supposons `song` comme paramètre
                    //     ),
                    //   );
                    // },
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
                                  fontSize: 12, color: Colors.orange),
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
