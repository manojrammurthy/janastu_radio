import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// class Audio {
//    Audio({required this.id, required this.name, required this.description, required this.audiolink});

//   final int id;
//   final String name;
//   final String description;
//   final  String audiolink;

//   factory Audio.fromJson(Map<String, dynamic> json) {
//     return Audio(
//       id: json['id'],
//       name: json['name'],
//       audiolink: json['upload'] ?? '',
//       description: json['description'] ,
//     );
//   }
// }

// // ignore: must_be_immutable
// class Audiobuild extends StatelessWidget{

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Audio>>(
//       future: _fetchAudios(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<Audio>? data = snapshot.data;
//           return _AudioListView(data);
//         } else if (snapshot.hasError) {
//           return Text("${snapshot.error}");
//         }
//         return CircularProgressIndicator();
//       },
//     );
//   }

//   Future<List<Audio>> _fetchAudios() async {

//       var dioRequest = dio.Dio();
//       //prod

//       dioRequest.options.baseUrl = 'https://stories.janastu.org/api/v1/';

//     //[2] ADDING TOKEN
//     dioRequest.options.headers['content-Type'] = 'application/json';
//     dioRequest.options.headers["Authorization"] = "Token bc535c2ebcc7379205d57cc90e6868849cd2a9a8";
//       //local
//     // dioRequest.options.baseUrl = 'http://127.0.0.1:8000/api/v1';

//     // //[2] ADDING TOKEN
//     // dioRequest.options.headers['content-Type'] = 'application/json';
//     // dioRequest.options.headers["Authorization"] = "Token 897f04bf657caad25954f6867fda09680f90421f";
//     try{
//     var response = await dioRequest.get("/archive/?group=16");
//         final result = json.decode(response.toString());
//     if (response.statusCode == 200) {
//       String jsonResponse = jsonEncode(result['results']);
//       List  jsonout = json.decode(jsonResponse);

//       return jsonout.map((audio) => new Audio.fromJson(audio)).where((i) =>i.audiolink != '').toList();
//     }
//     } on DioError  catch (ex) {
//       if(ex.type == DioErrorType.connectTimeout){
//         throw Exception("Connection Timeout Exception");
//       }
//       throw Exception(ex.message);
//     }
//     // else {
//       throw Exception('Failed to load jobs from API');
//     // }
//   }

//   ListView _AudioListView(data) {
//     return ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           return _tile(data[index].name, data[index].description, data[index].audiolink,Icons.music_note_rounded);
//         });
//   }

//   ListTile _tile(String title, String subtitle, String audiolink, IconData icon) => ListTile(
//             title: Text(title,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               fontSize: 20,
//             )),
//         subtitle: Text(subtitle),
//         leading: Icon(
//           icon,
//           color: Colors.blue[500],
//         ),
//         onTap: (){
//           print('clicked');
//           print(audiolink);
//           //AudioListView('https://soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3');
//         }
//         );
//  }

class Audioplay extends StatefulWidget {
  String audiolink;
  Audioplay(this.audiolink);
  @override
  _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
}

class _AudioPlayerUrlState extends State<Audioplay> {
  /// Compulsory
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.paused;
  //String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';

  /// Optional
  int timeProgress = 0;
  int audioDuration = 0;
  bool audioloaded = true;

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
    audioPlayer.setSourceUrl(widget.audiolink);

    //audioPlayer.setSourceUrl(url);
    // Triggers the onDurationChanged listener and sets the max duration string
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
        audioloaded = false;
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
    await audioPlayer.play(UrlSource(widget.audiolink));
    //await audioPlayer.play(UrlSource(url));
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('PapadPlayer'),
          ),
          body:  audioloaded ? Center(child: CircularProgressIndicator(strokeWidth: 6.0,
                  valueColor : AlwaysStoppedAnimation(Colors.blue),
                  backgroundColor: Colors.red,
                  )
                ):
          new Column(children: <Widget>[
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
          ]),
        ));
  }
}
