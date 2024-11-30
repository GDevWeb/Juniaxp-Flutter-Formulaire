import 'package:flutter/material.dart';

class SongDetailPage extends StatelessWidget {
  final int songId;

  const SongDetailPage({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la chanson'),
      ),
      body: Center(
        child: Text(
          'Détails de la chanson avec l\'ID : $songId',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
