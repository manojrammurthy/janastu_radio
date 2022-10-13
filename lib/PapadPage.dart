import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' ;
import 'package:dio/dio.dart' as dio;
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';


part 'PapadPage.g.dart';


@JsonSerializable()
class Playlistdata {
  Playlistdata({
    required this.id,
    required this.name,
    required this.description,
    required this.audiolink,
  });

  int id;
  String name;
  @JsonKey(name: 'upload')
  String audiolink;
  String description;


  factory Playlistdata.fromJson(Map<String, dynamic> json) => _$PlaylistdataFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistdataToJson(this);
}

Future<void> loadlist() async {
  try {
   var dioRequest = dio.Dio();
    dioRequest.options.baseUrl = 'http://127.0.0.1:8000/api/v1';

    //[2] ADDING TOKEN
    dioRequest.options.headers['content-Type'] = 'application/json';
    dioRequest.options.headers["Authorization"] = "Token 897f04bf657caad25954f6867fda09680f90421f";
    var response = await dioRequest.get(
        "/?group=10/");
        //final result = json.decode(response.toString())['results'];
       print(response);
       //return result;
  }
  on DioError catch (e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print('Dio error!');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('HEADERS: ${e.response?.headers}');
    } else {
      // Error due to setting up or sending the request
      print('Error sending request!');
      print(e.message);
    }
    // Prints the raw data returned by the server
  }
}

class PapadPage extends StatefulWidget {
  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<PapadPage> {
  /// For clarity, I added the terms compulsory and optional to certain sections
  /// to maintain clarity as to what is really needed for a functioning audio player
  /// and what is added for further interaction.
  ///
  /// 'Compulsory': A functioning audio player with:
  ///             - Play/Pause button
  ///
  /// 'Optional': A functioning audio player with:
  ///             - Play/Pause button
  ///             - time stamps for progress and duration
  ///             - slider to jump within the audio file
  ///
  

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
    //loadlist();
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
    return Scaffold(
      body: Container(
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
                       IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => loadlist(),
                            ),

              /// Optional
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
    );
  }
}

