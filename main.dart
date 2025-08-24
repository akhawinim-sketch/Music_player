 import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MusicApp());
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _player = AudioPlayer();
  List<SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      fetchSongs();
    }
  }

  void fetchSongs() async {
    List<SongModel> songs = await _audioQuery.querySongs();
    setState(() {
      _songs = songs;
    });
  }

  void playSong(String uri) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Offline Music Player 🎶")),
        body: _songs.isEmpty
            ? Center(child: Text("No songs found"))
            : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: _songs[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Icon(Icons.music_note),
                    ),
                    title: Text(_songs[index].title),
                    subtitle: Text(_songs[index].artist ?? "Unknown Artist"),
                    onTap: () => playSong(_songs[index].uri!),
                  );
                },
              ),
      ),
    );
  }
}
