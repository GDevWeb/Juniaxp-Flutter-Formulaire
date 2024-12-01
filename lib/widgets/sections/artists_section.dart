import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/artists_provider.dart';

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
                color: Colors.orange,
              ),
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
