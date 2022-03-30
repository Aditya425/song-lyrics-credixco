import 'package:flutter/material.dart';
import 'package:music_player/local_data/save_data.dart';
import 'package:music_player/songs_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SaveData.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SongsList(),
    );
  }
}
