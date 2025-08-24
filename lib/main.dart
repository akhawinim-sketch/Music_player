import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ask for storage/audio permission
  var status = await Permission.audio.request();

  if (status.isGranted) {
    runApp(const MyApp());
  } else {
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Permission denied. Please allow to continue.")),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MusicHome(),
    );
  }
}

class MusicHome extends StatefulWidget {
  const MusicHome({super.key});

  @override
  State<MusicHome> createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offline Music Player")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!isPlaying) {
                  await _audioPlayer.play(AssetSource("music/song.mp3"));
                  setState(() {
                    isPlaying = true;
                  });
                } else {
                  await _audioPlayer.pause();
                  setState(() {
                    isPlaying = false;
                  });
                }
              },
              child: Text(isPlaying ? "Pause" : "Play"),
            ),
          ],
        ),
      ),
    );
  }
}
