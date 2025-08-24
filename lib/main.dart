import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MusicHomePage(),
    );
  }
}

class MusicHomePage extends StatefulWidget {
  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final AudioPlayer _player = AudioPlayer();
  String? fileName;

  Future<void> pickAndPlay() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String? path = result.files.single.path;
      if (path != null) {
        await _player.setFilePath(path);
        _player.play();
        setState(() {
          fileName = result.files.single.name;
        });
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Offline Music Player")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 100, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text(fileName ?? "No song playing",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: pickAndPlay,
              icon: Icon(Icons.library_music),
              label: Text("Pick & Play Song"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _player.pause(),
              icon: Icon(Icons.pause),
              label: Text("Pause"),
            ),
            ElevatedButton.icon(
              onPressed: () => _player.play(),
              icon: Icon(Icons.play_arrow),
              label: Text("Play"),
            ),
            ElevatedButton.icon(
              onPressed: () => _player.stop(),
              icon: Icon(Icons.stop),
              label: Text("Stop"),
            ),
          ],
        ),
      ),
    );
  }
}
