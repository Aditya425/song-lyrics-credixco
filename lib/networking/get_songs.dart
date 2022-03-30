import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_player/modal/track.dart';

class GetSongs {
  Future<List<Track>> getSongs() async {
    const String _API_KEY = "a5fdbfc8d9661414ecc4e865f1a2211d";
    const String _URL = "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$_API_KEY";
    List<Track> trackList = [];
    var tracks = await http.get(Uri.parse(_URL));
    //print(jsonDecode(tracks.body)["message"]["body"]["track_list"][0]["track"]["track_id"]);
    var body = jsonDecode(tracks.body)["message"]["body"]["track_list"];
    for (int i = 0; i < body.length; i++) {
      Track track = Track(
        trackId: body[i]["track"]["track_id"],
        trackName: body[i]["track"]["track_name"],
        hasLyrics: body[i]["track"]["has_lyrics"],
        albumId: body[i]["track"]["album_id"],
        albumName: body[i]["track"]["album_name"]
      );
      trackList.add(track);
    }
    return trackList;
  }

  Future<Track> getSongDetails(int trackId) async {
    print(trackId);
    const String _API_KEY = "a5fdbfc8d9661414ecc4e865f1a2211d";
    final String url = "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackId&apikey=$_API_KEY";
    var tracks = await http.get(Uri.parse(url));
    var body = jsonDecode(tracks.body)["message"]["body"]["track"];
    Track track = Track(
      trackId: trackId,
      trackName: body["track_name"],
      hasLyrics: body["has_lyrics"],
      albumId: body["album_id"],
      albumName: body["album_name"],
      singerName: body["artist_name"],
      explicit: body["explicit"],
      rating: body["track_rating"]
    );
    return track;
  }

  Future<String> getLyrics(int trackId, int hasLyrics) async {
    if (hasLyrics == 0) {
      return "Lyrics Not Available";
    }
    const String _API_KEY = "a5fdbfc8d9661414ecc4e865f1a2211d";
    final String url = "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=$_API_KEY";
    var tracks = await http.get(Uri.parse(url));
    String body = jsonDecode(tracks.body)["message"]["body"]["lyrics"]["lyrics_body"];
    return body;
  }
}