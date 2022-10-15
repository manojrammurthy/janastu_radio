import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' ;
import 'papadlistview.dart';

class PapadPage extends StatefulWidget {
  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<PapadPage> {
  

  /// Compulsory
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;

  /// Optional
  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          value: timeProgress.toDouble(),
          max: audioDuration.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    /// Compulsory
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    /// Optional
    audioPlayer.setSourceUrl(
        url); // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });
  }

  /// Compulsory
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  /// Compulsory
  playMusic() async {
    // Add the parameter "isLocal: true" if you want to access a local file
    await audioPlayer.play(UrlSource(url));
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  /// Optional
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer
        .seek(newPos); // Jumps to the given position within the audio file
  }

  /// Optional
  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Expanded(
              child: Container(
                alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Compulsory
              IconButton(
                  iconSize: 50,
                  onPressed: () {
                    audioPlayerState == PlayerState.playing
                        ? pauseMusic()
                        : playMusic();
                  },
                  icon: Icon(audioPlayerState == PlayerState.playing
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTimeString(timeProgress)),
                  SizedBox(width: 20),
                  Container(width: 200, child: slider()),
                  SizedBox(width: 20),
                  Text(getTimeString(audioDuration))
                ],
              )
            ],
          )),
              ),
          Expanded(
             child: AudioListView()
              )
          
        ]
    );
  }
}

