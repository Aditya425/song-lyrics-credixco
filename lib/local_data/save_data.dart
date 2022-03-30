import 'package:music_player/modal/track.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static late SharedPreferences _sharedPreferences;
  static List<String> tracks = [];
  static const String _KEY = "track_list";
  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void addTracks(Track track) async {
    tracks.add(track.trackId.toString() + "*" + track.trackName + "*" + "${track.hasLyrics}");
    await _sharedPreferences.setStringList(_KEY, tracks);
  }

  static List<String>? getTracks() {
    return _sharedPreferences.getStringList(_KEY);
  }

  static Future<bool> removeTrack(String trackId) async {
    tracks.remove(trackId);
    return await _sharedPreferences.setStringList(_KEY, tracks);
  }
}