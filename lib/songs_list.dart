import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/bookmarks_screen.dart';
import 'package:music_player/local_data/save_data.dart';
import 'package:music_player/lyrics_detail.dart';
import 'package:music_player/modal/track.dart';
import 'package:music_player/networking/check_internet.dart';
import 'package:music_player/networking/get_songs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SongsList extends StatefulWidget {
  const SongsList({Key? key}) : super(key: key);

  @override
  _SongsListState createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  List<Track> tracks = [];
  bool isThere = true;
  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  void checkInternet() async {
    isThere = await CheckInternet().checkConnection();
    print(isThere);
    setState(() {});
    if (isThere) {
      getSongs();
    }
  }

  void getSongs() async {
    tracks = await GetSongs().getSongs();
    setState(() {});
  }

  void timer() {
    int isRun = 0;
    Timer.periodic(Duration(seconds: 1), (timer) async {
      bool isNetwork = await CheckInternet().checkConnection();
      if (!isNetwork) {
        isRun = 1;
        isThere = false;
        setState(() {});
      }

      if (isRun == 1 && isNetwork) {
        isRun = 0;
        if (isNetwork) {
          isThere = true;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timer();
    var body = tracks.isEmpty
        ? Center(
            child: SpinKitDoubleBounce(
            color: Colors.white,
          ))
        : ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, num) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        splashColor: Colors.black87,
                        highlightColor: Colors.black87,
                        focusColor: Colors.black87,
                        hoverColor: Colors.black87,
                        child: ListTile(
                          onLongPress: () {
                            SaveData.addTracks(tracks[num]);
                            print("added");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Added to bookmarks, to remove go to bookmarks page and long press on the song",
                                style: TextStyle(
                                    fontFamily: "Font", color: Colors.white),
                              ),
                              duration: Duration(seconds: 5),
                            ));
                          },
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LyricsDetail(
                                  tracks[num].trackId, tracks[num].hasLyrics);
                            }));
                          },
                          title: Text(
                            "${tracks[num].trackName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Font",
                                fontSize: 25),
                          ),
                          subtitle: Text(
                            "${tracks[num].albumName}",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Font"),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 1,
                    )
                  ],
                ),
              );
            },
          );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Song Lyrics",
          style: TextStyle(fontFamily: "Font", color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksScreen()));
            },
            icon: Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff064170), Color(0xff171717)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          )),
          child: isThere
              ? body
              : Center(
                  child: Text(
                    "No Internet Available!!",
                    style: TextStyle(color: Colors.white, fontFamily: "Font"),
                  ),
                )),
    );
  }
}
