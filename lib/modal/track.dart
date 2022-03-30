class Track {
  int trackId;
  String trackName;
  int hasLyrics;
  int albumId;
  String albumName;
  String singerName;
  int explicit;
  int rating;
  Track({required this.trackId, required this.trackName, required this.hasLyrics, required this.albumId, required this.albumName, this.singerName = "", this.explicit = 0, this.rating = 0});

  String toString() {
    return "$trackId $trackName $hasLyrics $albumId $albumName";
  }
}