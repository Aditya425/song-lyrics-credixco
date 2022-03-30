import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/modal/track.dart';
import 'package:music_player/networking/get_songs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'networking/check_internet.dart';

class LyricsDetail extends StatefulWidget {
  final int trackId;
  final int hasLyrics;
  LyricsDetail(this.trackId, this.hasLyrics);

  @override
  _LyricsDetailState createState() => _LyricsDetailState();
}

class _LyricsDetailState extends State<LyricsDetail> {
  Track track = Track(trackId: 0, trackName: "trackName", hasLyrics: 0, albumId: 0, albumName: "");
  int f = 0;
  int initiallyIsThere = 1;
  bool isThere = true;
  String lyrics = "";
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  void timer() {
    if (initiallyIsThere == 0) {
      initiallyIsThere = 1;
      checkInternet();
    }
    int isRun = 0;
    Timer.periodic(Duration(seconds: 1), (timer) async {
      bool isNetwork = await CheckInternet().checkConnection();
      if (!isNetwork) {
        isRun = 1;
        isThere = false;
        setState(() {

        });

      }

      if (isRun == 1 && isNetwork) {
        isRun = 0;
        if (isNetwork) {
          isThere = true;
        }
        setState(() {

        });
      }
    });
  }

  void checkInternet() async {
    isThere = await CheckInternet().checkConnection();
    if (isThere) {
      getSongDetails();
    } else {
      initiallyIsThere = 0;
    }
  }

  void getSongDetails() async {
    GetSongs gs = GetSongs();
    track = await gs.getSongDetails(widget.trackId);
    lyrics = await gs.getLyrics(widget.trackId, widget.hasLyrics);
    setState(() {
      f = 1;
    });
}

  @override
  Widget build(BuildContext context) {
    timer();
    var body = f == 0 ? Center(child: SpinKitDoubleBounce(color: Colors.white,),) : SafeArea(
      child: Padding(
        padding: EdgeInsets.all(70.0),
        child: Column(
          children: [
            Text(
              "${track.singerName}",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Font",
                  color: Colors.white54
              ),
            ),
            FittedBox(
              child: Text(
                "Track: ${track.trackName}",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Font",
                    color: Colors.white
                ),
              ),
            ),
            FittedBox(
              child: Text(
                "Album: ${track.albumName}",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Font",
                    color: Colors.white
                ),
              ),
            ),
            Text(
              track.explicit == 1 ? "Explicit: Yes" : "Explicit: No",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Font",
                  color: Colors.white
              ),
            ),
            Text(
              "Rating: ${track.rating}",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Font",
                  color: Colors.white
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Text(
                  "$lyrics",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "Font",
                      color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff064170), Color(0xff171717)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            )
        ),
        child: isThere ? body : Center(child: Text("No Internet Available!!", style: TextStyle(color: Colors.white, fontFamily: "Font"),),),
      ),
    );
  }
}

