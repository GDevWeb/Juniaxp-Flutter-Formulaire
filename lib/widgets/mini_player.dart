import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends StatefulWidget {
  final String audioUrl;

  const MiniPlayer({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Prépare le fichier audio
    _audioPlayer.setUrl(widget.audioUrl).catchError((error) {
      debugPrint('Erreur de chargement de l\'audio : $error');
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange,
            child: Icon(Icons.music_note, color: Colors.black),
          ),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.orange,
            ),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.orange),
            onPressed: () {
              _audioPlayer.stop();
              setState(() {
                _isPlaying = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
