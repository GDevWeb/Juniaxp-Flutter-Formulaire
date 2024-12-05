import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenPlayer extends StatelessWidget {
  final String videoUrl;

  const FullScreenPlayer({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture vidéo'),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) {
          return Column(
            children: [
              // Vidéo
              Expanded(child: player),
              // Barre de contrôle (optionnelle)
              const SizedBox(height: 20),
              const Text(
                'Détails supplémentaires sur la vidéo ou artiste',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
