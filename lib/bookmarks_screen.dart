import 'package:flutter/material.dart';
import 'package:music_player/local_data/save_data.dart';
import 'package:music_player/lyrics_detail.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<String>? trackIds = [];
  @override
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() {
    trackIds = SaveData.getTracks() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0xff064170), Color(0xff171717)],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      )),
      child: ListView.builder(
        itemCount: trackIds!.length,
        itemBuilder: (context, index) {
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
                      onLongPress: () async {
                        bool isDeleted = await SaveData.removeTrack(trackIds![index]);
                        print(isDeleted);
                        if (isDeleted) {
                          setState(() {
                            getTracks();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Error! Try Again",
                              style: TextStyle(
                                  fontFamily: "Font", color: Colors.white, fontSize: 20),
                            ),
                            duration: Duration(seconds: 1),
                          ));
                        }
                      },
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => LyricsDetail(int.parse(trackIds![index].split("*")[0]),
                            int.parse(trackIds![index].split("*")[2])))
                        );
                      },
                      title: Text(
                        "${trackIds![index].split("*")[1]}",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Font"
                        ),
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
      ),
    ));
  }
}
